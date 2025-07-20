#!/bin/bash

# ========= MATRIX-THEMED COLORS ==========
GREEN=$(tput setaf 2)
WHITE=$(tput setaf 15)
RESET=$(tput sgr0)

# ========= DYNAMIC SOURCES ==========
fetch_news() {
    {
        for site in "${sites[@]}"; do
            w3m -dump "$site" 2>/dev/null
        done
    }
}

# ========= BUILD SEARCH PATTERN ==========
build_grep_pattern() {
    local pattern=""
    for term in "${terms[@]}"; do
        [[ "$term" != "NULL" && -n "$term" ]] && pattern+="$term|"
    done
    echo "${pattern%|}"  # remove trailing |
}

# ========= USER CONFIGURATION ==========
configure_search() {
    clear
    echo "${GREEN}===== NEWS SCANNER v2.0 ====="
    echo "⚡ Parallel scraping${RESET}"
    echo

    # Default sites
    DEFAULT_SITES=(
        "cnn.com/us"
        "news.google.com"
        "bbc.com/news"
        "reuters.com"
        "reddit.com/r/worldnews"
    )

    echo "${WHITE}Default sites:${RESET}"
    for ((i=0; i<${#DEFAULT_SITES[@]}; i++)); do
        echo "$((i+1))) ${DEFAULT_SITES[i]}"
    done
    echo

    # Configure sites
    read -p "${WHITE}How many custom sites? (0 to use defaults): ${RESET}" num_sites
    sites=()

    if (( num_sites > 0 )); then
        for ((i=1; i<=num_sites; i++)); do
            read -p "${GREEN}Enter site URL $i (e.g., cnn.com): ${RESET}" site
            sites+=("$site")
        done
    else
        sites=("${DEFAULT_SITES[@]}")
    fi

    # Configure search terms
    read -p "${WHITE}How many search terms do you want? ${RESET}" num_terms
    terms=()
    for ((i=1; i<=num_terms; i++)); do
        read -p "${GREEN}Enter search term $i (type 'NULL' to skip): ${RESET}" term
        terms+=("$term")
    done

    # Scroll speed for ALL modes
    read -p "${GREEN}Scroll speed (seconds per line, e.g., 0.1): ${RESET}" scroll_speed

    # Additional persistent mode options
    if [[ "$1" == "persistent" ]]; then
        read -p "${GREEN}Time delay between refreshes (seconds): ${RESET}" seconds1
    fi
}

# ========= SIMPLE SEARCH ==========
simple_search() {
    configure_search
    pattern=$(build_grep_pattern)

    echo
    echo "${WHITE}SEARCH RESULTS:${RESET}"
    echo "${GREEN}SOURCES: ${sites[*]}${RESET}"
    echo

    if [[ -z "$pattern" ]]; then
        fetch_news | while IFS= read -r line; do
            echo "$line"
            sleep "$scroll_speed"
        done
    else
        fetch_news | GREP_COLORS='mt=1;32' grep -i -E --color=always "$pattern" | while IFS= read -r line; do
            echo "$line"
            sleep "$scroll_speed"
        done
    fi
}

# ========= PERSISTENT SCAN ==========
persistent_search() {
    configure_search "persistent"
    pattern=$(build_grep_pattern)

    while true; do
        echo
        echo "${WHITE}[$(date '+%F %T')] SEARCH RESULTS FROM: ${sites[*]}${RESET}"
        echo

        if [[ -z "$pattern" ]]; then
            fetch_news | while IFS= read -r line; do
                echo "$line"
                sleep "$scroll_speed"
            done
        else
            fetch_news | GREP_COLORS='mt=1;32' grep -i -E --color=always "$pattern" | while IFS= read -r line; do
                echo "$line"
                sleep "$scroll_speed"
            done
        fi

        echo
        echo "${GREEN}REFRESHING IN $seconds1 SECONDS...${RESET}"
        seq 1 "$seconds1" | pv -s "$seconds1" -l -F "Time remaining: %e" | while read -r i; do sleep 1; done
        echo "${WHITE}==============================================================================${RESET}"
    done
}

# ========= MAIN MENU ==========
main_menu() {
    clear
    echo "${GREEN}///// ${WHITE}CUSTOM NEWS HEADLINE SEARCH ${GREEN}/////${RESET}"
    echo
    echo "${WHITE}1) Simple one-time search (with scroll control)"
    echo "2) Persistent auto-refreshing search"
    echo "3) Exit${RESET}"
    echo
    read -r -p "${GREEN}SELECT OPTION (1-3): ${RESET}" selection1

    case "$selection1" in
        1) simple_search ;;
        2) persistent_search ;;
        3) exit 0 ;;
        *) echo "${WHITE}Invalid selection${RESET}"; sleep 1; main_menu ;;
    esac

    echo
    read -p "${GREEN}Return to menu? (y/n): ${RESET}" answer
    [[ "$answer" =~ ^[yY] ]] && main_menu || exit 0
}

# ========= RUN ==========
main_menu
