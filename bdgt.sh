#!/bin/bash

# --- 1. Help Information ---
show_help() {
    echo "Usage: ./bdgt.sh [CONFIG_FILE]"
    echo ""
    echo "Calculate gross salary requirements based on net expenses and real-time exchange rates."
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
    echo ""
    echo "Defaults to 'config.yaml' if no file is provided."
    exit 0
}

# Check for help flag
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    show_help
fi

# --- 2. OS Detection & Dependency Auto-Installer ---
install_dependencies() {
    OS_TYPE="$(uname -s)"
    
    # List of required commands
    local deps=("yq" "jq" "bc" "curl")
    local missing=()
    for tool in "${deps[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            missing+=("$tool")
        fi
    done

    if [ ${#missing[@]} -eq 0 ]; then
        return
    fi

    echo "Detected OS: $OS_TYPE"
    echo "Missing dependencies: ${missing[*]}"
    
    case "$OS_TYPE" in
        Darwin)
            echo "Attempting to install via Homebrew..."
            brew install "${missing[@]}"
            ;;
        Linux)
            if command -v apt-get &> /dev/null; then
                echo "Attempting to install via apt..."
                sudo apt-get update && sudo apt-get install -y "${missing[@]}"
            elif command -v pacman &> /dev/null; then
                echo "Attempting to install via pacman..."
                sudo pacman -S --noconfirm "${missing[@]}"
            else
                echo "Unsupported Linux distro. Please install ${missing[*]} manually."
                exit 1
            fi
            ;;
        *)
            echo "Unsupported OS. Please install dependencies manually."
            exit 1
            ;;
    esac
}

# Run the installer check
install_dependencies

# --- 3. Configuration & Logic ---
CONFIG_FILE="${1:-config.yaml}"
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "Error: Config file '$CONFIG_FILE' not found."
    echo "Try: cp config.example.yaml config.yaml"
    exit 1
fi

BASE_CURRENCY=$(yq '.currency // "BRL"' "$CONFIG_FILE")
TAX_RATE=$(yq '.tax_rate // 0' "$CONFIG_FILE")
TOTAL_BUDGET=$(yq '.budget | to_entries | map(.value) | join("+")' "$CONFIG_FILE" | bc)
DESIRED_SALARY_BASE=$(echo "scale=2; $TOTAL_BUDGET / (1 - $TAX_RATE)" | bc -l)

# Fetch Exchange Rate
EXCHANGE_RATE=$(curl -s "https://open.er-api.com/v6/latest/${BASE_CURRENCY}" | jq -r '.rates.USD // empty')

if [[ -z "$EXCHANGE_RATE" ]]; then
    EXCHANGE_RATE="0.18"
    echo "Warning: Using fallback rate."
fi

DESIRED_SALARY_USD=$(echo "scale=2; $DESIRED_SALARY_BASE * $EXCHANGE_RATE" | bc -l)

# --- 4. Output ---
echo "Budget Calculator v0.1 - $(date +"%d %b %Y")"
echo "------------------------------------------"
printf "Base Currency:    %s\n" "$BASE_CURRENCY"
printf "Total Budget:     %.2f %s\n" "$TOTAL_BUDGET" "$BASE_CURRENCY"
printf "Gross Salary:     %.2f %s\n" "$DESIRED_SALARY_BASE" "$BASE_CURRENCY"
printf "Gross Salary USD: $ %.2f\n" "$DESIRED_SALARY_USD"
echo "------------------------------------------"