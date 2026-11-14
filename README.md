# dev-template

AI エージェントと一緒に開発するための、Go 製 CLI のテンプレート。
Claude Code を中心に、検証・権限・レビューの仕組みを最初から入れてある。

## 考え方

エージェントにコードを書かせ、人間は仕様・環境・検証を設計する。
成果を分けるのはツールよりも、まわりの仕組みである。

- **検証できること**：`make check` ひとつで、人間もエージェントも CI も同じ検証をする。
- **指示は短く**：`AGENTS.md` には落とし穴と検証方法だけを書く。
- **権限は設定で縛る**：指示文ではなく、設定ファイルとブランチ保護で強制する。
- **最後は人間が承認する**：AI レビューは補助。責任は人間が持つ。

## 使い方

1. GitHub で **Use this template** を押して、新しいリポジトリを作る。
2. モジュール名を変える。

   ```sh
   make init MODULE_NAME=github.com/you/your-repo
   ```

3. 検証が通ることを確認する。

   ```sh
   make check
   ```

4. GitHub の設定をする → [docs/setup-github.md](docs/setup-github.md)
5. `internal/greet` はサンプル。自分のコードに置き換える。

必要なもの：Go 1.24 以上、[golangci-lint](https://golangci-lint.run/) v2、make、jq。
Dev Container を使えば、すべて入った環境が立ち上がる。

## 入っているもの

| 場所 | 役割 |
|---|---|
| `AGENTS.md` / `CLAUDE.md` | エージェントへの共有指示。`CLAUDE.md` は `AGENTS.md` を読み込むだけ |
| `Makefile` | 検証コマンド。`make help` で一覧 |
| `.claude/settings.json` | 権限（許可・確認・禁止）と、編集後に gofmt をかけるフック |
| `.claude/skills/` | `verify`（検証）と `self-review`（PR 前の確認） |
| `.devcontainer/` | Go と Claude Code が入った開発コンテナ |
| `.github/workflows/ci.yml` | PR と main で `make check` を実行 |
| `.github/workflows/ai-review.yml` | PR を Claude がレビュー（API キー登録後に動く） |
| `.github/` のテンプレート | PR、Issue、CODEOWNERS、Dependabot |
| `docs/workflow.md` | 開発の流れとリスクに応じた監督 |
| `docs/specs/TEMPLATE.md` | 軽量な仕様テンプレート |

## 開発の流れ

探索 → 計画 → 実装 → 検証。くわしくは [docs/workflow.md](docs/workflow.md)。

```sh
make help      # コマンド一覧
make check     # 整形確認・vet・lint・テスト
make run ARGS="-name Gopher"
```

## 権限について

`.claude/settings.json` は次のように設定してある。

- **許可**：`make` の検証コマンド、`go test` など。
- **確認**：`git push`。
- **禁止**：force push、`git reset --hard`、`rm -rf`、`sudo`、`.env` や秘密情報の読み取り。

コマンド文字列での制限には抜け道がある。確実に防ぎたいものは、
ブランチ保護（[docs/setup-github.md](docs/setup-github.md)）とコンテナで守る。

## Dev Container の注意

このコンテナは外向きの通信を制限していない。
権限確認を省いて（`--dangerously-skip-permissions`）無人で動かす場合は、
[公式のリファレンス構成](https://code.claude.com/docs/en/devcontainer)にあるファイアウォールを追加すること。

## 参考

- [Claude Code ドキュメント](https://code.claude.com/docs)
- [AGENTS.md](https://agents.md/)
