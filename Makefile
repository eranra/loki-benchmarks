export GOBIN=$(CURDIR)/bin
export PATH:=$(GOBIN):$(PATH)

include .bingo/Variables.mk

export GOROOT=$(shell go env GOROOT)
export GOFLAGS=-mod=vendor
export GO111MODULE=on

all: bench-dev

bench-dev: $(GINKGO) $(PROMETHEUS)
	@TARGET_ENV=dev ./run.sh
.PHONY: bench
