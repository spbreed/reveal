---
author: Benji Fisher
title: "Security in Drupal: what can go wrong?"
date: May 27, 2022 - DrupalCamp NJ
revealjs-url: 'reveal.js'
theme: solarized
---

# Introduction

## About me

<div style="display: flex; justify-content: space-between;">
<div style="width: 25%">
![Yellow Pig](./images/yp.jpeg){style="margin: 0;"}\ 
</div>
<div style="width: 70%">
- Benji Fisher
- [\@benjifisher](https://www.drupal.org/u/benjifisher) on d.o
- [\@benjifisher](https://github.com/benjifisher) on GitHub
- [\@benjifisher](https://gitlab.com/benjifisher) on GitLab
- [\@benji17fisher](https://twitter.com/benji17fisher) on Twitter
</div>
</div>

Migration subsystem, Usability group, Security team (provisional member)

## About Fruition

<div style="display: flex; justify-content: space-between;">
<div style="width: 50%; background-color: #00a5e5; color: #fff;">
![Fruition logo](images/white-fruition-logo.svg){style="height: 50px; border: none; background: none; box-shadow: none;"}\ 

Build. Grow. Protect.
</div>

<div>
- Digital Marketing
- Website Design
- Development
- Security & Hosting
</div>
</div>

[https://fruition.net/](https://fruition.net/)

## Follow along

Find a link to this presentation on my GitLab Pages:

- [https://slides.benjifisher.info/](https://slides.benjifisher.info/)

## Outline

- Introduction
- What is the OWASP Top Ten?
- What is Drupal?
- A01:2021-Broken Access Control
- A02:2021-Cryptographic Failures
- A03:2021-Injection
- A04:2021-Insecure Design
- A05:2021-Security Misconfiguration
- ...

## Outline (continued)

- ...
- A06:2021-Vulnerable and Outdated Components
- A07:2021-Identification and Authentication Failures
- A08:2021-Software and Data Integrity Failures
- A09:2021-Security Logging and Monitoring Failures
- A10:2021-Server-Side Request Forgery
- Conclusion

## Attribution

These slides borrow a lot of text from [https://owasp.org/](https://owasp.org/).
According to the standard footer,

> Unless otherwise specified, all content on the site is Creative Commons
> Attribution-ShareAlike v4.0 and provided without warranty of service or
> accuracy.

All of my slide decks have a similar license: see the [last slide](#copyleft).

# What is the OWASP Top Ten?

## Open Web Application Security Project® (OWASP)

> The Open Web Application Security Project® (OWASP) is a nonprofit foundation
> that works to improve the security of software.

source: [https://owasp.org/](https://owasp.org/)

OWASP is not Drupal-specific.
Let's "get off the island"!

## OWASP Top Ten

> The OWASP Top 10 is a standard awareness document for developers and web
> application security. It represents a broad consensus about the most critical
> security risks to web applications.

source: [https://owasp.org/www-project-top-ten/](https://owasp.org/www-project-top-ten/)

The list is updated every few years.
The most recent version is from 2021.

# What is Drupal?

## Drupal: a content management system

Drupal is a web-based content management system (CMS):

> Enter data in my forms. I will save it to the database, then generate web
> pages.

Hacker:

> Sounds great. Let's get started!

## Drupal: an active, international OSS project

> The [Drupal community](https://www.drupal.org/community) is one of the largest
> open source communities in the world. We're more than 1,000,000 passionate
> developers, designers, trainers, strategists, coordinators, editors, and
> sponsors working together.

source: [https://www.drupal.org/about](https://www.drupal.org/about)

## Drupal: take security seriously

> The security team is an all-volunteer group of individuals who work to improve
> the security of the Drupal project. Members of the team come from countries
> across 3 continents ...
> The team was formalized in 2005 with a mailing list and has had 3 team leads
> in that time period.

source: [https://security.drupal.org/team-members](https://security.drupal.org/team-members)

# A01:2021-Broken Access Control

# A02:2021-Cryptographic Failures

# A03:2021-Injection

## Injection: what goes wrong

- User-supplied data is not validated, filtered, or sanitized by the application.
- Dynamic queries ... are used directly in the interpreter.
- Hostile data is used within ... search parameters to extract additional, sensitive records.
- Hostile data is directly used or concatenated. ...

source: [A03:2021 - Injection](https://owasp.org/Top10/A03_2021-Injection/)

## Injection: xkcd 327

![xkcd cartoon suggesting "Robert'); DROP TABLE Students; --" as a name](images/exploits_of_a_mom.png)\ 

source: [https://xkcd.com/327/](https://xkcd.com/327/)

## Injection in Drupal: SA-CORE-2014-005

Drupal 7 includes a database abstraction API to ensure that queries executed
against the database are sanitized to prevent SQL injection attacks.

A vulnerability in this API allows an attacker to send specially crafted
requests resulting in arbitrary SQL execution. ...
this can lead to privilege escalation, arbitrary PHP execution, or
other attacks.

This ... can be exploited by anonymous users.

source: [SA-CORE-2014-005](https://www.drupal.org/forum/newsletters/security-advisories-for-drupal-core/2014-10-15/sa-core-2014-005-drupal-core-sql)

## Injection: my response

> Because of the severity of the vulnerability and the simplicity of the update,
> we tested ... and updated the site today.

source: my e-mail to boss and site owner (paraphrase)

## Injection: the update

### Vulnerable code

```php
      foreach ($data as $i => $value) {
        $new_keys[$key . '_' . $i] = $value;
      }
```

### Fixed code

```php
      foreach (array_values($data) as $i => $value) {
        $new_keys[$key . '_' . $i] = $value;
      }
```

(comment snipped from both)

## Injection: the next step

```php
      // Update the query with the new placeholders.
      // preg_replace is necessary to ensure the replacement does not affect
      // placeholders that start with the same exact text. For example, if the
      // query contains the placeholders :foo and :foobar, and :foo has an
      // array of values, using str_replace would affect both placeholders,
      // but using the following preg_replace would only affect :foo because
      // it is followed by a non-word character.
      $query = preg_replace(
        '#' . $key . '\b#',
        implode(', ', array_keys($new_keys)),
        $query
      );
```

(line breaks added)

# A04:2021-Insecure Design

# A05:2021-Security Misconfiguration

# A06:2021-Vulnerable and Outdated Components

## The best kept secret in web security

The secret:

The most important thing is to do all the boring stuff you *already know*.

It is a lot like ...

## Click bait?

How to live a longer, healthier life!

It takes just 4 minutes a day!

Does that seem too good to be true?

## Brush your teeth!

- Two minutes, two times a day.
- Best advice you will get today.
- Also floss.
- You really will live a longer, healthier life.

## Web security hygiene

- Use good passwords. Have a policy.
- Keep your software up to date.
- Unless hosting is your core business, do not run your own servers.

## Drupal: know the schedule

- Security release windows: Wednesdays 12-5 ET
- Drupal core updates (patch versions): third Wednesdays
- Drupal core updates (minor versions): June and December
- Minor versions are supported for one year.

## Drupal: know the channels

- Web: [Security advisories](https://www.drupal.org/security)
- RSS: [https://drupal.org/security/rss.xml](https://drupal.org/security/rss.xml),
  [https://drupal.org/security/contrib/rss.xml](https://drupal.org/security/contrib/rss.xml), [https://drupal.org/security/psa/rss.xml](https://drupal.org/security/psa/rss.xml)
- Email: [https://www.drupal.org/user](https://www.drupal.org/user) (Edit > My
  newsletters)
- Slack: `#security-questions` channel in [Drupal Slack](https://www.drupal.org/community/contributor-guide/reference-information/talk/tools/slack)

Unofficial: [\@drupalsecurity](https://twitter.com/drupalsecurity) on Twitter (other?)

## Drupal: know the difference

- Major version (Drupal 9 to Drupal 10): disruptive
- Minor version (9.3 to 9.4): less disruptive, new features
- Patch version (9.3.6 to 9.3.7): should not be disruptive, bug fixes
- Security release (9.3.7 to 9.3.8): not disruptive (best effort)

## Drupal and Symfony

Q: Why is Drupal 9 EOL scheduled for Nov. 2023?

A: Drupal 9 uses Symfony 4, which is EOL in Nov. 2023.

# A07:2021-Identification and Authentication Failures

# A08:2021-Software and Data Integrity Failures

# A09:2021-Security Logging and Monitoring Failures

# A10:2021-Server-Side Request Forgery

# Conclusion

## Summary

- Introduction
- What is the OWASP Top Ten?
- What is Drupal?
- A01:2021-Broken Access Control
- A02:2021-Cryptographic Failures
- A03:2021-Injection
- A04:2021-Insecure Design
- A05:2021-Security Misconfiguration
- ...

## Summary (continued)

- ...
- A06:2021-Vulnerable and Outdated Components
- A07:2021-Identification and Authentication Failures
- A08:2021-Software and Data Integrity Failures
- A09:2021-Security Logging and Monitoring Failures
- A10:2021-Server-Side Request Forgery
- Conclusion

## References

- [Benji's slide decks](https://slides.benjifisher.info/) and [source files](https://gitlab.com/benjifisher/slide-decks)
- [OWASP Top Ten](https://owasp.org/www-project-top-ten/) and [OWASP Top 10:2021](https://owasp.org/Top10/)
- [Drupal Security Team](https://www.drupal.org/drupal-security-team)
- [Drupal core release cycle: major, minor, and patch releases](https://www.drupal.org/about/core/policies/core-release-cycles/schedule)
- [Security advisories](https://www.drupal.org/security)

## Questions
