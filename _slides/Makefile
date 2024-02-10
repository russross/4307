SLIDES=week1 week2

.SUFFIXES:
.SUFFIXES: .tex .md .pdf

all: slides

.tex.pdf:
	pdflatex -shell-escape $<
	pdflatex -shell-escape $<
	pdflatex -shell-escape $<

.md.pdf:
	pandoc -t beamer $< -o $@

slides:	$(SLIDES:%=%.pdf)

clean:
	rm -f *.log *.aux *.mpx *.nav *.toc *.snm *.pdf *.out mpxerr.tex
	rm -f *.1 *.2 *.3 *.4 *.5 *.6 *.7 *.8 *.9 *.10
	rm -f *.11 *.12 *.13 *.14 *.15 *.16 *.17 *.18 *.19 *.20
	rm -f *.21 *.22 *.23 *.24 *.25 *.26 *.27 *.28 *.29 *.30
	rm -f *.31 *.32 *.33 *.34 *.35 *.36 *.37 *.38 *.39 *.40
	rm -f $(SLIDES:%=%.mp)
