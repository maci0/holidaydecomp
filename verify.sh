#!/bin/sh
set -eu
cd "$(dirname "$0")"
./build.sh
uv run --frozen python -m unittest discover -s tools -p 'test_*.py'
# A differing executable is a report; a comparison error remains a failure.
uv run --frozen rebrew binary ne-compare bin/main/HOLIDAY.EXE --window 16 || [ "$?" -eq 1 ]
