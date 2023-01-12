---
author: Benji Fisher
title: 'Local Dev Environments: Lando vs Drupal VM'
date: August 4, 2020
revealjs-url: 'reveal.js'
theme: solarized
---

# Introduction

## Follow along

- [https://benjifisher.gitlab.io/slide-decks/index.html](https://benjifisher.gitlab.io/slide-decks/index.html)

## About Me

<div style="display: inline-block; width: 20%">
![Yellow Pig](./images/yp.jpeg)\ 
</div>
<div style="display: inline-block; width: 70%">
- Benji Fisher
- [\@benjifisher](https://www.drupal.org/u/benjifisher) on d.o since 2010-01
- [\@benjifisher](https://github.com/benjifisher) on GitHub
- [\@benjifisher](https://gitlab.com/benjifisher) on GitLab
- [\@benji17fisher](https://twitter.com/benji17fisher) on Twitter
</div>

## About ???

## Outline

- Introduction
- Lando vs. Drupal VM
- Drupal and Gatsby with Lando
- Automated Tests with Lando
- Other Stuff (optional)

# Lando vs. Drupal VM

## Current Project: ACSF and BLT

- Lando is my usual preference.
- Drupal VM may have better performance, esp. on Macs.
- Plan: support both, test performance, optimize.

## Lando Quick Start

- Install Lando: [https://docs.lando.dev/basics/installation.html](https://docs.lando.dev/basics/installation.html)
- `git clone ...`
- `cd ...`
- `lando composer install`
- `lando blt setup`

## Lando Config (snippet)

```yaml
tooling:
    blt:
        service: appserver
        cmd: /app/vendor/bin/blt
```

## Drupal VM Requirements

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)
- PHP, at least version 7.3.0.
- Composer, at least version 1.10.1.
- Git
- Ansible (optional, for performance)
- Python 3

## Drupal VM Quick Start

- `git clone ...`
- `cd ...`
- `composer install`
- `vagrant up`
- `vagrant ssh`
- `blt setup`

# Drupal and Gatsby with Lando

## My Drupal/Gatsby Quick Start

- One repo, one Lando file, get Drupal and Gatsby
- `git clone https://gitlab.com/benjifisher/lando-gatsby-drupal.git`
- `cd lando-gatsby-drupal`
- `lando start`

Lando Gatsby Drupal: [https://gitlab.com/benjifisher/lando-gatsby-drupal](https://gitlab.com/benjifisher/lando-gatsby-drupal)

## LGD Config

```yaml
name: lando-gatsby-drupal

recipe: drupal8
config:
  via: nginx
  webroot: drupal/web
  php: '7.4'
  database: mariadb

services:
  appserver:
    build:
      - cd drupal && composer install
    run:
      - echo "Install Drupal with drush."
      - drupal/scripts/install.sh
  nodejs:
    type: node
    ssl: true
    globals:
      gatsby-cli: "2.12.62"
      yarn: "1.22.4"
    run:
      - echo "Installing Gatsby with yarn."
      - cd gatsby && yarn install
  appserver_nginx:
    ssl: true
    sslExpose: true
    type: nginx
    build_as_root:
      - cp /app/conf/nginx/drupal.lgd.lndo.site.conf /opt/bitnami/nginx/conf/vhosts/.
      - cp /app/conf/nginx/gatsbydrupal.lgd.lndo.site.conf /opt/bitnami/nginx/conf/vhosts/.

events:
  post-start:
    - nodejs: echo "Building the Gatsby site from Drupal."
    - nodejs: cd gatsby && gatsby build
    - nodejs: rm -rf gatsbydrupal/* && cp -R gatsby/public/* gatsbydrupal

proxy:
  nodejs:
    - gatsby.lgd.lndo.site:8000
  appserver_nginx:
    - drupal.lgd.lndo.site
    - gatsbydrupal.lgd.lndo.site

tooling:
  npm:
    service: nodejs
  node:
    service: nodejs
  gatsby:
    service: nodejs
  yarn:
    service: nodejs
```

# Automated Tests with Lando

## Lando + Drupal Contribution (@serundeputy)

- [https://github.com/thinktandem/drupal-contributions](https://github.com/thinktandem/drupal-contributions)
- Download/install Drupal
- Apply/create a patch
- Run tests

## Automated Tests

- Hard part: run `chromedriver` for JS tests.
- Blog post: [How to run Drupal’s PHPUnit tests in Lando](https://agile.coop/blog/drupal-phpunit-tests-lando/)
  (Tancredi D'Onofrio, `agile.coop`)
- Twitter (@AgileCollective, @karimboudjema, @serundeputy, @benji17fisher)
- Pull Request

## Lando Config for Testing

```yaml
name: drupal-contributions
recipe: drupal8
config:
  webroot: web

services:
  appserver:
    run:
      # @todo remove invocation of drupal-phpunit-upgrade again once https://www.drupal.org/project/drupal/issues/3099061 is resolved.
      - cd /app/web && composer install && composer run-script drupal-phpunit-upgrade
    overrides:
      environment:
        SIMPLETEST_BASE_URL: "https://drupal-contributions.lndo.site/"
        SIMPLETEST_DB: "sqlite://localhost/tmp/db.sqlite"
        MINK_DRIVER_ARGS_WEBDRIVER: '["chrome", {"browserName":"chrome","chromeOptions":{"args":["--disable-gpu","--headless", "--no-sandbox"]}}, "http://chrome:9515"]'
  chrome:
    type: compose
    app_mount: false
    services:
      image: drupalci/webdriver-chromedriver:production
      command: chromedriver --log-path=/tmp/chromedriver.log --verbose --whitelisted-ips=

tooling:
  drush:
    service: appserver
    cmd:
      drush --root=/app/web --uri=https://drupal-contributions.lndo.site
  si:
    service: appserver
    description: Install Drupal
    cmd:
      - appserver: /app/scripts/site-install.sh
  patch:
    service: appserver
    description: Get a patch from a Drupal project issue queue
    cmd:
      - appserver: php /app/scripts/patch-helpers.php
    options:
      url:
        describe: The url of the patch from the issue queue
  revert:
    service: appserver
    description: Apply a patch from a Drupal project issue queue
    cmd:
      - appserver: php /app/scripts/patch-helpers.php --revert
    patch:
      describe: The name of the patch to revert; i.e. DESCRIPTION-XXXXXXX-YY.patch
  create-patch:
    service: appserver
    description: Creat a patch from your committed changes on your branch.
    cmd:
      - appserver: php /app/scripts/patch-helpers.php --create-patch
  phpunit:
    service: appserver
    user: www-data
    cmd:
      - appserver: /app/web/vendor/bin/phpunit -c /app/config

  test:
      service: appserver
      cmd:
        - php /app/web/core/scripts/run-tests.sh --php /usr/local/bin/php --url https://drupal-contributions.lndo.site --color --verbose

events:
  post-destroy:
    - rm -rfv web
  pre-rebuild:
    - rm -rfv web
    - appserver: php /app/scripts/get-drupal.php
  post-rebuild:
    - appserver: /app/scripts/rebuild.sh
```

# Other Stuff (optional)

## Fences

Fences: [https://www.drupal.org/project/fences](https://www.drupal.org/project/fences)

- 8.x-2.0-rc1 released 26 May 2020 
- Fix automated tests, make compatible with D9
- [https://www.drupal.org/node/3101948](https://www.drupal.org/node/3101948)

## Drupal 8.9.0 Release Notes

Two issues called out under "Corrected deprecation errors" in release notes:

- Update deprecation notices in NodeNewComments constructor: [https://www.drupal.org/project/drupal/issues/3137713](https://www.drupal.org/project/drupal/issues/3137713)
- Add missing E_USER_DEPRECATED to deprecation notices: [https://www.drupal.org/node/3138591](https://www.drupal.org/node/3138591)

Both were Novice issues that I created.

## Migrate API

- Add benjifisher as a sub-system maintainer for migrate: [https://www.drupal.org/project/drupal/issues/3137268](https://www.drupal.org/project/drupal/issues/3137268)
