# var
MODULE = $(notdir $(CURDIR))
REL    = $(shell git rev-parse --short=4    HEAD)
BRANCH = $(shell git rev-parse --abbrev-ref HEAD)
NOW    = $(shell date +%d%m%y)

# dir
CWD = $(CURDIR)
BIN = $(CWD)/bin
DOC = $(CWD)/doc
LIB = $(CWD)/lib
INC = $(CWD)/inc
SRC = $(CWD)/src
TMP = $(CWD)/tmp
GZ  = $(HOME)/gz
REF = $(CWD)/ref
CAR = $(HOME)/.cargo/bin

# src
C += $(wildcard $(SRC)/*.c*)
H += $(wildcard $(INC)/*.h*)

# tool
CURL   = curl -L -o
CF     = clang-format -style=file -i
RUSTUP = $(CAR)/rustup
CARGO  = $(CAR)/cargo

# cfg
CFLAGS += -I$(INC) -I$(TMP) -ggdb -O0

# all
.PHONY: all run
all: bin/$(MODULE) lib/$(MODULE).ini
run: bin/$(MODULE) lib/$(MODULE).ini
	$^

# format
.PHONY: format
format: tmp/format_cpp
tmp/format_cpp: $(C) $(H)
	$(CF) $? && touch $@

# rule
bin/$(MODULE): $(C) $(H)
	$(CXX) $(CFLAGS) -o $@ $(C) $(L)

# doc

TEX = $(wildcard doc/*.tex)
LATEX = pdflatex -output-directory=$(TMP) -halt-on-error
# -interaction=batchmode -file-line-error

.PHONY: doc
doc: tmp/$(MODULE)_$(NOW)_$(REL)_$(BRANCH).pdf
tmp/$(MODULE)_$(NOW)_$(REL)_$(BRANCH).pdf: tmp/$(MODULE).pdf
	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen \
		-dNOPAUSE -dQUIET -dBATCH -sOutputFile=$@ $<
tmp/$(MODULE).pdf: $(TEX) $(FIG) Makefile
	cd doc ; $(LATEX) $(MODULE) && $(LATEX) $(MODULE)

.PHONY: doxy
doxy: .doxygen $(C) $(H) README.md
	rm -rf docs doc/ref; doxygen $< 1>/dev/null

# install
.PHONY: install update ref gz
install: ref gz
	$(MAKE) update && $(MAKE) doc
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
ref:
gz:
