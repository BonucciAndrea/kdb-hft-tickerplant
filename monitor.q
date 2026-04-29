// monitor.q - Fixed Version

nodes: `tp`hdb`rdb`gw`cep ! 5000 5001 5002 5003 5004;

checkHealth: {[]
    -1 "--- SYSTEM HEALTH CHECK (", (string .z.P), ") ---";
    
    // Iterate over the keys of the dictionary
    { [name]
        port: nodes[name];
        // Try to connect to the port
        h: @[hopen; port; 0i];
        
        if[h = 0i; 
            -1 " [!] ", (upper string name), " (Port ", (string port), ") - OFFLINE";
            :( )
        ];
        
        // If online, grab the memory usage
        stats: h "(.Q.w[]`used) div 1024"; 
        hclose h;
        
        -1 " [OK] ", (upper string name), " (Port ", (string port), ") - Memory Used: ", (string stats), " KB";
        
    } each key nodes; // Simplified iteration
    
    -1 "--------------------------------------------------";
 };

.z.ts: {checkHealth[]};
\t 5000