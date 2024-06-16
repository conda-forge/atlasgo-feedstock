#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

cd cmd/atlas

# NOTE: github.com/libsql/sqlite-antlr4-parser is generated and does not include a license.
#       Licenses for ANTLR4 projects are already included for other dependencies.
# Last ignore line is a workaround for https://github.com/google/go-licenses/issues/244
go-licenses save . \
    --save_path ../../library_licenses \
    --ignore ariga.io/atlas \
    --ignore github.com/libsql/sqlite-antlr4-parser \
    --ignore $(go list std | awk 'NR > 1 { printf(",") } { printf("%s",$0) } END { print "" }')

go build -v \
    -ldflags "-s -w -X 'ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v$PKG_VERSION'" \
    -o $PREFIX/bin/atlas
