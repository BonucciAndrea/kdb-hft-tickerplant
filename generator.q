// generator.q
\l config/schema.q

tpHandle: hopen 5000;

n: 20; 
currentBids: n ? 150.0;

publishTick: {[]
    currentBids:: 0.01 | currentBids + -0.10 + n ? 0.20;
    currentAsks: currentBids + (n ? 0.05) + 0.01;
    
    newData: flip `time`sym`underlying`otype`expiry`strike`bid`ask`bsize`asize!(
        `timespan$ n # .z.n;
        `symbol$ `AAPL260515C00150000`AAPL260515P00150000`AAPL260619C00200000`AAPL260619P00200000`MSFT260515C00300000`MSFT260515P00300000`MSFT260619C00350000`MSFT260619P00350000`NVDA260515C00800000`NVDA260515P00800000`NVDA260619C00900000`NVDA260619P00900000`TSLA260515C00200000`TSLA260515P00200000`TSLA260619C00250000`TSLA260619P00250000`AMZN260515C00150000`AMZN260515P00150000`AMZN260619C00180000`AMZN260619P00180000;
        `symbol$ `AAPL`AAPL`AAPL`AAPL`MSFT`MSFT`MSFT`MSFT`NVDA`NVDA`NVDA`NVDA`TSLA`TSLA`TSLA`TSLA`AMZN`AMZN`AMZN`AMZN;
        `char$ "cpcpcpcpcpcpcpcpcpcp";
        `date$ 2026.05.15 2026.05.15 2026.06.19 2026.06.19 2026.05.15 2026.05.15 2026.06.19 2026.06.19 2026.05.15 2026.05.15 2026.06.19 2026.06.19 2026.05.15 2026.05.15 2026.06.19 2026.06.19 2026.05.15 2026.05.15 2026.06.19 2026.06.19;
        `float$ 150.0 150.0 200.0 200.0 300.0 300.0 350.0 350.0 800.0 800.0 900.0 900.0 200.0 200.0 250.0 250.0 150.0 150.0 180.0 180.0;
        `float$ currentBids;
        `float$ currentAsks;
        `long$ n ? 100;
        `long$ n ? 100
    );

    neg[tpHandle] (`upd; `quotes; newData);
    
    // This will print a dot to the screen every 1ms so you know it's alive!
    1 "."; 
 };

.z.ts: publishTick;
\t 1 

-1 "\nGenerator started. Pushing 20 quotes every 1ms (20000/sec)...";
