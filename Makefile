SERVICE_NAME := todo-api
TEST_PACKAGES := $(shell go list ./... | grep -v vendor)

.PHONY:
dev/loc: dev/clean
	@echo "Starting development version of ${SERVICE_NAME}"
	-docker-compose -f docker-compose.loc.yml up --build

.PHONY:
dev/clean:
	@echo "Cleaning development version of ${SERVICE_NAME}"
	-docker-compose -f docker-compose.loc.yml down --remove-orphans --v

.PHONY:
dev/run:
	gin -i -a 80 run

.PHONY:
build/linux:
	CGO_ENABLED=0 GOOS=linux go build -o app

.PHONY:
test/all:
	go test -v -race ${TEST_PACKAGES}

.PHONY:
test/codecov:
	@for d in ${TEST_PACKAGES}; do \
		go test -v -race -coverprofile=profile.out -covermode=atomic $$d || exit 1 ;\
		if [ -f profile.out ]; then \
			cat profile.out >> coverage.txt; \
			rm profile.out; \
		fi; \
	done
	@bash -c "bash <(curl -s https://codecov.io/bash) -t ${CODECOV_TOKEN}"
