#!/bin/sh

echo "Content-type: application/json"
echo "Access-Control-Allow-Origin: *"

echo ""

# default to not needing setup wizard
needSetupWizard="0"
uciValue=$(uci -q get onion.console.setup)

if [ "$uciValue" == "0" ]; then
        needSetupWizard="1"
fi

echo "{
        \"initialSetup\": $needSetupWizard
}"

exit 0
