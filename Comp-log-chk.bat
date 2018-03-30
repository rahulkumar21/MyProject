@echo off
SetLocal EnableExtensions EnableDelayedExpansion

cls
%Script_DRIVE%
IF EXIST %PTH%\server_status.log del %PTH%\server_status.log
IF EXIST %PTH%\serverlst.log del %PTH%\serverlst.log
%Siebel_INST%\srvrmgr /e %Siebel_ENT% /g %Siebel_GTWY% /u %Siebel_USR% /p %Siebel_PASS% -k ; -i %PTH%\server_status.lst -o %PTH%\server_status.log
rem choice /d y /t 5 > nul
rem rem timeout /t 10
cd %PTH%
findstr /E ; %PTH%\server_status.log > %PTH%\serverlst.log
IF EXIST %PTH%\server_status.log del %PTH%\server_status.log

rem pause
for /F "tokens=1,2 delims=;" %%i in ('type %PTH%\serverlst.log') do call :READsrvr %%i %%j
:READsrvr
set VAR1=%1
set VAR2=%2

IF [%1]==[] (
echo Value VAR Missing. exiting
EXIT /B 0
)
IF [%2]==[] (
echo Value Missing. exiting
EXIT /B 0
)


echo Connecting Server %VAR1% and its status is %VAR2%
IF EXIST %PTH%\%VAR1%-compst.log del %PTH%\%VAR1%-compst.log
cd %PTH%
%Siebel_INST%\srvrmgr /e %Siebel_ENT% /g %Siebel_GTWY% /u %Siebel_USR% /p %Siebel_PASS% -s %VAR1% -k ; -c "list comp show CC_ALIAS" > %PTH%\%VAR1%-comptmp.log
findstr /E ;  %PTH%\%VAR1%-comptmp.log> %PTH%\%VAR1%-comptmp2.log
more +1 %PTH%\%VAR1%-comptmp2.log > %PTH%\%VAR1%-comp.log
del %PTH%\%VAR1%-comptmp.log
del %PTH%\%VAR1%-comptmp2.log

rem pause
for /F "tokens=1 eol=;" %%a in ('type %PTH%\%VAR1%-comp.log') do call :READcomp %%a
:READcomp
set Vcomp1=%1
rem echo Component Status on server %VAR1% > %PTH%\%VAR1%-%Vcomp1%-compsttmp.log
echo Connected Server %VAR1% and checking comp loglevel %Vcomp1%

cd %PTH%
%Siebel_INST%\srvrmgr /e %Siebel_ENT% /g %Siebel_GTWY% /u %Siebel_USR% /p %Siebel_PASS% -s %VAR1% -k ; -c "list evtloglvl %comp2chk% for comp %Vcomp1% show CC_ALIAS, EC_LOGHNDL_LVL" >> %PTH%\%VAR1%-%Vcomp1%-compsttmp.log
findstr /E ;  %PTH%\%VAR1%-%Vcomp1%-compsttmp.log > %PTH%\%VAR1%-%Vcomp1%-compsttmp2.log
rem more +1 %PTH%\%VAR1%-%Vcomp1%-compsttmp2.log > %PTH%\%VAR1%-%Vcomp1%-compst.log
more +1 %PTH%\%VAR1%-%Vcomp1%-compsttmp2.log >> %PTH%\%VAR1%-compst.log
del %PTH%\%VAR1%-%Vcomp1%-compsttmp.log
del %PTH%\%VAR1%-%Vcomp1%-compsttmp2.log


endlocal
exit /B 0
