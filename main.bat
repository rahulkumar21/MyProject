SET PTH=D:\OPR\New-folder
SET SUMMARY=%PTH%\summary.log
rem SIEBEL Environment Variables
SET Siebel_ENVT=PF_SANDBOX
SET Siebel_DRIVE=E:
SET Siebel_INST=E:\sb\siebsrvr\BIN
SET Siebel_ENT=siebel_enterprise
SET Siebel_GTWY=Gateway_Host_Name:2320
SET Siebel_USR=sadmin
SET Siebel_PASS=Passw0rd
SET comp2chk=SisnTcpIp
REM set monitoring task here common for all component events
SET compMON=eMedicalObjMgr_enu WfProcBatchMgr
REM set components here which need to enable basic level of monitoring
%Script_DRIVE%
cd %PTH%
call %PTH%\Comp-log-chk.bat
rem pause
IF EXIST %PTH%\consolidated-compst.log del %PTH%\consolidated-compst.log
IF EXIST %PTH%\log_decrease_cmd.log del %PTH%\log_decrease_cmd.log
call %PTH%\Processing.bat

for %%S in (%PTH%\log_decrease_cmd.lst) do (
if %%~zS neq 0 (
%Siebel_INST%\srvrmgr /e %Siebel_ENT% /g %Siebel_GTWY% /u %Siebel_USR% /p %Siebel_PASS% -i %PTH%\log_decrease_cmd.lst -o %PTH%\log_decrease_cmd.log
echo ^</table^>^</body^>^</html^> >> %SUMMARY% ) else (
echo ^</body^>^</html^> >> %SUMMARY%)
)

cscript %PTH%\mail.vbs %PTH% log_decrease_cmd.log %Siebel_ENT% %Siebel_ENVT%

echo =====================================
echo execution of script is successfull
echo Email has been sent
echo =====================================
