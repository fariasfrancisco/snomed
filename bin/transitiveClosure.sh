#!/usr/bin/env bash

TEMP_PATH="/tmp/relationship"
BIN_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
DATA_PATH="${BIN_PATH}/data"

cp "${DATA_PATH}/sct2_Relationship_Snapshot_INT_20180131.txt" "${TEMP_PATH}.txt"
sed '1d' "${DATA_PATH}/sct2_Relationship_SpanishExtensionSnapshot_INT_20171031.txt" >> "${TEMP_PATH}.txt"

# These steps are slower and use a js script.
#
# node --max-old-space-size=6144 "${BIN_PATH}/transitiveClosure.js" "${TEMP_PATH}.txt" "${TEMP_PATH}.json"
# jq --raw-output '("subtypeId	supertypeId"), (.[] | [.subtypeId, .supertypeId] | @tsv)' "${TEMP_PATH}.json" | sed 's/\"//g' > "${DATA_PATH}/sct2_TransitiveClosureSnapshot_INT_20171031.txt"

perl ./bin/transitiveClosureRf2Snap.pl "${TEMP_PATH}.txt" "${DATA_PATH}/sct2_TransitiveClosureSnapshot_INT_20180131.txt"

sed -i '1i subtypeId\tsupertypeId' "${DATA_PATH}/sct2_TransitiveClosureSnapshot_INT_20180131.txt"

rm "${TEMP_PATH}.txt" # "${TEMP_PATH}.json"
