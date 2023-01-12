---
author: Benji Fisher
title: 'BLT, ACSF, and Drupal&nbsp;9'
date: September 1, 2020
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
- Co-maintainer of the Migrate API in Drupal core
</div>

## About ???

## Outline

- Introduction
- The old BLT
- The new BLT
- Does it work?

# The old BLT

## What is BLT?

- BLT: Build and Launch Tool 
- https://docs.acquia.com/blt/
- https://github.com/acquia/blt

### Features

- Integration with Acquia Cloud (AC) and Site Factory (ACSF)
- Automatic code linting/validation
- Set up Behat testing
- Accumulated wisdom of Acquia Professional Services (PS) team

## What's Not to Like?

- pronounced "bloat"?
- All your base are belong to us!
- _L'etat, c'est moi!_

```bash
composer create-project \
    --no-interaction \
    acquia/blt-project my-project
```

- Manage `settings.php` and includes
- Manage Config Split

# The new BLT

## Compatibility Chart

| BLT | Drupal | Drush |
|:-----|:---------|:------------|
| 11.x | 8.8, 8.9 | 9.5, 10.0.1 |
| 12.x | 9.0      |      10.0.1 |

## Modular Design

`composer require` ...

- `acquia/blt`
- `acquia/blt-acsf`
- `acquia/blt-behat`
- `acquia/blt-vm`
- `acquia/blt-phpcs`
- `acquia/blt-simplesamlphp`
- `acquia/blt-probo`
- `acquia/blt-tugboat`

## WIP

- BLT 12 has a full release; latest is 12.2.0
- None of the plugins has a release yet
- Some of the plugins are broken
- Some of the plugins are partially separated

# Does it work?

## Recent bug reports

- BLT 12 overwrites drush site alias `default.site.yml`
- BLT 12 checks `isAcsfInited()` instead of `isAcsfEnv()` in `default.local.settings.php`
- Do not assume Drupal VM is in use because config file is there
- Multisite recipe should use actual site URL in drush alias
- Provide an option to skip web driver launching (`blt-behat`)

## Yes, it works!

I had to fix most of those bugs myself. There is at least one that I am still
working around, and one where my fix was rejected.

My colleague Marco Villegas reported and fixed the `blt-behat` bug.

We have Drupal 9 test sites running on Site Factory (ACSF).
