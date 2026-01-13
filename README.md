# 💰 Multi-Currency Budget & Salary Calculator

![Budget Salary Banner](budget_salary_banner.png)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Shell Script](https://img.shields.io/badge/shell-bash-4EAA25.svg)](https://www.gnu.org/software/bash/)
[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](#)

A cross-platform CLI tool designed for international contractors and digital nomads to calculate pre-tax salary requirements based on net expenses and real-time market exchange rates.

## ✨ Features

*   **🔒 YAML-based Configuration:** Keep your budget private and organized in a human-readable format.
*   **🌍 Live Exchange Rates:** Automatically fetches the latest USD rates from the ExchangeRate API.
*   **📈 Dynamic Calculations:** Automatically accounts for income tax gross-up for any currency.
*   **🚀 One-Command Setup:** Dependency validation and auto-installation for macOS and Linux.

## 🚀 Quick Start

### 1. Installation
Clone the repository and ensure the script is executable:

```bash
git clone https://github.com/yourusername/budget-salary.git
cd budget-salary
chmod +x bdgt.sh
```

### 2. Configure Your Budget
Create your personal configuration from the template:

```bash
cp config.example.yaml config.yaml
```

Then edit `config.yaml` with your details:

```yaml
currency: BRL       # Your local currency (e.g., EUR, BRL, JPY)
tax_rate: 0.275     # Your effective income tax rate (e.g., 27.5% = 0.275)
budget:
  rent: 3700
  food: 1000
  health_insurance: 600
  desired_savings: 2000
```

### 3. Run it
```bash
./bdgt.sh
```

## 🖥️ Example Output

When you run the script, you'll see a clean breakdown of your financial requirements:

```text
Budget Calculator v0.1 - 12 Jan 2026
------------------------------------------
Base Currency:    BRL
Total Budget:     12840.00 BRL
Gross Salary:     17710.34 BRL
Gross Salary USD: $ 3294.12
------------------------------------------
```

## 🛠️ Prerequisites

The script utilizes standard Unix utilities. If missing, *it will attempt to install them*:
*   `yq`: High-level YAML processor.
*   `jq`: Lightweight JSON processor for API data.
*   `bc`: Arbitrary precision calculator for math.
*   `curl`: To fetch real-time exchange data.

## 🧮 How it Works

The script calculates your target income using the following logic:

1.  **Aggregation**: Sums all line items under the `budget` key in your configuration.
2.  **Gross-up Formula**: Calculates the gross salary required to cover net expenses after taxes.
    $$\text{Salary}_{\text{Gross}} = \frac{\sum (\text{Budget Items})}{1 - \text{Tax Rate}}$$
3.  **Currency Conversion**: Fetches the current exchange rate (`BASE` → `USD`) to provide a global benchmark.

## ⚠️ Troubleshooting

*   **API Error**: If the exchange rate API is unreachable, the script uses a fallback rate (0.18 for BRL/USD).
*   **Permission Denied**: Run `chmod +x bdgt.sh` to allow the script to execute.
*   **Wait, where is my currency?**: Check [ExchangeRate-API supported codes](https://www.exchangerate-api.com/docs/supported-currencies) to ensure your `currency` key is correct.

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.