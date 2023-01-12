---
author: Benji Fisher
title: 'DevOps for Presentations: Markdown, Pandoc, Reveal.js, GitLab CI'
date: October 17, 2020
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

## About Fruition

![Fruition](./images/white-fruition-logo.svg){height=2em style="border: 0px; height: 2em; background-color: #008dd6; padding: 1ex"}&nbsp;

Build. Grow. Protect.&trade;&nbsp; It’s what we know.

[https://fruition.net/](https://fruition.net/)

# Markdown

## Markdown: lists

```md
1. First
1. Second
    1. nested
    1. nested
```

1. First
1. Second
    1. nested
    1. nested

## Markdown: links

```md
[Drupal](https://www.drupal.org)
```

[Drupal](https://www.drupal.org)

## Markdown: images

```md
![Caption](./images/yp.jpeg)
```

![Caption](./images/yp.jpeg)

## Markdown: subheadings

```md
### H3 heading

#### H4 heading

##### H5 heading

###### H6 heading
```

### H3 heading

#### H4 heading

##### H5 heading

###### H6 heading

# Pandoc

## Pandoc: Document converter

- Goal: convert anything to anything
- Method: anything -> markdown -> anything
- [https://pandoc.org/](https://pandoc.org/)

## Pandoc: input formats

<div style="color: #42affa">
```sh
$ pandoc --list-input-formats
commonmark
creole
docbook
docx
dokuwiki
epub
fb2
gfm
haddock
html
ipynb
jats
json
latex
man
markdown
markdown_github
markdown_mmd
markdown_phpextra
markdown_strict
mediawiki
muse
native
odt
opml
org
rst
t2t
textile
tikiwiki
twiki
vimwiki
```
</div>

## Pandoc: output formats

<div style="color: #42affa">
```sh
$ pandoc --list-output-formats
asciidoc
asciidoctor
beamer
commonmark
context
docbook
docbook4
docbook5
docx
dokuwiki
dzslides
epub
epub2
epub3
fb2
gfm
haddock
html
html4
html5
icml
ipynb
jats
json
latex
man
markdown
markdown_github
markdown_mmd
markdown_phpextra
markdown_strict
mediawiki
ms
muse
native
odt
opendocument
opml
org
plain
pptx
revealjs
rst
rtf
s5
slideous
slidy
tei
texinfo
textile
zimwiki
```
</div>

## Pandoc: usage

<div style="color: #42affa">
```sh
$ pandoc \
 --standalone \
 -t revealjs \
 -o html/devops-slides.html \
 markdown/devops-slides.md
```
</div>

# Reveal.js

## Reveal.js: beautiful presentations

- Home page: [https://revealjs.com/#/](https://revealjs.com/#/)
- GitHub repo: [https://github.com/hakimel/reveal.js](https://github.com/hakimel/reveal.js)

# GitLab CI

## GitLab CI: free and flexible

- fully integrated with GitLab
- free for public repositories
- use any Docker image
- jobs and pipelines
- branches, tags, commits

## GitLab CI: pages

- Create a job called `pages`.
- Add files to `public/`.
- Save it as an artifact.

## GitLab CI: example `.gitlab-ci.yml`

```yaml
variables:
  GIT_SUBMODULE_STRATEGY: recursive
before_script:
  - apt-get update -qq && apt-get install -qq -y pandoc
  - pandoc --version
pages:
  stage: deploy
  script:
    - make build
    - cp -R html public
  artifacts:
    paths:
      - public
```

# Live Demo

## Live Demo: typos

### Do not trust your spell checker

- edit
- `make`
- commit
- push
