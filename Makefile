all: test build

.PHONY: test
test: test.nosummary
test/unit: test.nosummary/unit
test/integration: test.nosummary/integration
test/integration.db2: test.nosummary/integration.db2
test/integration.mariadb: test.nosummary/integration.mariadb
test/integration.postgres: test.nosummary/integration.postgres
test.nosummary:
	zig build test
test.nosummary/unit:
	zig build test:unit
test.nosummary/integration:
	zig build test:integration
test.nosummary/integration.db2:
	zig build test:integration:db2
test.nosummary/integration.mariadb:
	zig build test:integration:mariadb
test.nosummary/integration.postgres:
	zig build test:integration:postgres
test.summary:
	zig build test --summary all

build: build.fast
build.fast:
	zig build -Doptimize=ReleaseFast
build.small:
	zig build -Doptimize=ReleaseSmall
build.safe:
	zig build -Doptimize=ReleaseSafe

clean:
	rm -rf zig-*

run:
	zig run src/main.zig

compose.up:
	docker compose up
compose.down:
	docker compose down
