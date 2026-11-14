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

## 3. CODEOWNERS を確認する

`make init` が `.github/CODEOWNERS` にユーザー名を設定する。
チームでレビューする場合は `@org/team` に書き換える。

## 4. Dependabot

`.github/dependabot.yml` で、Go モジュールと GitHub Actions の更新 PR が週1回作られる。
不要なら削除する。
