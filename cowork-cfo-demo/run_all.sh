#!/usr/bin/env bash
# CFO CoWork Demo — one-shot cold-start runner.
# Runs every setup script in order against a Snowflake account using the `snow`
# CLI. Each file executes in its own session, which is exactly what the forecast
# step (03) needs: its CALL ... FORECAST and the RESULT_SCAN capture stay bound
# together in the same session inside that single file.
#
# Prerequisites:
#   - Snowflake CLI installed:  https://docs.snowflake.com/en/developer-guide/snowflake-cli/index
#   - A connection configured (`snow connection add`) whose role can reach
#     ACCOUNTADMIN — 00_prereqs.sql sets account-level params and bootstraps
#     Snowflake Intelligence.
#
# Usage:
#   ./run_all.sh                 # uses your default snow connection
#   ./run_all.sh my_connection   # uses the named connection
#
# Teardown:
#   snow sql -f 99_teardown.sql [-c my_connection]

set -euo pipefail

CONN="${1:-}"
CONN_ARGS=()
if [[ -n "$CONN" ]]; then
  CONN_ARGS=(-c "$CONN")
fi

cd "$(dirname "$0")"

# Auto-discover the numbered setup files in sort order (excluding teardown), so
# new steps the demo grows into — more seed data, extra forecast models — are
# picked up automatically as long as they use an NN_*.sql prefix.
FILES=()
for f in [0-9]*_*.sql; do
  [ -e "$f" ] || continue
  [ "$f" = "99_teardown.sql" ] && continue
  FILES+=("$f")
done

if [ "${#FILES[@]}" -eq 0 ]; then
  echo "ERROR: no numbered *.sql files found to run" >&2
  exit 1
fi

for f in "${FILES[@]}"; do
  echo ">>> Running $f"
  snow sql "${CONN_ARGS[@]}" -f "$f"
  echo "<<< Done $f"
done

echo
echo "All scripts completed."
echo "Open Snowsight » AI & ML » Snowflake Intelligence (CoWork) » Aldwych CFO Agent."
