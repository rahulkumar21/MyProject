' Define email receipients
CMN_PATH = WScript.Arguments.Item(0)
FLE = WScript.Arguments.Item(1)
SBL_ENT = WScript.Arguments.Item(2)
SBL_ENVT = WScript.Arguments.Item(3)
email_From = "DL-NCSBEBE6091@ncsbe.jnj.com"
email_To =   "rkuma188@ITS.JNJ.com"


' Define file to scan, and email constants
' Const cBaseFile = CMN_PATH
Const cBaseFile = "D:\New-folder\summary.log"
Const cLogFile = "D:\New-folder\log_decrease_cmd.log"
' Constants for I/O
Const ForReading = 1
strLog = ""
strData = ""
' Reading srvrmgr log file
Set objFSO = CreateObject("Scripting.FileSystemObject")
' Make sure the file exists
If objFSO.FileExists(cLogFile) Then
	strLog = "<br><br>---------------------------------------------  Command Log  ---------------------------------------------"
	strLog = strLog & "<p style='font-size:110%; color:blue;'><i>"
	' Access the file, read full content into a string
	Set objReader = objFSO.OpenTextFile(cLogFile, ForReading)
	'Reading file containing Srvrmgr commands
	Do Until objReader.AtEndOfStream
	textLine = objReader.Readline()
		If Instr(textLine, "srvrmgr") Then
			strLog = strLog & "<br>" & textLine
		End If
	Loop
	strLog = strLog & "</i></p>"
	'strData = objReader.ReadAll
	objReader.Close
End If
' Make sure the file exists
If objFSO.FileExists(cBaseFile) Then
	'Set objFSO = CreateObject("Scripting.FileSystemObject")
	' Access the file, read full content into a string
	Set objReader = objFSO.OpenTextFile(cBaseFile, ForReading)
	strData = objReader.ReadAll
	objReader.Close
End If
   strBody = strBody & "<p style='font-size:110%;'>Hi Team,</p>"
   strBody = strBody & "<p style='font-size:110%;'>Below are the details for the siebel enterprise <b>" & SBL_ENT & "</b>.</p>"
   strBody = strBody & strData & strLog
   strBody = strBody & "<p style='font-size:110%;'>Thanks & Regards,<br>" & "Siebel Support<br>" & "Infra Team</p>"

	Dim strObject
     
	subject_Line = SBL_ENVT & " : Decrease log level at Siebel Enterprise " & SBL_ENT
	
	Set objMessage = CreateObject("CDO.Message") 
	objMessage.Subject = subject_Line
	objMessage.From = email_From
	objMessage.To = email_To
	'objMessage.TextBody = strBody
	objMessage.HTMLBody = strBody
	If objFSO.FileExists(cLogFile) Then
		objMessage.Fields.Item("urn:schemas:mailheader:X-MSMail-Priority") = "High"
		objMessage.Fields.Item("urn:schemas:mailheader:X-Priority") = 2
		objMessage.Fields.Item("urn:schemas:httpmail:importance") = 2
	End If
	objMessage.Configuration.Fields.Item _
	("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2 

	'Name or IP of Remote SMTP Server
	objMessage.Configuration.Fields.Item _
	("http://schemas.microsoft.com/cdo/configuration/smtpserver") = "SMTP.EU.JNJ.COM"

	'Server port (typically 25)
	objMessage.Configuration.Fields.Item _
	("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = 25 

	objMessage.Configuration.Fields.Update
         
	objMessage.send
