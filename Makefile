all: test build

.PHONY: test
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
	zig build run -- --port=3000

exec:
	./zig-out/bin/zodbc -h

compose.up:
	docker compose up
compose.down:
	docker compose down
