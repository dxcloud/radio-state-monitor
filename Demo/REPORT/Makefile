PDFLATEX  = pdflatex
TEXFILE   = REPORT.tex
PDFFILE   = REPORT.pdf
PDFVIEWER = evince

all: view

pdf: $(TEXFILE)
	$(PDFLATEX) $<

view: $(PDFFILE)
	$(PDFVIEWER) $<

$(PDFFILE): $(TEXFILE)
	$(PDFLATEX) $<

clean:
	rm *~ *.aux *.out *.log *.toc *.pdf

