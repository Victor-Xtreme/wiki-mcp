#!/bin/bash
# validate-config.sh — Checks config.json against the live wiki API
#
# Usage: bash scripts/validate-config.sh [path/to/config.json]
#
# Defaults to ./config.json if no path is given.

set -euo pipefail

CONFIG_PATH="${1:-config.json}"
ERRORS=0

# ANSI colour codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

pass()  { echo -e "  ${GREEN}[PASS]${NC} $1"; }
warn()  { echo -e "  ${YELLOW}[WARN]${NC} $1"; }
fail()  { echo -e "  ${RED}[FAIL]${NC} $1"; ERRORS=$((ERRORS + 1)); }

echo "==> Validating config: $CONFIG_PATH"
echo ""

# ------------------------------------------------------------------
# 1. File exists and is valid JSON
# ------------------------------------------------------------------
echo "--- Step 1: File check ---"

if [ ! -f "$CONFIG_PATH" ]; then
  fail "File not found: $CONFIG_PATH"
  echo ""
  echo "Config check failed with $ERRORS error(s)."
  exit 1
fi
pass "File exists: $CONFIG_PATH"

if ! jq empty "$CONFIG_PATH" 2>/dev/null; then
  fail "Invalid JSON in $CONFIG_PATH"
  echo ""
  echo "Config check failed with $ERRORS error(s)."
  exit 1
fi
pass "Valid JSON"

# ------------------------------------------------------------------
# 2. Required top-level fields
# ------------------------------------------------------------------
echo ""
echo "--- Step 2: Top-level fields ---"

DEFAULT_WIKI=$(jq -r '.defaultWiki // empty' "$CONFIG_PATH")
if [ -z "$DEFAULT_WIKI" ]; then
  fail "Missing 'defaultWiki' field"
else
  pass "defaultWiki: $DEFAULT_WIKI"
fi

WIKI_COUNT=$(jq '.wikis | length' "$CONFIG_PATH")
if [ "$WIKI_COUNT" -eq 0 ]; then
  fail "No wikis configured under 'wikis' key"
else
  pass "Found $WIKI_COUNT wiki(s) configured"
fi

# ------------------------------------------------------------------
# 3. Per-wiki validation
# ------------------------------------------------------------------
echo ""
echo "--- Step 3: Per-wiki fields ---"

jq -r '.wikis | to_entries[] | .key' "$CONFIG_PATH" | while read -r wiki_key; do
  echo "  Wiki: $wiki_key"

  sitename=$(jq -r ".wikis[\"$wiki_key\"].sitename // empty" "$CONFIG_PATH")
  server=$(jq -r ".wikis[\"$wiki_key\"].server // empty" "$CONFIG_PATH")
  articlepath=$(jq -r ".wikis[\"$wiki_key\"].articlepath // empty" "$CONFIG_PATH")
  scriptpath=$(jq -r ".wikis[\"$wiki_key\"].scriptpath // empty" "$CONFIG_PATH")
  is_private=$(jq -r ".wikis[\"$wiki_key\"].private // false" "$CONFIG_PATH")

  # Check required fields
  if [ -z "$sitename" ]; then
    echo -e "    ${RED}[FAIL]${NC} Missing sitename"
  else
    echo -e "    ${GREEN}[PASS]${NC} sitename: $sitename"
  fi

  if [ -z "$server" ]; then
    echo -e "    ${RED}[FAIL]${NC} Missing server"
  else
    echo -e "    ${GREEN}[PASS]${NC} server: $server"
  fi

  if [ -z "$articlepath" ]; then
    echo -e "    ${RED}[FAIL]${NC} Missing articlepath"
  else
    echo -e "    ${GREEN}[PASS]${NC} articlepath: $articlepath"
  fi

  if [ -z "$scriptpath" ]; then
    echo -e "    ${RED}[FAIL]${NC} Missing scriptpath"
  else
    echo -e "    ${GREEN}[PASS]${NC} scriptpath: $scriptpath"
  fi

  # Warn if no auth configured for a private wiki
  token=$(jq -r ".wikis[\"$wiki_key\"].token // empty" "$CONFIG_PATH")
  username=$(jq -r ".wikis[\"$wiki_key\"].username // empty" "$CONFIG_PATH")
  password=$(jq -r ".wikis[\"$wiki_key\"].password // empty" "$CONFIG_PATH")

  if [ "$is_private" = "true" ]; then
    if [ -z "$token" ] && { [ -z "$username" ] || [ -z "$password" ]; }; then
      echo -e "    ${YELLOW}[WARN]${NC} Private wiki but no auth configured (token or username+password)"
    else
      echo -e "    ${GREEN}[PASS]${NC} Auth configured for private wiki"
    fi
  fi

  # ------------------------------------------------------------------
  # 4. Connectivity check
  # ------------------------------------------------------------------
  echo ""
  echo "--- Step 4: Connectivity check for $wiki_key ---"

  API_URL="$server${scriptpath}/api.php"
  if curl -s -o /dev/null -w "%{http_code}" --connect-timeout 5 "$API_URL?action=query&meta=siteinfo&format=json" | grep -q "200"; then
    echo -e "    ${GREEN}[PASS]${NC} API reachable: $API_URL"

    SITENAME_FROM_API=$(curl -s "$API_URL?action=query&meta=siteinfo&format=json" | jq -r '.query.general.sitename // "unknown"')
    echo -e "    ${GREEN}[INFO]${NC} Remote sitename: $SITENAME_FROM_API"
  else
    echo -e "    ${YELLOW}[WARN]${NC} API not reachable at $API_URL (network or DNS issue)"
  fi
done

# ------------------------------------------------------------------
# Summary
# ------------------------------------------------------------------
echo ""
echo "==="
if [ "$ERRORS" -eq 0 ]; then
  echo -e "${GREEN}Config validation passed.${NC}"
else
  echo -e "${RED}Config validation finished with $ERRORS error(s).${NC}"
  exit 1
fi
