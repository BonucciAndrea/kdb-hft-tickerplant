// config/schema.q


/ Quotes Table
quotes:([]
    time:`timespan$();
    sym:`symbol$();
    underlying:`symbol$();
    otype:`char$();
    expiry:`date$();
    strike:`float$();
    bid:`float$();
    ask:`float$();
    bsize:`long$();
    asize:`long$()
 )

/ Trades Table
trades:([]
    time:`timespan$();
    sym:`symbol$();
    underlying:`symbol$();
    otype:`char$();
    expiry:`date$();
    strike:`float$();
    price:`float$();
    size:`long$()
 )