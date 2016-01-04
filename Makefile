## Put this Makefile in your project directory---i.e., the directory
## containing the paper you are writing. Assuming you are using the
## rest of the toolchain here, you can use it to create .html, .tex,
## and .pdf output files (complete with bibliography, if present) from
## your markdown file. 
## -	Change the paths at the top of the file as needed.
## -	Using `make` without arguments will generate html, tex, and pdf 
## 	output files from all of the files with the designated markdown
##	extension. The default is `.md` but you can change this. 
## -	You can specify an output format with `make tex`, `make pdf` or 
## - 	`make html`. 
## -	Doing `make clean` will remove all the .tex, .html, and .pdf files 
## 	in your working directory. Make sure you do not have files in these
##	formats that you want to keep!

## Markdown extension (e.g. md, markdown, mdown).
MEXT = md

## All markdown files in the working directory
SRC = $(wildcard *.$(MEXT))

## Location of Pandoc support files.
PREFIX = /Users/$(USER)/.pandoc

## Location of Pandoc support files.
CUSTOMPREFIX = $(PWD)

## Location of your working bibliography file
BIB = $(PWD)/research.bib

## CSL stylesheet (located in the csl folder of the PREFIX directory).
CSL = $(PWD)/ieee.csl


PDFS=$(SRC:.md=.pdf)
DOCX=$(SRC:.md=.docx)
HTML=$(SRC:.md=.html)
TEX=$(SRC:.md=.tex)


all:	clean $(PDFS) $(HTML) $(DOCX)

pdf:	$(PDFS)
html:	$(HTML)
tex:	$(TEX)
docx:   $(DOCX)

diff:
	make tex; mv main.tex new; latexdiff old new > diff.tex; pdflatex diff.tex

%.html:	%.md
	pandoc --mathjax -r markdown+simple_tables+table_captions+yaml_metadata_block -w html -S --template=$(CUSTOMPREFIX)/templates/html.template --css=$(CUSTOMPREFIX)/templates/kultiad-serif.css --filter pandoc-citeproc --filter ./scripts/remove_ieeekeywords.py --csl=$(CSL) --bibliography=$(BIB) -o $@ $<

%.tex:	%.md
	pandoc -r markdown+simple_tables+table_captions+yaml_metadata_block -w latex -s -S --latex-engine=pdflatex --template=$(CUSTOMPREFIX)/templates/latex.template --filter pandoc-fignos --filter pandoc-eqnos --filter pandoc-tablenos --filter pandoc-citeproc --csl=$(CSL) --bibliography=$(BIB) -o $@ $<

%.docx:	%.md
	pandoc --mathjax -r markdown+simple_tables+table_captions+yaml_metadata_block -s -S --latex-engine=pdflatex --filter pandoc-citeproc --csl=$(CSL) --bibliography=$(BIB) -o $@ $<

%.pdf:	%.md
	pandoc -r markdown+simple_tables+table_captions+yaml_metadata_block -s -S --latex-engine=pdflatex --template=$(CUSTOMPREFIX)/templates/latex.template --filter pandoc-fignos --filter pandoc-eqnos --filter pandoc-tablenos --filter pandoc-citeproc --csl=$(CSL) --bibliography=$(BIB) -o ieee-$@ $<
	pandoc -r markdown+simple_tables+table_captions+yaml_metadata_block -s -S --latex-engine=pdflatex --filter ./scripts/remove_ieeekeywords.py --filter pandoc-fignos --filter pandoc-eqnos --filter pandoc-tablenos --filter pandoc-citeproc --csl=$(CSL) --bibliography=$(BIB) -o $@ $<


clean:
	rm -f *.html *.pdf *.tex *.aux *.log *.dvi *.docx

