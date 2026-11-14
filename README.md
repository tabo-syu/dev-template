# dev-template

AI エージェントと一緒に開発するための、Go 製 CLI のテンプレート。
Claude Code を中心に、検証・権限・レビューの仕組みを最初から入れてある。

## 使い方

1. GitHub で **Use this template** を押して、新しいリポジトリを作る。
2. 初期化する。一度だけ実行する。

   ```sh
   make init MODULE_NAME=github.com/you/your-repo
   ```

   モジュール名、この README、CODEOWNERS、Dev Container の名前が書き換わる。

3. 検証が通ることを確認する。

   ```sh
   make check
   ```

4. GitHub の設定をする → [docs/setup-github.md](docs/setup-github.md)
5. `internal/greet` はサンプル。自分のコードに置き換える。

必要なもの：Go 1.24 以上、[golangci-lint](https://golangci-lint.run/) v2、make、jq。
Dev Container を使えば、すべて入った環境が立ち上がる。

## くわしく

- 仕組みと考え方：[docs/template.md](docs/template.md)
- 開発の流れ：[docs/workflow.md](docs/workflow.md)
