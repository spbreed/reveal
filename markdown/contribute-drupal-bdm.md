---
author: Benji Fisher
title: "Contributing to Drupal"
date: March 3, 2020
revealjs-url: 'reveal.js'
# theme: beige
# theme: serif
theme: solarized
---

# Introduction

## About me

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

## Follow along

Find a link to this presentation on my GitLab Pages:

- [https://benjifisher.gitlab.io/slide-decks/index.html](https://benjifisher.gitlab.io/slide-decks/index.html)

## Summary

- The issue funnel
- Why I review issues
- Help wanted! (Some non-code contributions)

# The issue funnel

## How many?

### Drupal core issues: 8.x, 2020-03-03

| Status | Number |
|--------|--------|
| Active | 8174 |
| Needs Work | 4582 |
| Needs Review | 2857 |
| RTBC | 77 |
| Fixed | 63 |
| Other | 1419 |

## How many?

### Drupal core issues: 8.x, 2020-03-03

![Pie chart](./images/issues-pie-chart.png)\ 

## Who can move?

### Drupal core issues: 8.x, 2020-03-03

| Status | Number | Mover |
|--------|--------|-------|
| Active | 8174 | Developer |
| Needs Work | 4582 | Developer |
| Needs Review | 2857 | Reviewer |
| RTBC | 77 | Committer |
| Fixed | 63 | N/A |
| Other | 1419 | ??? |

# Why I review issues

## Committers

From [core/MAINTAINERS.txt](https://git.drupalcode.org/project/drupal/raw/HEAD/core/MAINTAINERS.txt)

<div style="display: inline-block; width: 45%">
- `dries`
- `webchick`
- `Gábor Hojtsy`
- `yoroy`
- `effulgentsia`
- `catch`
</div>
<div style="display: inline-block; width: 45%">
- `plach`
- `alexpott`
- `larowlan`
- `lauriii`
- `catch`
- `xjm`
</div>

## Reviewers

What does a reviewer have to do?

- Test
- Code review
- Improve the patch

Most important:

- Protect the committers' time

## Example: restructure

From [Comment #80](https://www.drupal.org/project/drupal/issues/2991207#comment-13282385)
on #2991207:

> I would like to see the class of helper functions replaced with something
> more object-oriented: ...

(`@benjifisher`)

## Example: protect committers' time

From [#3110186](https://www.drupal.org/project/drupal/issues/3110186):

- `@xjm` (#58): `Issue tags: +needs followup`<br>
  ...
  I think there's some refactoring that should maybe be done, but that also would be a followup.

- `@benjifisher` (#61): `Issue tags: -needs followup`<br>
  I added #3117157: ...

- `@xjm` (#62): Perfect, thanks `@benjifisher`!

# Help wanted!

## Drupal core calendar

[drupalcorecalendar@association.drupal.org](https://calendar.google.com/calendar/embed?src=drupalcorecalendar%40association.drupal.org&ctz=America%2FNew_York)

![Drupal core calendar for the week of 2020-03-09 in Eastern time (ET)](./images/drupal-core-calendar.png)\ 

## Weekly meetings

- New front-end theme initiative
- All things Drupal 9
- API-First weekly meeting
- Getting Involved Guide refresh
- Out of the box initiative meeting
- Layout initiative meeting
- Admin UI meeting
- Meta mentoring meeting
- Weekly UX meeting
- Migrate meeting

## Weekly UX meeting

- Zoom (announced on Slack)
- Issues tagged "Needs usability review"
- IA, wordsmithing, usability
- Take notes, comment on issues, open new issues

## Migrate meeting

- Threaded Slack discussion
- Saved as Meeting issues
- Issues tagged NR in migration component

From [Migrate Meeting 2020-02-27](https://www.drupal.org/project/drupal/issues/3116548):

![Part of the Migrate Meeting from 2020-02-27: "What do we need to talk about? ..."](./images/migrate-meeting.png)\ 
