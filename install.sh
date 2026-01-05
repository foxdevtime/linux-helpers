#!/bin/bash

REPO_USER="foxdevtime"
REPO_NAME="linux-helpers"
BRANCH="main"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

INSTALL_DIR="/usr/local/bin"
API_URL="https://api.github.com/repos/$REPO_USER/$REPO_NAME/contents/tools"
RAW_URL="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/$BRANCH/tools"

MODE="REMOTE"
if [ -d "tools" ]; then
    MODE="LOCAL"
fi

check_internet() {
    if ! command -v curl &> /dev/null; then
        echo -e "${RED}Error: 'curl' is required for remote installation.${NC}"
        exit 1
    fi
}

header() {
    clear
    echo -e "${BOLD}========================================${NC}"
    echo -e "${BOLD}   🐧 Linux Helpers Installer ($MODE)   ${NC}"
    echo -e "${BOLD}========================================${NC}"
    echo ""
}

pause() {
    read -p "Press Enter to continue..." dummy
}

get_remote_tools() {
    check_internet
    response=$(curl -s "$API_URL")
    
    if [[ "$response" == *"Not Found"* ]]; then
        echo -e "${RED}Error: Repository not found or private.${NC}"
        echo "Check REPO_USER in the script."
        exit 1
    fi

    echo "$response" | grep '"name":' | grep -v 'README.md' | sed -E 's/.*"name": "([^"]+)".*/\1/'
}

get_local_tools() {
    for d in tools/*/; do
        if [ -d "$d" ]; then
            basename "$d"
        fi
    done
}

show_menu() {
    header
    echo "Available Tools:"
    echo ""
    
    TOOLS=()
    i=1
    
    if [ "$MODE" == "LOCAL" ]; then
        mapfile -t TOOLS < <(get_local_tools)
    else
        echo -e "${BLUE}Fetching list from GitHub...${NC}"
        mapfile -t TOOLS < <(get_remote_tools)
    fi
    
    if [ ${#TOOLS[@]} -eq 0 ]; then
        echo -e "${RED}No tools found!${NC}"
        exit 1
    fi

    for tool in "${TOOLS[@]}"; do
        echo -e "  ${BOLD}$i)${NC} $tool"
        ((i++))
    done

    echo ""
    echo -e "  ${BOLD}0)${NC} Exit"
    echo ""
    echo -n "Select tool (number): "
}

show_tool_page() {
    local tool_name=$1
    
    while true; do
        header
        echo -e "Tool: ${GREEN}$tool_name${NC}"
        echo "----------------------------------------"
        
        local desc="Loading..."
        
        if [ "$MODE" == "LOCAL" ]; then
            local readme_path="tools/$tool_name/README.md"
            if [ -f "$readme_path" ]; then
                desc=$(head -n 1 "$readme_path" | sed 's/# //')
            else
                desc="N/A"
            fi
        else
            local remote_readme="$RAW_URL/$tool_name/README.md"
            desc=$(curl -s "$remote_readme" | head -n 1 | sed 's/# //')
            if [[ "$desc" == *"404"* ]]; then desc="N/A"; fi
        fi
        
        echo -e "Description: $desc"
        echo ""
        echo "Actions:"
        echo "  1) Install to system ($INSTALL_DIR)"
        echo "  2) Read full README"
        echo "  0) Back"
        echo ""
        echo -n "Choice: "
        read choice
        
        case $choice in
            1)
                install_tool "$tool_name"
                pause
                break
                ;;
            2)
                read_readme "$tool_name"
                ;;
            0)
                break
                ;;
            *)
                echo "Invalid choice."
                sleep 1
                ;;
        esac
    done
}

read_readme() {
    local tool_name=$1
    clear
    if [ "$MODE" == "LOCAL" ]; then
        local f="tools/$tool_name/README.md"
        if [ -f "$f" ]; then
            command -v less &> /dev/null && less "$f" || cat "$f"
        else
            echo "README not found."
        fi
    else
        echo -e "${BLUE}Fetching README...${NC}"
        curl -s "$RAW_URL/$tool_name/README.md" | less
    fi
    pause
}

install_tool() {
    local name=$1
    local temp_file="/tmp/$name"

    echo -e "\nInstalling ${BOLD}$name${NC}..."
    
    if [ "$MODE" == "LOCAL" ]; then
        local src="tools/$name/$name"
        if [ ! -f "$src" ]; then
            echo -e "${RED}Error: Source file not found locally.${NC}"
            return
        fi
        cp "$src" "$temp_file"
    else
        echo -e "${BLUE}Downloading from GitHub...${NC}"
        local src_url="$RAW_URL/$name/$name"
        status=$(curl -s -o "$temp_file" -w "%{http_code}" "$src_url")
        if [ "$status" -ne 200 ]; then
            echo -e "${RED}Error downloading file (HTTP $status).${NC}"
            rm -f "$temp_file"
            return
        fi
    fi

    if [ "$EUID" -ne 0 ]; then 
        echo -e "${BLUE}Root privileges required (sudo)...${NC}"
        sudo mv "$temp_file" "$INSTALL_DIR/$name"
        sudo chmod +x "$INSTALL_DIR/$name"
    else
        mv "$temp_file" "$INSTALL_DIR/$name"
        chmod +x "$INSTALL_DIR/$name"
    fi

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}Successfully installed!${NC}"
        echo -e "Run with: ${BOLD}$name${NC}"
    else
        echo -e "${RED}Installation failed.${NC}"
    fi
}

while true; do
    show_menu
    read main_choice
    
    if [[ ! "$main_choice" =~ ^[0-9]+$ ]]; then
        sleep 1
        continue
    fi
    
    if [ "$main_choice" -eq 0 ]; then
        echo "Bye!"
        exit 0
    fi
    
    index=$((main_choice-1))
    
    if [ $index -ge 0 ] && [ $index -lt ${#TOOLS[@]} ]; then
        show_tool_page "${TOOLS[$index]}"
    else
        echo "Invalid selection."
        sleep 1
    fi
done
