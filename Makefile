# .SUFFIXES: .html .md
SRCS := $(wildcard markdown/*.md)
HTML := $(SRCS:markdown/%.md=%.html)
vpath %.md markdown
vpath %.html html

%.html: %.md
	pandoc --standalone -t revealjs -o html/$@ $< snippets/license.md

default: example.html

build: $(HTML) index.md
	pandoc --standalone -o html/index.html index.md
	cp -R images reveal.js html
	ls html/reveal.js
	tree -fi
	cp theme/*.css html/reveal.js/css/theme/.

clean:
	rm -rf html/*.html html/images html/reveal.js
