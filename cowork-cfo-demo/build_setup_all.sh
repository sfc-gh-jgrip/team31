#!/usr/bin/env bash
# CFO CoWork Demo — regenerate the concatenated worksheet script.
#
# Globs every numbered setup file (NN_*.sql, excluding 99_teardown.sql) in sort
# order and stitches them into setup_all.sql with section banners. This keeps the
# one-file worksheet path in lockstep with the modular files: whenever the demo
# is fleshed out — more seed data, extra forecast models, new tools — drop the
# new file in with a numeric prefix that sorts into the right slot and re-run
# this script. Nothing here is hand-maintained.
#
# Usage:  ./build_setup_all.sh
set -euo pipefail
cd "$(dirname "$0")"

OUT="setup_all.sql"
TMP="$(mktemp)"

{
  echo "-- ============================================================================"
  echo "-- Aldwych CFO — Snowflake CoWork demo — CONCATENATED COLD-START SETUP"
  echo "-- GENERATED FILE — do not edit by hand. Regenerate with ./build_setup_all.sh"
  echo "-- after changing any numbered *.sql file."
  echo "--"
  echo "-- HOW TO RUN (for someone standing up the demo in their own account):"
  echo "--   Snowsight » Projects » Workspaces » add a SQL file, paste this in,"
  echo "--   then Run All — signed in as (or able to use) ACCOUNTADMIN."
  echo "--   Or from the CLI:  snow sql -f setup_all.sql"
  echo "--"
  echo "-- Everything runs in ONE session, so the forecast step's CALL + RESULT_SCAN"
  echo "-- stay bound together. Teardown is kept separate: run 99_teardown.sql."
  echo "--"
  echo "-- If the account ALREADY has CoWork enabled, the SNOWFLAKE_INTELLIGENCE"
  echo "-- bootstrap in the prereqs section may error on CREATE SCHEMA (the schema"
  echo "-- already exists). That is expected — see the note in that section."
  echo "-- Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo "-- ============================================================================"
  echo

  found=0
  for f in [0-9]*_*.sql; do
    [ -e "$f" ] || continue
    [ "$f" = "99_teardown.sql" ] && continue
    found=1
    echo
    echo "-- ----------------------------------------------------------------------------"
    echo "-- >>> BEGIN $f"
    echo "-- ----------------------------------------------------------------------------"
    cat "$f"
    echo
    echo "-- <<< END $f"
  done

  if [ "$found" -eq 0 ]; then
    echo "ERROR: no numbered *.sql files found to concatenate" >&2
    exit 1
  fi
} > "$TMP"

mv "$TMP" "$OUT"
echo "Wrote $OUT ($(grep -c '' "$OUT") lines) from: $(ls [0-9]*_*.sql | grep -v '^99_teardown.sql$' | tr '\n' ' ')"
