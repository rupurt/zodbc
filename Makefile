.PHONY: all
all: test build

.PHONY: test test/unit test/integeration test/integration.db2 test.integration.mariadb test.integration/postgres test.summary
test:
	zig build test
test/unit:
	zig build test:unit
test/integration:
	zig build test:integration
test/integration.db2:
	zig build test:integration:db2
test/integration.mariadb:
	zig build test:integration:mariadb
test/integration.postgres:
	zig build test:integration:postgres
test.summary:
	zig build test --summary all

.PHONY: build build.fast build.small build.safe build.debug
build: build.fast
build.fast:
	zig build --release=fast
build.small:
	zig build --release=small
build.safe:
	zig build --release=safe
build.debug:
	zig build -Doptimize=Debug

.PHONY: run
ifeq (run,$(firstword $(MAKECMDGOALS)))
  RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(RUN_ARGS):;@:)
endif
run:
	zig build run -- $(RUN_ARGS)

.PHONY: exec
ifeq (exec,$(firstword $(MAKECMDGOALS)))
  EXEC_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
  $(eval $(EXEC_ARGS):;@:)
endif
exec:
	./zig-out/bin/zodbc $(EXEC_ARGS)

.PHONY: clean
clean:
	rm -rf zig-*

.PHONY: compose.up compose.down
compose.up:
	docker compose up
compose.down:
	docker compose down
