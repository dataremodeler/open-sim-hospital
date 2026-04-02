#!/bin/bash
# =============================================================================
# run_demo.sh — Run demo queries against dr_open_sim_demo_usa
# Usage: ./run_demo.sh [query_number]
# Example: ./run_demo.sh 1          (runs 01_data_overview.sql)
#          ./run_demo.sh            (runs all queries in order)
# =============================================================================

set -euo pipefail

DB_HOST="db-open-demo-do-user-25666328-0.l.db.ondigitalocean.com"
DB_PORT="25060"
DB_USER="dr_open_sim_demo"
DB_PASS="OpenDemoData2026!"
DB_NAME="dr_open_sim_demo_usa"
DEMO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

export PGPASSWORD="$DB_PASS"

PSQL="psql -h $DB_HOST -p $DB_PORT -U $DB_USER -d $DB_NAME --pset=pager=off"

run_query() {
    local file="$1"
    local label
    label="$(basename "$file")"
    echo ""
    echo "============================================================"
    echo "  $label"
    echo "============================================================"
    $PSQL -f "$file"
    echo ""
}

if [[ $# -eq 1 ]]; then
    # Run a single query by number
    num=$(printf "%02d" "$1")
    file=$(ls "$DEMO_DIR"/${num}_*.sql 2>/dev/null | head -1)
    if [[ -z "$file" ]]; then
        echo "Error: no query file found matching number $1" >&2
        exit 1
    fi
    run_query "$file"
else
    # Run all queries in order
    for file in "$DEMO_DIR"/[0-9][0-9]_*.sql; do
        run_query "$file"
    done
fi

unset PGPASSWORD
