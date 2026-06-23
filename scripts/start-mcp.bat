@echo off
REM start-mcp.bat — Launches the MediaWiki MCP server pointed at the NITC Wiki (Windows).
REM
REM On first run this creates a credential-less config.json so that *reading*
REM the wiki works with no setup. Add a username/password to config.json later
REM to enable editing. See README.md.

setlocal enabledelayedexpansion

set MCP_VERSION=0.10.0

REM Check Node.js availability
where npx.cmd >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Node.js is required (version 22.12 or newer).
    echo Install it from https://nodejs.org and try again.
    exit /b 1
)

REM Soft Node version check — warn but don't block.
for /f "tokens=1 delims=." %%a in ('node -p "process.versions.node" 2^>nul') do set NODE_MAJOR=%%a
if not defined NODE_MAJOR set NODE_MAJOR=0
if %NODE_MAJOR% lss 22 (
    echo Warning: Node %NODE_MAJOR% detected. This server needs Node 22.12+.
    echo If startup fails, upgrade Node from https://nodejs.org
)

REM Change to repo root (parent of scripts/)
cd /d "%~dp0.."

REM Load credentials from .env if present
if exist .env (
    for /f "usebackq tokens=*" %%a in (.env) do set "%%a"
)

REM Create config.json if missing
if not exist config.json (
    >config.json echo {^
  "defaultWiki": "wiki.fosscell.org",^
  "wikis": {^
    "wiki.fosscell.org": {^
      "sitename": "WIKI FOSSCELL NITC",^
      "server": "https://wiki.fosscell.org",^
      "articlepath": "",^
      "scriptpath": "",^
      "username": null,^
      "password": null,^
      "private": false^
    }^
  }^
}
)

set CONFIG=%CD%\config.json
npx.cmd "@professional-wiki/mediawiki-mcp-server@%MCP_VERSION%" %*
