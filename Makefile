
# Commands to call:
TEX = pdflatex
BIB = bibtex
READER = zathura
LATEXMK := $(shell command -v latexmk 2> /dev/null)

MAIN = hotedge2018
OBJS = $(shell find . -not -path '*/\.*' \
	  	-type f -name "*.tex" \
		! -name "$(MAIN).tex" \
		! -name "original_template.tex")
FIGS = $(shell find figures -type f -name "*.pdf")
OPTIONS = -pdflatex="$(TEX) -interaction=nonstopmode"


ifndef LATEXMK
all: legacy
else
all: $(MAIN).pdf
endif

$(MAIN).pdf: $(MAIN).tex $(MAIN).bib $(OBJS) $(FIGS)
	@echo Compile the document with latexmk.
	latexmk 		\
		-pdf 		\
		$(OPTIONS)  \
		-use-make $<

legacy: $(OBJS) $(FIGS) $(MAIN).bib
	@echo [WARNING] latexmk should be installed - proceed with legacy process.
	$(TEX) $(MAIN).tex
	$(BIB) $(MAIN)
	$(TEX) $(MAIN).tex
	$(TEX) $(MAIN).tex

open: $(MAIN).pdf
	$(READER) $^&

clean:
ifndef LATEXMK
	@echo [WARNING] latexmk should be installed - proceed with legacy process.
	@rm -f *.aux
	@rm -f *.idx
	@rm -f *.log
	@rm -f *.toc
	@rm -f *.bbl
	@rm -f *.fls
	@rm -f *.ldb
	@rm -f *.tdo
	@rm -f *.blg
	@rm -f *.fdb_latexmk
	@rm -f *.out
else
	@echo Clean the directory with latexmk.
	latexmk -c
endif


mr_clean: clean
ifndef LATEXMK
	@echo [WARNING] latexmk should be installed - proceed with legacy process.
	@rm -f $(MAIN).pdf
else
	@echo Clean the directory with latexmk.
	latexmk -C
endif
