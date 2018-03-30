@echo off
cls
%Script_DRIVE%
cd %PTH%
rem call Comp-log-chk.bat
rem rem IF EXIST %PTH%\consolidated-compst.log del %PTH%\consolidated-compst.log
IF EXIST %PTH%\log_decrease_cmd.lst del %PTH%\log_decrease_cmd.lst
IF EXIST %SUMMARY% del %SUMMARY%
rem findstr 5 %VAR1%-compst.log > %PTH%\consolidated-compst.log
echo =========================================
echo Processing file to consolidate the ouput
echo =========================================
findstr 5 *-compst.log > %PTH%\consolidated-compst.log
echo. 2> %SUMMARY%
REM All components are NORMAL STATE
for %%S in (%PTH%\consolidated-compst.log) do (
if %%~zS leq 0 (
echo ^<html^>^<body^> >> %SUMMARY%
Echo ^<p^>All components are already set to normal state^</p^> >> %SUMMARY%
EXIT /B 0)
)
echo. 2> %PTH%\log_decrease_cmd.lst
REM creating html body Header
echo ^<html^>^<body style="background-color:#f0f0f5" ^> >> %SUMMARY%
echo ^<table border="1" cellpadding="8" ^> >> %SUMMARY%
echo ^<tr^> >> %SUMMARY%
echo 	^<td style="width:50px; text-align:center;font-weight: 900;color:BLACK; background-color:#5555ff"^> >> %SUMMARY%
echo 		SERVER >> %SUMMARY%
echo 	^</td^> >> %SUMMARY%
echo 	^<td style="width:150px; text-align:center;font-weight: 900;color:BLACK; background-color:#5555ff"^> >> %SUMMARY%
echo 		COMPONENT >> %SUMMARY%
echo 	^</td^> >> %SUMMARY%
echo 	^<td style="width:50px; text-align:center;font-weight: 900;color:BLACK; background-color:#5555ff"^> >> %SUMMARY%
echo 		LOG LEVEL >> %SUMMARY%
echo 	^</td^> >> %SUMMARY%
echo 	^<td style="width:50px; text-align:center;font-weight: 900;color:BLACK; background-color:#5555ff"^> >> %SUMMARY%
echo 		DECREASED >> %SUMMARY%
echo 	^</td^> >> %SUMMARY%
echo 	^<td style="width:50px; text-align:center;font-weight: 900;color:BLACK; background-color:#5555ff"^> >> %SUMMARY%
echo 		SET MONITORING >> %SUMMARY%
echo 	^</td^> >> %SUMMARY%
echo ^</tr^> >> %SUMMARY%
REM created html body Header
setlocal enableDelayedExpansion
cls
for /F "tokens=1,2,3,4 delims=-:;" %%i in ('type %PTH%\consolidated-compst.log') do call :READst %%i %%j %%k %%l
:READst
SET v1=%1
SET v2=%2
SET v3=%3
SET v4=%4
IF [%1]==[] (
echo Value VAR Missing. exiting
EXIT /B 0
)
IF [%2]==[] (
echo Value Missing. exiting
EXIT /B 0
)
IF [%3]==[] (
echo Value VAR Missing. exiting
EXIT /B 0
)
IF [%4]==[] (
echo Value Missing. exiting
EXIT /B 0
)
rem cls
rem REM HTML BODY DATA goes here

echo ^<tr^> >> %SUMMARY%
echo 	^<td style="width:50px; text-align:center; color:BLACK"^> >> %SUMMARY%
echo %v1% >> %SUMMARY%
echo 	^</td^> >> %SUMMARY%
echo 	^<td style="width:150px; text-align:left; color:BLACK"^> >> %SUMMARY%
echo %v3% >> %SUMMARY%
echo 	^</td^> >> %SUMMARY%
echo 	^<td style="width:50px; text-align:center; color:BLACK"^> >> %SUMMARY%
echo %v4% >> %SUMMARY%
echo 	^</td^> >> %SUMMARY%

SET d=N
for %%a in (%compMON%) do (
	If %%a == %v3% (
		SET d=Y
		goto JMP
	) else (
		SET d=N
	)
)
:JMP
IF "%d%" EQU "Y" (
	echo 	^<td style="width:50px; text-align:center; color:BLACK; background-color:#55ff55"^> >> %SUMMARY%
	echo Yes >> %SUMMARY%
	echo 	^</td^> >> %SUMMARY%
		echo 	^<td style="width:50px; text-align:center; color:BLACK; background-color:#55ff55"^> >> %SUMMARY%
		echo Yes >> %SUMMARY%
		echo 	^</td^> >> %SUMMARY%
	echo ^</tr^> >> %SUMMARY%
	echo We are setting component %v3% to monitoring level

	echo set server %v1% >> %PTH%\log_decrease_cmd.lst
	echo change evtloglvl %%=1 for Comp %v3% >> %PTH%\log_decrease_cmd.lst 
	echo change evtloglvl TaskConfig=4 for comp %v3% >> %PTH%\log_decrease_cmd.lst
	echo change evtloglvl ObjMgrSqlLog=4 for comp %v3% >> %PTH%\log_decrease_cmd.lst
	echo change evtloglvl SQLParseAndExecute=4 for comp %v3% >> %PTH%\log_decrease_cmd.lst
	echo change evtloglvl ObjMgrSqlCursorLog=5 for comp %v3% >> %PTH%\log_decrease_cmd.lst
	echo change evtloglvl objmgrsessionlog=5 for comp %v3% >> %PTH%\log_decrease_cmd.lst
	echo change evtloglvl EventContext=4 for comp %v3% >> %PTH%\log_decrease_cmd.lst
	echo change evtloglvl EAITransport=5 for comp %v3% >> %PTH%\log_decrease_cmd.lst
	echo change evtloglvl ObjMgrBusServiceLog=4 for comp %v3% >> %PTH%\log_decrease_cmd.lst ) else (
	echo 	^<td style="width:50px; text-align:center; color:BLACK; background-color:#55ff55"^> >> %SUMMARY%
	echo Yes >> %SUMMARY%
		echo 	^</td^> >> %SUMMARY%
		IF %compMON% == "" (
			echo 	^<td style="width:50px; text-align:center; color:BLACK"^> >> %SUMMARY% ) ELSE (
			echo 	^<td style="width:50px; text-align:center; color:BLACK; background-color:#ff5555"^> >> %SUMMARY% )
		echo No >> %SUMMARY%
		echo 	^</td^> >> %SUMMARY%
	echo ^</tr^> >> %SUMMARY%
	REM echo Server = %v1% ; Component = %v3% ; Current Status = %v4% ; Comment = Skipping monitoring level
	echo We have skipped component %v3% to set monitoring level
	echo set server %v1% >> %PTH%\log_decrease_cmd.lst
	echo change evtloglvl %%=1 for Comp %v3% >> %PTH%\log_decrease_cmd.lst )
rem pause
endlocal
REM CLosing HTML BODY

EXIT /B 0
