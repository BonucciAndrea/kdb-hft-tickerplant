// tp.q
\l config/schema.q

/ Subscribe Function
subs:()!()

sub:{[tableName]
    subs[tableName]:distinct subs[tableName], .z.w;
    -1 "Subscriber ", (string .z.w), " connected to ", (string tableName);
    (tableName; 0#value tableName)
 }

/ Transaction Log
logFile:hsym`$"tp_logs/log_",string .z.D;

// --- NUCLEAR CLEAN SLATE ---
// Force delete the old log file to guarantee no corrupted data survives
if[not ()~key logFile; 
    -1 "Deleting corrupted log file...";
    hdel logFile;
 ];

logFile set ();
logHandle: hopen logFile;

/ Update Function
upd:{[tableName;tableData]
    logHandle enlist (`upd;tableName;tableData);
    
    handles:subs[tableName];
    if[count handles;{neg[x](`upd;y;z)}[;tableName;tableData]each handles;];
 }

/ Disconnection Handler
.z.pc:{[handle] 
    subs::subs except\: handle;
    -1"Subscriber ",(string handle)," disconnected.";
 }