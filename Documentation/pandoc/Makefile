#pandoc general-preferences.md  --toc -V SOGO_VERSION=2.0.8 -V mainfont:uop -V sansfont:uop -V fontsize:11pt  -V geometry:"lmargin=2.5cm,rmargin=2cm"  --template=template.latex  -o test-template.pdf && open test-template.pdf
#
#pandoc general-preferences.md  -s -t man -o general-preferences.1
SHELL=/bin/bash


SOGO_VERSION = 2.0.8
YEAR=2013
DATE=$(shell date +%Y-%m-%d)
TITLE="SOGo Installation and Configuration Guide"

# We do this so that we don't have to manually  setup the tex env
# before actually building the docs.
TEXVARS = TEXMFHOME=$(PWD)/texmf TEXMFVAR=$(PWD)/texmf/texmf-var TEXMFCONFIG=$(PWD)/texmf/texmf-config


GPP_OPTS = -T -D_YEAR=$(YEAR) -D_DATE=$(DATE) -D_SOGO_VERSION=$(SOGO_VERSION) \
	         -D_TITLE=$(TITLE)

PANDOC_OPTS = --listings --toc -V fontsize:11pt \
	            -V geometry:"lmargin=3cm,rmargin=2cm,tmargin=2cm,bmargin=2cm" \
							--template=template.latex 

userguide.tex: template.latex userguide.md first-page.tex general-preferences.md
	export $(TEXVARS); updmap
	gpp $(GPP_OPTS) first-page.tex >first-page.tex.done
	export $(TEXVARS); gpp $(GPP_OPTS) userguide.md  |  pandoc $(PANDOC_OPTS) -B first-page.tex.done -o userguide.tex
	rm first-page.tex.done

userguide.pdf: template.latex userguide.md first-page.tex general-preferences.md
	rm -rf texmf/texmf-var/*
	[ -f /var/lib/texmf/web2c/updmap.cfg ] && \
	  (install -D /var/lib/texmf/web2c/updmap.cfg  texmf/web2c/updmap.cfg && \
		echo 'Map bera.map' >>texmf/web2c/updmap.cfg) || echo 'Map bera.map' >texmf/web2c/updmap.cfg
	export $(TEXVARS); updmap 
	gpp $(GPP_OPTS) first-page.tex >first-page.tex.done
	# this "export FOO; commands" is very important.
	# Otherwise pdflatex won't find the local sty and hell breaks loose
	export $(TEXVARS); gpp $(GPP_OPTS) userguide.md  | \
	  pandoc $(PANDOC_OPTS) -B first-page.tex.done -o userguide.pdf
	rm first-page.tex.done

test: template.latex userguide.md first-page.tex general-preferences.md
	TEXMFHOME=`pwd`/texmf pandoc $(PANDOC_OPTS) userguide.md -B first-page.tex.done -o userguide.pdf

userguide.html: userguide.tex
	pandoc userguide.tex $(PANDOC_OPTS) -o userguide.html

all: userguide.tex userguide.pdf userguide.html

clean:
	rm -f userguide.{html,pdf,tex}
	rm -f first-page.tex.done
