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
    echo "2. Brief Notes X Article or LegalCase"
    echo "3. Brief Notes X Specific Topic"
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
            
            read -p "Enter the complete name of LegalArticle/LegalCase: " name_input
            SEARCH_QUERY="Brief notes on:${name_input} under irish jurisdiction"
            response=$(chatgpt_search "$SEARCH_QUERY")
            echo -e "Brief notes for ${name_input}:\n$response"
            ;;
        3)
            read -p "Enter the name of specific topic(ie. legitemate expectation): " topic_input
            SEARCH_QUERY="Explain the concept of:${topic_input} under Irish jurisdiction, listing relevant key cases, the most commonly applied problem questions and essay questionsdiscussing its practical applications"
            response=$(chatgpt_search "$SEARCH_QUERY")
            echo -e "fundamental principles of ${topic_input}:\n$response"
            ;;    

        4)  
            read -p "Enter the name of doctrine(ie. legitemate expectation): " doctrine_input
            SEARCH_QUERY="Explain the fundamental principles of:${doctrine_input} under irish jurisdiction"
            response=$(chatgpt_search "$SEARCH_QUERY")
            echo -e "fundamental principles of ${doctrine_input}:\n$response"
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
