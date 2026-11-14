#!/usr/bin/env bash
# テンプレートから作成した直後に、一度だけ実行する。
# モジュール名、README、CODEOWNERS、Dev Container の名前を書き換える。
#
# 使い方: make init MODULE_NAME=github.com/you/your-repo [OWNER=you]
set -euo pipefail

TEMPLATE_MODULE="example.com/app"

module="${1:-}"
owner="${2:-}"

usage() {
  echo "使い方: make init MODULE_NAME=github.com/you/your-repo [OWNER=you]" >&2
  exit 1
}

# sed -i は macOS と Linux で書き方が違うので、.bak を作って消す。
replace() {
  local expr="$1" file="$2"
  sed -i.bak "$expr" "$file"
  rm -f "$file.bak"
}

[[ -n "$module" ]] || usage
if [[ ! "$module" =~ ^[A-Za-z0-9._~/-]+$ ]]; then
  echo "モジュール名に使えない文字があります: $module" >&2
  exit 1
fi

cd "$(dirname "$0")/.."

current="$(go list -m)"
if [[ "$current" != "$TEMPLATE_MODULE" ]]; then
  echo "初期化済みです（module: $current）" >&2
  exit 1
fi

name="${module##*/}"

# OWNER を省略したら、github.com/<owner>/<repo> から取り出す。
if [[ -z "$owner" && "$module" =~ ^github\.com/([^/]+)/ ]]; then
  owner="${BASH_REMATCH[1]}"
fi
if [[ -n "$owner" && ! "$owner" =~ ^[A-Za-z0-9-]+(/[A-Za-z0-9._-]+)?$ ]]; then
  echo "OWNER はユーザー名か org/team で指定します: $owner" >&2
  exit 1
fi

# 1. モジュール名
go mod edit -module "$module"
{ grep -rl --include='*.go' "\"$TEMPLATE_MODULE/" . || true; } | while read -r file; do
  replace "s#\"${TEMPLATE_MODULE//./\\.}/#\"$module/#g" "$file"
done

# 2. README
sed "s#{{NAME}}#$name#g" scripts/README.tmpl.md > README.md
rm scripts/README.tmpl.md

# 3. Dev Container の名前
replace "s#\"name\": \"[^\"]*\"#\"name\": \"$name\"#" .devcontainer/devcontainer.json

# 4. CODEOWNERS
if [[ -n "$owner" ]]; then
  replace "s|^# \(.*\) @OWNER\$|\1 @$owner|" .github/CODEOWNERS
  replace "/^# TEMPLATE:/d" .github/CODEOWNERS
fi

echo "初期化しました。"
echo "  module:     $module"
echo "  README:     $name 用に作り直しました"
if [[ -n "$owner" ]]; then
  echo "  CODEOWNERS: @$owner"
else
  echo "  CODEOWNERS: 未設定です。.github/CODEOWNERS を編集してください"
fi
echo
echo "次にやること: make check、docs/setup-github.md の設定"
