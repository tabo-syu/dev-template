# GitHub の設定

ファイルでは設定できない項目。リポジトリを作ったら一度だけ行う。

## 1. テンプレートにする

Settings → General → **Template repository** にチェックを入れる。
（このリポジトリ自体をテンプレートとして公開する場合のみ）

## 2. main ブランチを保護する

Settings → Rules → Rulesets → New branch ruleset で、`main` に次を設定する。

- Require a pull request before merging
  - Required approvals: 1
  - Require review from Code Owners
- Require status checks to pass
  - `check`（CI の job 名）を追加
- Block force pushes
- Restrict deletions

エージェントの権限設定（`.claude/settings.json`）は手元での歯止めにすぎない。
force push や直接 push を確実に防ぐのは、このブランチ保護である。

## 3. AI レビューを有効にする

`.github/workflows/ai-review.yml` は、API キーを登録するまで何もしない。

### かんたんな方法

リポジトリで Claude Code を開き、`/install-github-app` を実行する。
GitHub App のインストールと Secret の登録を案内してくれる。

### 手動で設定する

1. [Claude GitHub App](https://github.com/apps/claude) をリポジトリにインストールする。
2. Settings → Secrets and variables → Actions で `ANTHROPIC_API_KEY` を登録する。

Claude のサブスクリプションで認証する場合は、`claude setup-token` で作ったトークンを
`CLAUDE_CODE_OAUTH_TOKEN` として登録し、workflow の `anthropic_api_key` の行を
`claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}` に変える。
`HAS_KEY` の行も同じ Secret 名に合わせる。

### 注意

- fork からの PR では Secret が渡らないため、レビューは実行されない。
- 実行のたびに API の利用料がかかる。

## 4. CODEOWNERS を書き換える

`.github/CODEOWNERS` のユーザー名を、自分やチームのものに変える。

## 5. Dependabot

`.github/dependabot.yml` で、Go モジュールと GitHub Actions の更新 PR が週1回作られる。
不要なら削除する。
