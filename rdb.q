// rdb.q
\l config/schema.q

// 1. Define update function
upd:{[tName;tData]
    tName insert tData;
 };

// 2. End-of-Day function
eod: {[]
    -1 "Starting EOD flush to disk...";
    .Q.dpft[`:hdb_data; .z.D; `sym; `quotes];
    delete from `quotes;
    delete from `trades;
    -1 "EOD Flush complete. RAM cleared.";
 };

// 3. Recovery
logFile:hsym`$"tp_logs/log_",string .z.D;
-1 "Checking for log file: ", string logFile;

if[not () ~ key logFile;
    -1 " [OK] Log found. Starting replay...";
    .[{-11!x}; enlist logFile; {-1 " [!] Replay Error: ", x}];
    -1 "Recovery complete. Total rows now: ", string count quotes;
 ];

// 4. Connect and subscribe to tickerplant
tpHandle: hopen 5000;
tpHandle "sub[`quotes]";
tpHandle "sub[`trades]";
-1 "RDB successfully subscribed.";
