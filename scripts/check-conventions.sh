#!/usr/bin/env bash
# Enforces the repository conventions that can be checked mechanically.
#   files                 scan tracked files
#   message <file>        validate one commit message file
#   range <git-range>     validate every commit message of a range
#   title                 validate a PR title read from stdin
#   text <label>          scan free text read from stdin
set -euo pipefail

SELF_REFERENCE='claude|anthropic|chatgpt|openai|copilot|codex|gemini|\bllm\b|\bgpt-?[0-9]|ai[- ](generated|assisted|written)|(generated|written|created) (by|with) (an? )?(ai|assistant|agent|bot)|as an ai\b|🤖'
DEBT_MARKER='\b(TODO|FIXME|HACK|XXX)\b'
SUPPRESSION='@SuppressWarnings|eslint-disable|@ts-ignore|@ts-expect-error|// ignore:|# noqa|# type: ignore|NOSONAR|@Disabled'
CONVENTIONAL='^(feat|fix|docs|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9-]+\))?!?: .{1,72}$'
# Files allowed to name tools or to describe the patterns above.
EXEMPT='^(AGENTS\.md|CLAUDE\.md|scripts/check-conventions\.sh|\.claude/.*)$'
CODE_FILES='\.(java|kt|ts|tsx|js|jsx|dart|py|sql|sh|yml|yaml)$'

fail=0
report() { echo "conventions: $1" >&2; fail=1; }

scan_text() { # label, text
  if grep -Eiq "$SELF_REFERENCE" <<<"$2"; then
    report "$1 mentions an authoring tool or agent"
  fi
}

check_message() { # label, message
  local subject
  subject=$(head -n1 <<<"$2")
  case "$subject" in Merge\ *|Revert\ \"*|fixup!*|squash!*) ;; *)
    grep -Eq "$CONVENTIONAL" <<<"$subject" || report "$1: subject is not a Conventional Commit (max 72 chars): $subject" ;;
  esac
  scan_text "$1" "$2"
}

check_files() {
  local f
  while IFS= read -r f; do
    [[ -f "$f" ]] || continue
    [[ "$f" =~ $EXEMPT ]] && continue
    if grep -Eiq "$SELF_REFERENCE" "$f" 2>/dev/null; then report "$f mentions an authoring tool or agent"; fi
    if grep -Eq "$DEBT_MARKER" "$f" 2>/dev/null; then report "$f contains a debt marker (TODO/FIXME/HACK/XXX)"; fi
    if [[ "$f" =~ $CODE_FILES ]] && grep -E "$SUPPRESSION" "$f" 2>/dev/null | grep -Evq 'ADR-[0-9]+'; then
      report "$f suppresses a warning without an ADR-NNN reference"
    fi
  done < <(git ls-files --cached --others --exclude-standard)
}

case "${1:-}" in
  files) check_files ;;
  message) check_message "commit message" "$(grep -v '^#' "${2:?message file required}")" ;;
  range)
    while IFS= read -r sha; do
      check_message "commit ${sha:0:8}" "$(git log -1 --format=%B "$sha")"
    done < <(git rev-list "${2:?git range required}") ;;
  title)
    t=$(cat)
    grep -Eq "$CONVENTIONAL" <<<"$t" || report "PR title is not a Conventional Commit (max 72 chars): $t"
    scan_text "PR title" "$t" ;;
  text) scan_text "${2:-text}" "$(cat)" ;;
  *) echo "usage: $0 files | message <file> | range <range> | title | text <label>" >&2; exit 2 ;;
esac

exit "$fail"
