# Benji's Slide Decks

## Live demo

See the generated presentations on my
[GitLab Pages](https://benjifisher.gitlab.io/slide-decks/index.html).

## Requirements

You do not need anything special in order to generate the slide decks using
GitLab CI.

If you want to convert the markdown files to HTML locally, then you need

- `git`
- `make`
- `pandoc`

## Quick Start

```
git clone --recurse-submodules git@gitlab.com:benjifisher/slide-decks.git
cd slide-decks
make
```

This will create `html/example.html` from the markdown source
`markdown/example.md`.

If you see unstyled HTML when viewing the files, the problem might be
incompatible versions of `pandoc` and `reveal.js`. The GitLab CI installs an old
version of `pandoc`, so this project pins `reveal.js` to an old version (3.9.1).
Check your local version of `pandoc`: `pandoc --version`. If it is 2.10 or
newer, then install a newer version of `reveal.js`:

```
make clean
git -C reveal.js checkout 4.3.1
make
```

See [Issue 13](https://gitlab.com/benjifisher/slide-decks/-/issues/13) in this
project.

## Make targets

You can also `make FILE.html` when `markdown/FILE.md` is any available source
file. The output will be created in the `html/` directory.

The command `make build` will create HTML files in the `html/` directory for
all sources `markdown/*.md`.

Remove all generated files with `make clean`.

## Version of Reveal.js

This repository includes Isovera'a fork of
[reveal.js](git@github.com:isovera/reveal.js.git)
as a `git` submodule.
You may prefer to start with the original.
If you do, then you will have to adjust the theme reference in the existing
presentations.

---

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-sa/4.0/88x31.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/Text" property="dct:title" rel="dct:type">Benji's Slide Decks</span> by <a xmlns:cc="http://creativecommons.org/ns#" href="https://gitlab.com/benjifisher/slide-decks" property="cc:attributionName" rel="cc:attributionURL">Benji Fisher</a> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike 4.0 International License</a>.
