#!/usr/bin/env bash
# 重現 before-after.md 的 A/B 實驗。
#
# 唯一變因：有沒有把 skills/python-standards.md 餵進 system prompt。
# --safe-mode 停用所有個人化設定（CLAUDE.md、skills、hooks、plugins），
# 確保 "before" 那側真的是乾淨的對照組。
#
# 用法：./reproduce.sh [執行次數，預設 3]

set -euo pipefail

RUNS="${1:-3}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RULES="$HERE/../skills/python-standards.md"
OUT="$HERE/raw"
PROMPT='寫一個讀 CSV、計算某個數值欄位平均值與標準差的函式。'

mkdir -p "$OUT"

# 環境指紋：讓讀者知道這批結果是在什麼條件下產生的
{
    echo "date_utc:      $(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "claude_cli:    $(claude --version)"
    echo "os:            $(uname -srm)"
    echo "runs_per_arm:  $RUNS"
    echo "prompt:        $PROMPT"
} > "$OUT/environment.txt"

run_arm() {
    local arm="$1" n="$2"
    shift 2
    echo ">>> ${arm} run ${n}" >&2
    # 在空目錄執行，避免任何專案檔案影響輸出
    local work
    work="$(mktemp -d)"
    (
        cd "$work"
        # --tools "" 讓兩組都只能回文字、不能寫檔。
        # 初版沒有這個旗標，結果 after 那組的檔案寫入被權限提示擋下，
        # 污染了「會不會主動寫測試」這一項的比較（見 before-after.md 的污染說明）。
        claude --safe-mode --no-session-persistence --tools "" \
               --output-format json "$@" -p "$PROMPT"
    ) > "$OUT/${arm}-${n}.json"
    rm -rf "$work"
}

for n in $(seq 1 "$RUNS"); do
    run_arm before "$n"
    run_arm after  "$n" --append-system-prompt "$(cat "$RULES")"
done

echo
echo "原始輸出寫入 $OUT/"
echo "每個 .json 含 session_id、model、token 用量、耗時與成本 —— 這些欄位無法事後編造。"
