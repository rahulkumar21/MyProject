PROJECT NAME = This is project for log level decrease at siebel enterprise level automatically
----------------------------------------------------------------------------------------------

In this code, we have total 6 files name as
main.bat		--> Control Envt. variable and calling sequence	

Comp-log-chk.bat	--> Responsible to check each server in enterprise, connect each server & check components on each server. Then connect to each component and check the log level of the component by server manage commands.

server_status.lst	--> This is Server manager command file useful only to list the server inside the enterprise

Processing.bat		--> This bat file is responsible to find the component having log level 5, then connect to each such server component to reduce it to normal state. As well if defined to set monitoring in main.bat, then do set monitoring at the component level.

mail.vbs		--> This is basically used to email the summary status as well as commands ran on siebel server manager console i.e. findstr "srvrmgr" in log_decrease_cmd.log file.

ARCHITECTURE AND CALLING PROCESS :
---------------------------------
Calling process of each script file as below
Windows schedule task triggered -->	main.bat --> 	Comp-log-chk.bat (with help of server_status.lst file) --> 	Processing.bat --> 	mail.vbs -->		finally a comprehensive e-mail received to the client

FOR SETTING LOGLEVEL TO 1 FOR COMPONENTS :
------------------------------------------
change evtloglvl %%=1 for Comp <COMPONENT NAME>

FOR MONITORING LEVEL SETTINGS OF COMPONENTS :
--------------------------------------------
change evtloglvl TaskConfig=4 for comp <COMPONENT NAME>
change evtloglvl ObjMgrSqlLog=4 for comp <COMPONENT NAME>
change evtloglvl SQLParseAndExecute=4 for comp <COMPONENT NAME>
change evtloglvl ObjMgrSqlCursorLog=5 for comp <COMPONENT NAME>
change evtloglvl objmgrsessionlog=5 for comp <COMPONENT NAME>
change evtloglvl EventContext=4 for comp <COMPONENT NAME>
change evtloglvl EAITransport=5 for comp <COMPONENT NAME>
change evtloglvl ObjMgrBusServiceLog=4 for comp <COMPONENT NAME>

OS LEVEL DETAILS :
------------------
We are using
Windows Server 2008 R2 Enterprise SP1
Microsoft Windows [Version 6.1.7601]
64-Bit Operating System
8 GB RAM
Siebel Enterprise Applications Siebel Server, Version 8.1.1.11 [23030] LANG_INDEPENDENT
Siebel application includes Gtwy Srvr, Siebel Srvr, Web Srvr
Windows support visual studio to run vbscript.
Windows support basic level of batch scripting
