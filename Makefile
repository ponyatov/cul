# doc
.PHONY: doc
doc:

# install
.PHONY: install update ref gz
install: ref gz
	$(MAKE) update && $(MAKE) doc
update:
	sudo apt update
	sudo apt install -uy `cat apt.txt`
ref:
gz:
