#!/bin/sh

## draw a welcome message to the Omega2 Dash display
## when running it, pipe the output to /dev/tty1

RED="\033[91m"
GREEN="\033[92m"
BLUE="\033[94m"
YELLOW="\033[93m"
RESET="\033[0m"

clear


echo -e ""
echo -e ""
echo -e ""
echo -e ""
echo -e ""
echo -e ""
echo -e ""
echo -e "${RED}   ____                            ___ ${RESET}"
echo -e "${RED}  / __ \\____ ___  ___  ____ _____ |__ \\ ${RESET}"
echo -e "${RED} / / / / __ \`__ \\/ _ \\/ __ \`/ __ \`/_/ / ${RESET}"
echo -e "${RED}/ /_/ / / / / / /  __/ /_/ / /_/ / __/ ${RESET}"
echo -e "${RED}\\____/_/ /_/ /_/\\___/\\__, /\\__,_/____/ ${RESET}"
echo -e "${RED}             ${GREEN}____${RED}   /____/    ${GREEN}__ ${RESET}"
echo -e "${GREEN}            / __ \\____ ______/ /_ ${RESET}"
echo -e "${GREEN}           / / / / __ \`/ ___/ __ \\ ${RESET}"
echo -e "${GREEN}          / /_/ / /_/ (__  ) / / / ${RESET}"
echo -e "${GREEN}         /_____/\\__,_/____/_/ /_/ ${RESET}"

echo -e ""
echo -e ""
echo -e ""
echo -e ""

echo -e "Head over to"
echo -e "${BLUE}https://onion.io/omega2-dash-guide${RESET}"
echo -e "to learn how to make the most of"
echo -e "your new device!"
echo -e ""
echo -e "${YELLOW}(And how to get rid of this message)${RESET}"
echo -e ""

exit
echo -e ""
echo -e "Also make sure to check out "
echo -e "our documentation at"
echo -e "${BLUE}http://docs.onion.io${RESET}"
echo -e ""
echo -e "And our community forum at"
echo -e "${BLUE}http://community.onion.io${RESET}"
