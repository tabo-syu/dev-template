MODULE  := $(shell go list -m)
VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo dev)
LDFLAGS := -X $(MODULE)/internal/cli.Version=$(VERSION)

.PHONY: help check fmt fmt-check vet lint test build run clean mutation init

help: ## コマンド一覧を表示
	@grep -E '^[a-z-]+:.*## ' $(MAKEFILE_LIST) | awk -F ':.*## ' '{printf "  %-10s %s\n", $$1, $$2}'

check: fmt-check vet lint test ## すべての検証を実行（CI と同じ）

fmt: ## コードを整形
	gofmt -w .

fmt-check: ## 整形されているか確認
	@out="$$(gofmt -l .)"; if [ -n "$$out" ]; then echo "gofmt が必要: $$out"; exit 1; fi

vet: ## go vet を実行
	go vet ./...

lint: ## golangci-lint を実行
	golangci-lint run

test: ## テストを実行
	go test -race -cover ./...

build: ## bin/app をビルド
	go build -ldflags "$(LDFLAGS)" -o bin/app ./cmd/app

run: ## 実行（例: make run ARGS="-name Gopher"）
	go run ./cmd/app $(ARGS)

clean: ## 生成物を削除
	rm -rf bin

mutation: ## ミューテーションテスト（時間がかかる。重要な部分だけに使う）
	@command -v gremlins >/dev/null || (echo "gremlins が必要: https://gremlins.dev を参照" && exit 1)
	gremlins unleash

init: ## 作成直後に一度だけ実行（例: make init MODULE_NAME=github.com/you/repo）
	@./scripts/init.sh "$(MODULE_NAME)" "$(OWNER)"
