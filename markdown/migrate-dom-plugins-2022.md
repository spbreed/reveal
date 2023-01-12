---
author: Benji Fisher
title: "Build Back Better - with the Migrate API"
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
- Bringing Data Into Drupal
- Migrate API Introduction
- Examples
  1. Use Editor styles
  1. Structure unstructured content
  1. Update links in body text
  1. Update from Drupal 7 Media
- Conclusion

# Bringing Data Into Drupal

## Upgrading from Drupal 6 or Drupal 7

> I need to update my Drupal 6 site. Better late than never!

- Q: What tool will you use?
- A: The Migrate API

## Upgrading from other systems

> I am getting tired of WordPress, but I have all these posts that I want to
> keep. How can I switch to Drupal?

- Q: What tool will you use?
- A: The Migrate API

## Recurring imports (feeds)

> I need to create Drupal content every hour from an external Atom feed (or
> XML/JSON/SOAP/CSV)

- Q: What tool will you use?
- A: The Migrate API

Did anyone say "Feeds module"?

## Restructure a live site

> I need to change the structure of my live Drupal site: add/remove a field,
> move field data to linked Paragraphs, ...

- Q: What tool will you use?
- A: It depends. Use the Migrate API if you
    - need to track old/new entity IDs
    - have complex dependencies
    - can use the tools it provides

# Migrate API Introduction

## One project, many migrations

- Each migration has one source: SQL, CSV, XML, ...
- Each migration creates one entity type:
    - node
    - media
    - taxonomy term
    - user
    - ...
- A single XML file can be the source of several entity types, several migrations
- A site upgrade can have dozens of migrations

## One migration, three stages

Three stages: Extract, Transform, Load (ETL)

- Extract (source plugin): one per migration
- Transform (process plugins): one or more per field/property
- Load (destination plugin): one per migration

Quiz: which stage is the most fun?

## Transform/process: apply filters

Filter pipelines:

- Bash: `git branch --merged | grep feature | xargs git branch -d`
- Twig: `list | map(item => item|lower) | join(', ')`

Each step gets its input from the previous one.

The Transform/Process stage of the Migrate API works the same way.

## Process plugins

Drupal core and contrib modules provide many filters, or **process plugins**.

Most are configurable.

Learning to use them and combine them into pipelines takes some practice.

## Process pipeline (example)

The Migrate API uses YAML to describe pipelines.
([explanation](https://www.drupal.org/docs/drupal-apis/migrate-api/process-pipelines)
of this example)

```yaml
process:
  field_formatted_text:
    - plugin: callback
      source: old_field
      callable: htmlentities
    - plugin: str_replace
      search: ['&#160;', '&nbsp;']
      replace: ' '
    - plugin: callback
      callable: trim
```

## DOM processing

Convert a text field (HTML string) to a DOMDocument object, process it, and
save it as a string:

```yaml
process:
  'body/value':
    - plugin: dom
      method: import
      source: 'body/0/value'
    # Other plugins do their work here.
    - plugin: dom
      method: export
```

The `body/0/value` bit is a short-cut. It is more complicated for multi-valued fields.

## XPath Examples

Use an XPath `selector` to identify one or more elements in a DOMDocument object:

| `selector` | Matches |
|-------------|---------|
| `//a` |  all `<a>` elements |
| `//a[class="external"]` |  all `<a>` elements with `class="external"` |
| `//li[class="nav"]/a` |  all `<a>` elements direct children of `<li class="nav">` |

# Example: Use Editor styles

## The Challenge

> I have to import documentation pages from an external system. The
> documentation is formatted as HTML, but it does not have the magic CSS
> classes that my theme uses. How can I make it match the site style guide?

## Editor styles

![editor styles configuration](images/editor-styles-config.png)\ 

![editor styles](images/editor-styles.png)\ 

## Apply styles based on XPath

Let's hope the source HTML has some consistency.
Then we can identify elements we want to style with an XPath expression and
apply configured styles:

```yaml
process:
  body/value:
    - plugin: dom
      method: import
      source: 'body/0/value'
    - plugin: dom_apply_styles
      format: basic_html
      rules:
        - xpath: '//ul'
          style: Fancy list
    - plugin: dom
      method: export
```

# Example: Structure unstructured content

## The Challenge

> Every Person page starts with a job title in an `<h4>` tag and a photo. How
> can I move those into separate fields, and keep the rest in the Body field?

Example:

```html
<h4>Chief Assistant to the Assistant Chief</h4>
<img src="..." alt="...">
<p>Alfred E. Newman has been with Mad Magazine since ...</p>
```

## Structure unstructured content: why?

- Q: Why is it better to have the job title and image in separate fields?
- Q: Were you planning to hide parts of the Body field with CSS?
- Q: Are People pages coming from a Drupal 7 site, WordPress, or an XML feed?

## Job title in a separate field

When processing a Person page, use the `dom_select` plugin:

```yaml
process:
  field_job_title:
    - plugin: dom
      source: body/0/value
      method: import
    - plugin: dom_select
      selector: '//h4'
      limit: 1
    - plugin: extract
      index:
        - 0
```

## Photo in a separate field

Getting the photo is similar:

- Use `dom_select` with `selector: //img/@src`.
- Once you have the image URL, copy the file and make a File entity.
- Do all that in a separate migration.
- Use `migration_lookup` to get the File ID in the Person migration.

## Remove elements from Body field

Once the job title and photo are in separate fields, remove them from the Body field:

```yaml
process:
  'body/value':
    - plugin: dom
      method: import
      source: 'body/0/value'
    - plugin: dom_remove
      selector: '//h4'
      limit: 1
    - plugin: dom_remove
      selector: '//img'
      limit: 1
    - plugin: dom
      method: export
```

# Example: Update links in body text

## The Challenge

> In my Drupal 7 site, "About us" was `/node/6`, but in the new site it is
> `/node/136`. A lot of Body fields have
> `<a href="/node/6">About Us</a>`.
> What can I do?

This is why Marco Villegas (`@marvil07`) and I wrote the DOM process plugins.
Thanks to Isovera and Pega Systems for letting us donate the code to the
Migrate Plus module.

## Update links: lookup

The Migrate API keeps track of source and destination IDs.
Use `migration_lookup` to handle entity-reference fields:

```yaml
process:
  field_related_content:
    - plugin: migration_lookup
      source: field_related_content
      migration:
        - this_migration
        - that_migration
```

Pause and reflect.

## Update links: body field

Use `dom_migration_lookup` to handle text fields:

```yaml
process:
  body/value:
    - plugin: dom
      method: import
      source: 'body/0/value'
    - plugin: dom_migration_lookup
      mode: attribute
      xpath: '//a'
      attribute_options:
        name: href
      search: '@/node/(\d+)@'
      replace: '/node/[mapped-id]'
      migrations:
        - article
        - page
    - plugin: dom
      method: export
```

# Example: Update from Drupal 7 Media

## The Challenge

> I have a Drupal 7 site that uses the Media module.
> How do I migrate to Drupal 9?

## Create files, then media

Standard migration: migrate files to files.

Custom migration: migrate files to media.

- Source (Extract): same as the standard migration
- Process (Transform): use `migration_lookup` to find file ID from first step
- Destination (Load): create Media, not Files

This works great for structured data (File fields).

## Media tokens

Media tokens in text fields (Media and WYSIWYG modules)

```
Look at my kitten photo:
[[{"type": "media", "fid": 1909, ... }]]
```

There's a module for that:
[Media Migration](https://www.drupal.org/project/media_migration)
(alpha)

## Image tags

```
My kitten is even cuter!
<img src="/images/kitten.jpg" alt="cutest!" />
```

There's a module for that, too:
[Migrate Media Handler](https://www.drupal.org/project/migrate_media_handler)

```yaml
process:
  'body/value':
    - plugin: dom
      method: import
      source: 'body/0/value'
    - plugin: dom_inline_doc_handler
    - plugin: dom_inline_image_handler
    - plugin: dom
      method: export
```

# Conclusion

## Summary

- Introduction
- Bringing Data Into Drupal
- Migrate API Introduction
- Examples
  1. Use Editor styles
  1. Structure unstructured content
  1. Update links in body text
  1. Update from Drupal 7 Media
- Conclusion

## What's next

- Alternatives to `DOMDocument`
- Source plugin for JSON:API
- Source plugin for Drupal 7 field
- More granular processing of DOM nodes

## References

- [Benji's slide decks](https://slides.benjifisher.info)
- [Migrate API](https://www.drupal.org/docs/8/api/migrate-api) documentation
  on drupal.org
- [Migrate Plus](https://www.drupal.org/project/migrate_plus) module home page
- [Change record](https://www.drupal.org/node/3062058) describing the
  DOMDocument-based plugins
- [XPath documentation](https://developer.mozilla.org/en-US/docs/Web/XPath) on MDN
- [Process Pipelines](https://www.drupal.org/docs/drupal-apis/migrate-api/process-pipelines)
  on drupal.org
- [Media Migration](https://www.drupal.org/project/media_migration) module
- [Migrate Media Handler](https://www.drupal.org/project/migrate_media_handler) module

## Questions
