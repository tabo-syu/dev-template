# GitHub の設定

ファイルでは設定できない項目。リポジトリを作ったら一度だけ行う。
設定や Secret はテンプレートから引き継がれない。リポジトリごとに設定する。

## 1. テンプレートにする（テンプレート元だけ）

Settings → General → **Template repository** にチェックを入れる。
テンプレートから作ったリポジトリでは、この手順は不要。

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

`.github/workflows/ai-review.yml` は、トークンを登録するまで何もしない。
Claude のサブスクリプション（Pro / Max / Team / Enterprise）で動かす。API の料金はかからない。

### 手順

1. [Claude GitHub App](https://github.com/apps/claude) をリポジトリにインストールする。
2. 手元で `claude setup-token` を実行して、トークンを作る。
3. Settings → Secrets and variables → Actions で、`CLAUDE_CODE_OAUTH_TOKEN` として登録する。

### 注意

- PR のたびに、プランの利用枠を消費する。手元の Claude Code と同じ枠である。
- トークンは作った本人のサブスクリプションに紐づき、長期間有効である。漏らさない。
- fork からの PR では Secret が渡らないため、レビューは実行されない。
- 使わない場合は、`ai-review.yml` を削除する。手元の `/self-review` だけでもレビューできる。

### API キーで動かす場合

チームで共有するリポジトリでは、個人のトークンより API キーが向いている。
`ANTHROPIC_API_KEY` を登録し、workflow の `claude_code_oauth_token` の行を
`anthropic_api_key: ${{ secrets.ANTHROPIC_API_KEY }}` に変える。
`HAS_TOKEN` の行も同じ Secret 名に合わせる。実行のたびに API の料金がかかる。

## 4. CODEOWNERS を確認する

`make init` が `.github/CODEOWNERS` にユーザー名を設定する。
チームでレビューする場合は `@org/team` に書き換える。

## 5. Dependabot

`.github/dependabot.yml` で、Go モジュールと GitHub Actions の更新 PR が週1回作られる。
不要なら削除する。
