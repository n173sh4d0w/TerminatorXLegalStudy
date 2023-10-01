#!/bin/bash

# Function to perform an auto-login using Lynx
auto_login() {
    LOGIN_URL="https://chat.openai.com/login"
    USERNAME="your_username"
    PASSWORD="your_password"
    lynx -cmd_log=lynxlog.txt -accept_all_cookies -post_data "username_field=$USERNAME&password_field=$PASSWORD" -cookie_save_file=cookies.txt "$LOGIN_URL"
    rm lynxlog.txt
}

# Function for interacting with ChatGPT search
chatgpt_search() {
    QUERY="$1"
    SEARCH_URL="https://chat.openai.com/search"
    lynx -cmd_log=lynxlog.txt --dump -post_data "search_field=$QUERY" "$SEARCH_URL"
    grep -oP 'Result: \K.*' lynxlog.txt
    rm lynxlog.txt
}

# Auto-login to ChatGPT
auto_login

# Main menu
while true; do
    echo -e "\nSelect an option:"
    echo "1. Case Briefing"
    echo "2. Brief Notes X Topic"
    echo "3. Brief Notes X Article or LegalCase"
    echo "4. Principles Listing"
    echo "5. Exit"
    read -p "Enter your choice (1/2/3/4/5): " choice

    case $choice in
        1)
            read -p "Enter the domain: " domain_input
            read -p "Enter the case name: " casename_input
            SEARCH_QUERY="From :${domain_input} perspective, case briefing for :${casename_input} in facts, holding, rules formulated. In addition, outline and discuss reasoning in detail including dissents in the most succinct manner"
            response=$(chatgpt_search "$SEARCH_QUERY")
            echo -e "Case Briefing for ${casename_input}:\n$response"
            ;;
        2)
            prompt="Provide brief notes on: X under irish jurisdiction ;
            list key cases on : X under irish jurisdiction ;
            list the most commonly applied problem questions and essay questions on : X under irish jurisdiction ;
            Explain the concept of : X in the context of Irish property law, citing relevant cases and discussing its practical applications;"
            brief_notes "$prompt" "topic_input" 100
            ;;
        3)
            brief_notes "Brief notes on: X" "ArticleorLegalCase_input" 150
            ;;
        4)
            brief_notes "Explain the fundamental principles of: X" "doctrine_input" 150
            ;;
        5)
            echo "Exiting the program."
            exit
            ;;
        *)
            echo "Invalid choice. Please select a valid option (1/2/3/4/5)."
            ;;
    esac
done
