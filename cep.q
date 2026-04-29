// cep.q
\l config/schema.q

// 1. Initialize the Dashboard FIRST
liveDashboard:([sym:`symbol$()] midPrice:`float$(); spread:`float$(); ticks:`long$());

// 2. DEFINE THE UPDATE FUNCTION SECOND
upd:{[tName;tData]
    if[tName=`quotes;
        LASTCEPDATA::tData;
        
        metrics: select 
            midPrice: last (bid+ask)%2.0, 
            spread: last ask-bid, 
            ticks: count i 
            by sym from tData;
            
        .[ { liveDashboard ,: x }; enlist metrics; { -1 "CEP ERROR: ", x } ];
    ];
 };

// 3. RECOVER STATE
logFile:hsym`$"tp_logs/log_",string .z.D;
-1 "Checking for log file: ", string logFile;

if[not () ~ key logFile;
    -1 " [OK] Log found. Starting replay...";
    .[{-11!x}; enlist logFile; {-1 " [!] Replay Error: ", x}];
    -1 "Recovery complete. Dashboard rows: ", string count liveDashboard;
 ];

// 4. Connect and Subscribe to Live Data
tpHandle:hopen 5000;
tpHandle "sub[`quotes]";
-1 "CEP Engine Online! Dashboard initialized.";