# Multi-Currency Budget & Salary Calculator

Cross-platform CLI tool to calculate pre-tax salary requirements based on net expenses and live market rates.

## Features

* **YAML-based Configuration:** Manage your monthly expenses in a clean, human-readable format.
* **Live Exchange Rates:** Fetches real-time data from the ExchangeRate API to convert your target salary to USD.
* **Dynamic Currency Support:** Set your base currency (BRL, EUR, etc.) in the config and the script adjusts automatically.
* **Dependency Validation:** Automatically checks for required CLI tools before running.

## Prerequisites

The script requires the following tools:

* `yq`: To parse YAML configuration.
* `jq`: To parse JSON API responses.
* `bc`: For high-precision floating-point math.
* `curl`: To fetch exchange rates.

### Installation

**macOS:**

```bash
brew install yq jq bc

```

**Linux (Ubuntu/Debian):**

```bash
sudo apt update
sudo apt install yq jq bc curl

```

## Configuration

Create a `config.yaml` file in the root directory. You can define your local currency, your income tax bracket, and a list of expenses.

```yaml
currency: BRL       # Your local currency (defaults to BRL)
tax_rate: 0.275     # e.g., 27.5% expressed as 0.275
budget:
  rent: 3700
  food: 1000
  internet: 150
  health_insurance: 600
  desired_savings: 2000

```

## Usage

1. **Clone the repository:**
```bash
git clone https://github.com/yourusername/budget-salary.git
cd budget-salary

```


2. **Make the script executable:**
```bash
chmod +x bdgt.sh

```


3. **Run the script:**
```bash
# Uses config.yaml by default
./bdgt.sh

# Or specify a custom config file
./bdgt.sh my_september_budget.yaml

```



## How it Works

The script follows a specific mathematical flow to determine your target income:

1. **Summation:** It aggregates all values under the `budget` key in your YAML.
2. **Gross-up:** It calculates the required gross salary before taxes using the formula:
$$Salary_{Gross} = \frac{\sum (Budget\ Items)}{1 - Tax\ Rate}$$
3. **Conversion:** It fetches the current exchange rate and calculates the final value for international billing or comparison.

## 📄 License

MIT