#pandoc general-preferences.md  --toc -V SOGO_VERSION=2.0.8 -V mainfont:uop -V sansfont:uop -V fontsize:11pt  -V geometry:"lmargin=2.5cm,rmargin=2cm"  --template=template.latex  -o test-template.pdf && open test-template.pdf
#
#pandoc general-preferences.md  -s -t man -o general-preferences.1


SOGO_VERSION = 2.0.8
PANDOC_OPTS = --toc -V SOGO_VERSION=$(SOGO_VERSION) -V fontsize:11pt \
	            -V geometry:"lmargin=2.5cm,rmargin=2cm" --template=template.latex 
userguide.tex: userguide.md
	pandoc userguide.md $(PANDOC_OPTS) -o userguide.tex

userguide.pdf: template.latex userguide.md first-page.tex general-preferences.md
	TEXMFHOME=`pwd`/texmf pandoc userguide.md general-preferences.md -B first-page.tex  $(PANDOC_OPTS) -o userguide.pdf

userguide.html: userguide.tex
	pandoc userguide.tex $(PANDOC_OPTS) -o userguide.html

all: userguide.tex userguide.pdf userguide.html

clean:
	rm -f userguide.{html,pdf,tex}
