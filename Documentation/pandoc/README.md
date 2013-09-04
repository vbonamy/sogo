To build the docs, you'll need:

  - gpp
  - pandoc  1.11
  - texlive-latex-extra
  - texlive-latex-recommended
  - texlive-latex-base
  - texlive-fonts-recommended
  - texlive-fonts-extra
  
<!-- -->

    apt-get install gpp texlive-latex-extra texlive-latex-recommended texlive-latex-base texlive-fonts-recommended texlive-fonts-extra
    # get pandoc from http://packages.ubuntu.com/saucy/amd64/pandoc/download
    wget http://mirror.pnl.gov/ubuntu//pool/universe/p/pandoc/pandoc_1.11.1-2build2_amd64.deb
    dpkg -i pandoc_1.11.1-2build2_amd64.deb
