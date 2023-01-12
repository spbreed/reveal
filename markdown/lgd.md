---
author: Benji Fisher
title: 'Drupal+Gatsby Quick Start with Lando'
date: March 5, 2019
revealjs-url: 'reveal.js'
theme: isovera
css:
  - 'https://fonts.googleapis.com/css?family=Roboto+Slab:700'
---

## What is Gatsby?

Gatsby (https://www.gatsbyjs.org/) is a "static" site generator.

It creates a high-performance React app based on sources:

- Files: HTML, Markdown, JSON, ...
- Anything it can query with GraphQL
- Drupal, WordPress, ...

## How Drupal works with Gatsby

1. Add the JSON:API module to Drupal.
1. Add the Drupal source plugin to Gatsby.
1. Profit.

## Umami home page

![Drupal home page (Umami demo install)](./images/drupal-umami.png)

## JSON:API

<div style="max-height: 500px; overflow: scroll">
![Drupal with JSON:API module](./images/drupal-jsonapi.png)
</div>

I have a browser plugin that prettifies the JSON.

## GraphQL queries

![GraphQL queries from Gatsby develop](./images/gatsby-graphql.png)

## Gatsby home page

![Gatsby default starter page](./images/gatsby-home.png)

## Gatsby blog list

![Bare blog list in Gatsby](./images/gatsby-blog-list.png)

## Gatsby blog page

![Bare blog post in Gatsby](./images/gatsby-carrots.png)

## Lando configuration

<div style="background: white">
```yaml
name: lando-gatsby-drupal

recipe: drupal8
config:
  via: nginx
  webroot: drupal/web
  php: 7.2
  database: mariadb

proxy:
  nodejs:
    - gatsby.lgd.lndo.site:8000
  appserver_nginx:
    - drupal.lgd.lndo.site
    - gatsbydrupal.lgd.lndo.site

services:
  appserver:
    build:
      - cd drupal && composer install
    run:
      - echo "Clearing out user files from the Drupal site."
      - rm -rf /app/drupal/web/sites/default/files
      - cd drupal/web && drush --yes site:install demo_umami --db-url=mysql://drupal8:drupal8@database:3306/drupal8 --account-pass=admin --site-name='Drupal-Gatsby'
      - cd drupal/web && drush --yes pm:enable jsonapi
      - cd drupal/web && drush --yes pm:uninstall contact
  nodejs:
    type: node
    ssl: true
    globals:
      gatsby-cli: "latest"
      yarn: "1.13.0"
    run:
      - echo "Installing Gatsby with yarn."
      - cd gatsby && yarn install
  appserver_nginx:
    type: nginx
    build_as_root:
      - cp /app/conf/nginx/drupal.lgd.lndo.site.conf /opt/bitnami/nginx/conf/vhosts/.
      - cp /app/conf/nginx/gatsbydrupal.lgd.lndo.site.conf /opt/bitnami/nginx/conf/vhosts/.

events:
  post-start:
    - nodejs: echo "Building the Gatsby site from Drupal."
    - nodejs: cd gatsby && gatsby build

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
</div>

## What's new?

- 2018-09-17: Gatsby 2.0.0
- 2019-01-07: JSON:API module for Drupal 8.x-2.0
- 2019-01-11: `gatsby-source-drupal@3.0.18`
- 2019-02-01: Lando v3.0.0-rc.2

All of these projects have more recent releases.

The above versions are the minimal requirements to get this all to work
together.

## Do try this at home!

Check out my repository on GitLab:

- [https://gitlab.com/benjifisher/lando-gatsby-drupal](https://gitlab.com/benjifisher/lando-gatsby-drupal)

File a bug report or help with one of the existing issues!
