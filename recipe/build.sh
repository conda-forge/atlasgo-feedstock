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

# NOTE: This is not an official build but we set the tag nonetheless to circumvent current issues
#       with the atlas SDK (cf. https://github.com/ariga/atlas-go-sdk/pull/66).
go build -v \
    -tags "official" \
    -ldflags "-s -w -X 'ariga.io/atlas/cmd/atlas/internal/cmdapi.version=v$PKG_VERSION'" \
    -o $PREFIX/bin/atlas
