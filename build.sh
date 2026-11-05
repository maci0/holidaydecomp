#!/bin/sh
set -eu
cd "$(dirname "$0")"
if [ ! -f original/holiday.exe ]; then
    echo 'Place your own reference at original/holiday.exe before building.' >&2
    exit 2
fi
make generate
exec uv run --frozen rebrew build delphi src/main/HOLIDAY.DPR \
    --output bin/main/HOLIDAY.EXE --dcc-args='-$S-'
