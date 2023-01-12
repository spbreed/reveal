---
author: Benji Fisher
title: "New LAMPs for Old: Drupal well by Drupaling good"
date: March 9, 2021
revealjs-url: 'reveal.js'
theme: solarized
---

# Introduction

## About me

Benji Fisher\
[Fruition](https://fruition.net/)\
drupal.org: [benjifisher](https://www.drupal.org/u/benjifisher)\
twitter: [\@benji17fisher](https://twitter.com/benji17fisher)

## Follow along

Find a link to this presentation on my GitLab Pages:

- [https://benjifisher.gitlab.io/slide-decks/index.html](https://benjifisher.gitlab.io/slide-decks/index.html)

## Outline

- Introduction
- Lando for Local Development
- GitLab for Project Hosting
- What's My Line?
- Wicked Local Development
- The Best Laid Plans
- Conclusion

## The Five Ws

- Who: You, me, any friends we can get to join us
- What: Upgrade a legacy site (D6 or D7) to Drupal 9 (D9)
- Where: Greater Boston
- Why:
  - Help out a worthy cause.
  - Learn by doing.
  - Get to know each other by working together.
  - When: Start today, check in next month.

# Lando for Local Development

## Get Lando

1. [https://lando.dev/download/](https://lando.dev/download/)
1. Follow the [download](https://github.com/lando/lando/releases) link.
1. Follow instructions.

## Why Lando

- You can run your Drupal site from your own computer.
- There are other options. I like Lando, and this project uses it.
- Give it a try. At least start the download.
- More to come: [Wicked Local Development](#wicked-local-development)

# GitLab for Project Hosting

## Get a GitLab account (free)

If you want to participate in this project, get an account.

1. [https://about.gitlab.com/pricing/](https://about.gitlab.com/pricing/)
1. FREE box: "Start now" button
1. Give me your user name on Slack or Zoom chat.
1. Get an invitation to the project.

## Why GitLab

- Issues
- Wiki
- Code repository (git)
- Time tracking
- Much more

# What's My Line?

## What do you like to do/learn?

- Project management
- Documentation
- Promotion
- Planning
- Migration
- Site building

## Project management

- Create and organize issues.
- Find bottlenecks.
- Make issue templates.
- I don't know, _you_ tell _me_!

## Documentation

- Write and test documentation.
- Start with the Wiki.
- Markdown everywhere!

## Promotion

- Social media
- Blog posts
- Get your friends involved.

## Planning

- Make an issue if you need to.
- Get the legacy site running: [Wicked Local Development](#wicked-local-development)
- List all the ... on the legacy site:
  - modules
  - views
  - content types/fields
  - menus

## Migration

1. Find the custom module.
1. Look in the `migrations/` directory.
1. Use one of the existing files as a model.

## Site building

1. Create fields and content types. Export as site config.
1. Create views.
1. Add, enable, and configure modules.

# Wicked Local Development

## Get the files

1. Make a directory, say `boston-drupal-meetup`.
1. Find the "Clone" button on the project page.
1. Copy the URL.
1. In `boston-drupal-meetup`, `git clone ...` (paste URL).

If you do not like command line or `git`, find the Releases tab. D/l a tarball.

## Start your LAMP stack

1. In terminal, go to `boston-drupal-meetup/newsite`.
1. `lando start`
1. `lando composer install`
1. `lando drush site:install --db-url=mysql://drupal9:drupal9@database/drupal9 --existing-config`
1. `lando drush user:login`

## Do it again!

Follow the same steps to create `boston-drupal-meetup/legacy` and start the legacy site.

# The Best Laid Plans

## TODO

# Conclusion

## TODO

- Introduction
- Lando for Local Development
- GitLab for Project Hosting
- What's My Line?
- Wicked Local Development
- The Best Laid Plans
- Conclusion


