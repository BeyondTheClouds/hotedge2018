
# Commands to call:
TEX = pdflatex
BIB = bibtex
READER = zathura
LATEXMK := $(shell command -v latexmk 2> /dev/null)

MAIN = hotedge2018
OBJ = $(shell find . -not -path '*/\.*' \
	  	-type f -name "*.tex" \
		! -name "$(MAIN).tex" \
		! -name "original_template.tex")
OPTIONS = -pdflatex="$(TEX) -interaction=nonstopmode"


ifndef LATEXMK
all: legacy
else
all: $(MAIN).pdf
endif

$(MAIN).pdf: $(MAIN).tex $(MAIN).bib $(OBJ) 
	@echo Compile the document with latexmk.
	latexmk 		\
		-pdf 		\
		$(OPTIONS)  \
		-use-make $<

legacy: $(OBJ) $(MAIN).bib
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
