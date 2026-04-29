# kdb+ High-Frequency Tickerplant

A robust, fault-tolerant options tickerplant built from scratch using **kdb+/q**. This project simulates a high-frequency trading environment, processing live market data across major tech stocks with nanosecond precision, real-time analytics, and asynchronous unified querying.

## 🏗️ Architecture Overview

This project implements a classic tiered kdb+ architecture used by top-tier investment banks and hedge funds:

1.  **Data Generator (`generator.q`)**: Simulates a live market feed, publishing 20 unique options quotes every 250ms (80 quotes per second) across Apple, Microsoft, Nvidia, Tesla, and Amazon.
2.  **Tickerplant (`tp.q`)**: The central router. It writes all incoming ticks to a binary transaction log on disk for disaster recovery, then broadcasts the data to all subscribed downstream processes.
3.  **Real-Time Database (`rdb.q`)**: Subscribes to the Tickerplant to store the current day's live market data in-memory (RAM) for ultra-fast querying. Includes an End-of-Day (`eod[]`) function to flush memory to disk.
4.  **Historical Database (`hdb.q`)**: Loads partitioned, on-disk historical data for long-term storage and backtesting.
5.  **Complex Event Processor (`cep.q`)**: A real-time analytics engine that calculates live mid-prices, bid-ask spreads, and tick volumes on the fly.
6.  **Unified Gateway (`gw.q`)**: The single API access point[cite: 6]. It utilizes asynchronous IPC to query the HDB and RDB in parallel, stitching historical and live data into a single seamless table.

## ✨ Key Features

* **Zero-Data-Loss Disaster Recovery**: If the RDB or CEP crashes mid-day, they automatically locate today's binary log file, replay missed ticks, and resubscribe to the live feed upon startup.
* **Parallel Query Execution**: The Gateway queries disk and RAM simultaneously, significantly reducing query latency.
* **1-Click Deployment**: Compatible with Windows Terminal batch scripts to launch the entire distributed system in a tabbed, split-pane dashboard.

## 📂 Repository Structure

```text
/config
  schema.q              # Centralized table definitions (quotes, trades)
/tp_logs                # Directory for daily binary transaction logs
/hdb_data               # Directory for on-disk historical data partitions
generator.q             # Market data simulator (80 ticks/sec)
tp.q                    # Tickerplant router (Port 5000)
hdb.q                   # Historical DB (Port 5001)
rdb.q                   # Real-Time DB (Port 5002)
gw.q                    # Parallel Gateway (Port 5003)
cep.q                   # Analytics Engine (Port 5004)
start_dashboard.bat     # Windows Terminal auto-launcher
```

## 🚀 Quick Start

### Prerequisites
* [kdb+ personal edition](https://code.kx.com/q/learn/install/) installed and added to your system PATH.
* Windows Terminal (recommended for the automated launch script).

### Running the Plant
1.  Clone this repository within your kdb+ installation folder.
2.  Run your deployment script (e.g., `start_dashboard.bat`).
3.  Observe 7 localized processes spinning up and routing live options data instantly.

### Querying the System
Interact with the system through the **Gateway** terminal (Port 5003):

```q
// Fetch the complete combined history + live data for a specific option:
q) getQuotes[`NVDA260515C00800000]

// Example Output:
time                          sym                  ... bid   ask   bsize asize date
-----------------------------------------------------------------------------------------
0D14:11:03.309587900 NVDA260515C00800000  ... 14.20 14.25 45    12    2026.04.29
0D14:11:04.323287000 NVDA260515C00800000  ... 14.18 14.22 10    88    2026.04.29
```

Check the **Analytics** terminal (Port 5004) to view live CEP metrics:
```q
q) liveDashboard
```

## 🛠️ Disaster Recovery Demonstration
To test fault tolerance:
1.  Ensure the system is running and data is flowing.
2.  Terminate the `rdb.q` process (`Ctrl+C`).
3.  Wait 10 seconds, then restart: `q rdb.q -p 5002`.
4.  The RDB will locate the log file, replay missed ticks, restore its state, and resubscribe to the Tickerplant.
