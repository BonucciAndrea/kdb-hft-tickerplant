// gw.q - The Parallel Unified Query Gateway

// 1. Connect to both databases
hdbHandle: hopen 5001; // Historical DB
rdbHandle: hopen 5002; // Real-Time DB

// 2. The Master Query Function (Parallelized)
getQuotes: {[ticker]
    // A. Asynchronous send (Fire both queries simultaneously)
    // We use neg[.z.w] inside the query so the remote database knows to send the answer back!
    neg[hdbHandle] ({[t] neg[.z.w] select from quotes where sym = t}; ticker);
    neg[rdbHandle] ({[t] neg[.z.w] select from quotes where sym = t}; ticker);
    
    // B. Block and collect
    // Calling the handle with an empty list [] forces the Gateway to wait
    // for the answer to return on that specific network socket.
    hdbData: hdbHandle [];
    rdbData: rdbHandle [];
    
    // C. Format and Stitch
    // Stamp today's date onto the RDB data so it matches the HDB schema
    rdbData: update date:.z.D from rdbData;
    combinedData: hdbData uj rdbData;
    
    // D. Return the final table
    : combinedData;
 };

-1 "\nParallel Gateway is online!";
-1 "To query, type: getQuotes[`AAPL260515C00150000]";
