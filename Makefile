TARGET = gfkg

MAKEFLAGS += --warn-undefined-variables

TEXMK = latexmk
TEXFLAGS = -halt-on-error -no-shell-escape -interaction=nonstopmode
MKFLAGS = -logfilewarninglist -Werror -quiet -norc

export SOURCE_DATE_EPOCH = $(shell git show -s --format=%at)
export FORCE_SOURCE_DATE = 1

.PHONY: all
all: $(TARGET).pdf

$(TARGET).pdf: $(TARGET).tex
	@$(TEXMK) -pdf $(TEXFLAGS) $(MKFLAGS) $(TARGET)

$(TARGET).ps: $(TARGET).tex
	@$(TEXMK) -ps $(TEXFLAGS) $(MKFLAGS) $(TARGET)

.PHONY: lacheck
lacheck: $(TARGET).tex
	@echo "$@:"
	@$@ $(TARGET)

.PHONY: chktex
chktex: $(TARGET).tex
	@echo "$@:"
	@$@ --quiet $(TARGET)

.PHONY: $(LINT)
$(LINT): chktex lacheck

.PHONY: clean
clean:
	@$(TEXMK) -silent -c
	@$(RM) $(TARGET).atfi

.PHONY: cleanall
cleanall: clean
	@$(TEXMK) -silent -C
