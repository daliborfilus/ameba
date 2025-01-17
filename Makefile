CRYSTAL_BIN ?= crystal
SHARDS_BIN ?= shards
PREFIX ?= /usr/local
SHARD_BIN ?= ../../bin
CRFLAGS ?= -Dpreview_mt

.PHONY: build
build:
	$(SHARDS_BIN) build $(CRFLAGS)

.PHONY: lint
lint: build
	./bin/ameba --all

.PHONY: spec
spec:
	$(CRYSTAL_BIN) spec

.PHONY: clean
clean:
	rm -f ./bin/ameba ./bin/ameba.dwarf

.PHONY: install
install: build
	mkdir -p $(PREFIX)/bin
	cp ./bin/ameba $(PREFIX)/bin

.PHONY: bin
bin: build
	mkdir -p $(SHARD_BIN)
	cp ./bin/ameba $(SHARD_BIN)

.PHONY: run_file
run_file:
	cp -n ./bin/ameba.cr $(SHARD_BIN) || true

.PHONY: test
test: spec lint
