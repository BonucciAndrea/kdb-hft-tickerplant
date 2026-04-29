@echo off
echo Launching High-Frequency Dashboard...

wt -w 0 new-tab -d . --title "Core Engine" cmd /k "q tp.q -p 5000" ; split-pane -V -d . cmd /k "timeout 2 >nul & q generator.q" ; new-tab -d . --title "Databases" cmd /k "timeout 1 >nul & q rdb.q -p 5002" ; split-pane -V -d . cmd /k "timeout 1 >nul & q hdb.q -p 5001" ; new-tab -d . --title "Analytics" cmd /k "timeout 1 >nul & q cep.q -p 5004" ; split-pane -V -d . cmd /k "timeout 1 >nul & q gw.q -p 5003" ; split-pane -H -d . cmd /k "timeout 1 >nul & q monitor.q"

pause