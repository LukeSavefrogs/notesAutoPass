; From: https://www.autoitscript.com/forum/topic/143167-getopt-udf-to-parse-the-command-line/
#include <GetOpt.au3>

#include <MsgBoxConstants.au3>
#include <TrayConstants.au3>
#include <StringConstants.au3>

; To execute this code you have to:
;		- Have AutoIt (https://www.autoitscript.com/site/autoit/):
; 			- To execute: '/cygdrive/c/Program Files (x86)/AutoIt3/AutoIt3.exe' notesOpen.au3 
;			- To compile: use 'Aut2Exe'
;		- Have in the same folder (if not compiled) the GetOpt.au3 UDF needed to parse the parameters

; Program Entry Point. I used a C-like structure
Func Main()
	Global $password = "";
	Global $directoryNotes = "C:\Program Files (x86)\IBM\Notes\notes.exe"
	Global $winIdentifierName = "IBM Notes"
	Global $waitForUserInput = False 
	Global $debugMode = False 
	Global $insertPasswordAfter = 0 
	
	Global $sUserName = ""
	Global $sLocation = ""
	
	
	parseCmdParams()
	
	
	; Check if Notes is already open (sometimes it tries to open even with another instance active,
	;	forcing the user to close the processes using the Task Manager)
	If WinExists($winIdentifierName, "") And Number($insertPasswordAfter) <= 0 Then
		MsgBox($MB_ICONINFORMATION + $MB_SYSTEMMODAL, 'Notes process was found', _ 
			'Cannot start new instance of Lotus Notes: Notes is already active.' & @CRLF & @CRLF & 'Check your processes' _ 
		)

		Exit 1
	ElseIf Not WinExists($winIdentifierName, "") And Number($insertPasswordAfter) > 0 Then
		MsgBox($MB_ICONERROR + $MB_SYSTEMMODAL, 'Insert Password delayed mode ERROR', _ 
			'Cannot auto-type if Notes is not open' & @CRLF & @CRLF & '' _ 
		)

		Exit 1
	EndIf
	
	; Se non trova l'eseguibile di Notes sotto il path nella variabile $directoryNotes mostra un errore a video ed esce
	If Not FileExists($directoryNotes) Or Not StringInStr($directoryNotes, "notes.exe", 2) Then
		MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR + $MB_SETFOREGROUND, "ERROR", _
			'Notes executable not found under path: ' & $directoryNotes _
		)
		
		Exit 2	
	EndIf
	
	
	openNotes($password)
	Exit 0
EndFunc

; -------------------------------------------------------------------------------------------------------------------------------------


#CS
	Parses parameters by using the GetOpt.au3 UDF

	For parameters containing a space: '"Program Files"'

	
	Parameters available:
		-p/--password								Specify password
		-d/--notes-directory		OPTIONAL		Set Notes executable path
		-u/--user-name				OPTIONAL		Set User ID
		-l/--location				OPTIONAL		Set Location
		-w/--wait-input				OPTIONAL		Don't press ENTER after the password
		-x/--debug					OPTIONAL		Debug mode, Show MsgBox with data useful for debugging
		-h/--help					OPTIONAL		Show Help MsgBox
		-t/--timeout				OPTIONAL		Types the password after the defined timeout (in ms)
#CE
Func parseCmdParams ()
	Local $sOpt, $sSubOpt, $sOper, $sMsg, $sHelpText
    Local $aOpts[8][3] = [ _
        ['-p', '--password', $GETOPT_REQUIRED_ARGUMENT], _
        ['-d', '--directory', $GETOPT_REQUIRED_ARGUMENT], _
        ['-h', '--help', True], _
        ['-u', '--user-name', $GETOPT_REQUIRED_ARGUMENT], _
        ['-l', '--location', $GETOPT_REQUIRED_ARGUMENT], _
        ['-w', '--wait-input', True], _
        ['-x', '--debug', True], _
        ['-t', '--timeout', True] _
    ]
	
	$sHelpText='Usage script for automatic Login for Lotus Notes:' & @CRLF & @CRLF & _
				'- ' & @Scriptname & ' -p=your_password' & @CRLF & @CRLF & _ 
				'OPPURE' & @CRLF & @CRLF & _ 
				'- ' & @Scriptname & ' --password=your_password' & @CRLF & @CRLF & @CRLF & @CRLF & _ 
				'Other:' & @CRLF & @CRLF & _ 
				'-d/--directory - Specify the directory where to search the executable' & @CRLF & _ 
				'-u/--username - Specify the USERNAME to use' & @CRLF & _ 
				'-l/--location - Specify the Location' & @CRLF & _ 
				'-t/--timeout - Sets a timeout after which the password will be sent' & @CRLF & _ 
				'-w/--wait-input - Only insert password, does not click on the "Ok" button' & @CRLF & _ 
				'-x/--debug - Enables debug mode' & @CRLF & _ 
				'-h/--help - Shows this help message' & @CRLF & @CRLF & @CRLF & @CRLF & _
				'More info on:' & @CRLF & 'https://github.com/LukeSavefrogs/notesAutoPass'
				
				
	_GetOpt_Set($aOpts)
	
    If 0 < $GetOpt_Opts[0] Then
        While 1
            $sOpt = _GetOpt('p:d:xu:l:wt:h')
			
            If Not $sOpt Then ExitLoop
			
			
			If StringStripWS ($GetOpt_Arg, $STR_STRIPALL) == "" Then 
				MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR + $MB_SETFOREGROUND, "ERROR", _ 
					'Value needed for parameter: ' & $GetOpt_Opt & @CRLF)
				
				Exit 1
			EndIf

            Switch $sOpt
                Case '?' ; Unknown option
					MsgBox($MB_ICONWARNING + $MB_SYSTEMMODAL, 'Unknown Option', 'Unknown option: ' & $GetOpt_Ind & ': ' & $GetOpt_Opt & _ 
						' with value "' & $GetOpt_Arg & '" (' & VarGetType($GetOpt_Arg) & ').' & @CRLF)
					
					Exit 1
					
                Case ':' ; Value missing 
					MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR + $MB_SETFOREGROUND, "ERROR", _ 
						'Value missing for parameter: ' & $GetOpt_Opt & @CRLF)
					
					Exit 1
					
                Case 'p' ; Custom parameter (parameter_name = $GetOpt_Opt , value = $GetOpt_Arg)
					$password = $GetOpt_Arg
					
                Case 'u' ; Custom parameter (parameter_name = $GetOpt_Opt , value = $GetOpt_Arg)
					$sUserName = $GetOpt_Arg
					
                Case 'l' ; Custom parameter (parameter_name = $GetOpt_Opt , value = $GetOpt_Arg)
					$sLocation = $GetOpt_Arg
				
				Case 'w' ; Custom parameter (parameter_name = $GetOpt_Opt , value = $GetOpt_Arg)
					$waitForUserInput = True
					
				Case 'x' ; Custom parameter (parameter_name = $GetOpt_Opt , value = $GetOpt_Arg)
					; Activate Debug mode

					$debugMode = True
					TrayTip ( "Debug mode", "Debug mode active", 0, $TIP_ICONASTERISK )
					
                Case 'd' ; Custom parameter (parameter_name = $GetOpt_Opt , value = $GetOpt_Arg)
					$directoryNotes = $GetOpt_Arg
					
                Case 't' ; Custom parameter (parameter_name = $GetOpt_Opt , value = $GetOpt_Arg)
					$insertPasswordAfter = $GetOpt_Arg
					
                Case 'h' ; Help section
                    MsgBox($MB_ICONQUESTION + $MB_SYSTEMMODAL, 'Help for Notes autoPass', $sHelpText)
                    
					Exit 0
					
            EndSwitch
        WEnd
    Else
        MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR + $MB_SETFOREGROUND, "ERROR", 'Password missing!' & @CRLF & _ 
				$sHelpText )
		Exit
    EndIf
EndFunc


#CS 
	Main function.
		Opens Notes and, if provided, changes Location/UserName
		
		Notes sometimes reloads the authentication form UI, making the Notes Handler change. 
		This is why i get the handler after each change.
#CE
Func openNotes($password)
	If Number($insertPasswordAfter) > 0 Then
				#CS 
			Password Input 
		#CE
		$sanitizedPassword = sanitizeSendString($password) 		; Escapes AutoIt special characters from password
		
		If $debugMode == True Then 
			MsgBox($MB_ICONWARNING + $MB_SYSTEMMODAL, 'Debug mode', _ 
				"WRITE PASSWORD AFTER " & $insertPasswordAfter & " ms" & @CRLF & @CRLF & _ 
				"Password ricevuta: " & $password & @CRLF & @CRLF & _ 
				"Password inserita: " & $sanitizedPassword)
		EndIf
		
		Sleep ($insertPasswordAfter)

		; Sends password to window referenced by $hNotes
		Send($sanitizedPassword)
		Return
	EndIf
	
	
	Local $sButtonUserNameIdentifier = "[CLASS:ComboBox; INSTANCE:1]" ; User Name
	Local $sButtonLocationIdentifier = "[CLASS:ComboBox; INSTANCE:2]" ; Location 
	

	Run ($directoryNotes)			; Open Notes 
	WinWait($winIdentifierName)		; Wait for Notes to be open

	
	If Not WinActive($winIdentifierName) Then WinActivate($winIdentifierName, "") 		; Once open, put it in foreground
	WinWaitActive($winIdentifierName,"") 		; Wait until Notes is in foreground


	

	If $debugMode == True Then 
		MsgBox($MB_ICONWARNING + $MB_SYSTEMMODAL, 'Debug mode', _ 
			"Username: " & $sUserName & @CRLF & @CRLF & _ 
			"Location: " & $sLocation)
	EndIf	
	
	
	#CS 
		If provided, change the User Name
	#CE
	If Not StringStripWS($sUserName, $STR_STRIPLEADING + $STR_STRIPTRAILING) = "" Then
		$hNotes = WinGetHandle($winIdentifierName)
		$hUserName = ControlGetHandle ($hNotes, "", $sButtonUserNameIdentifier)
		$sUserNameCurrentValue = ControlCommand($winIdentifierName, "", $hUserName, "GetCurrentSelection") ; or ControlGetText($hNotes, "", $hUserName)
		
		If Not StringCompare($sUserNameCurrentValue, $sUserName) = 0 Then 
			ControlCommand($winIdentifierName, "", $hUserName, "ShowDropDown")
			ControlCommand($hNotes, "", $hUserName, "SelectString", $sUserName)
			ControlCommand($winIdentifierName, "", $hUserName, "HideDropDown")
		EndIf
		
		WinWait($winIdentifierName)		; Wait for Notes changing the User profile
	EndIf



	
	#CS 
		If provided, change the Location
	#CE
	If Not StringStripWS($sLocation, $STR_STRIPLEADING + $STR_STRIPTRAILING) = "" Then
		$hNotes = WinGetHandle($winIdentifierName)
		$hLocation = ControlGetHandle ($hNotes, "", $sButtonLocationIdentifier)
		$sLocationCurrentValue = ControlGetText($hNotes, "", $hLocation)


		If Not StringCompare($sLocationCurrentValue, $sLocation) = 0 Then 
			ControlCommand($winIdentifierName, "", $hLocation, "ShowDropDown")
			ControlCommand($hNotes, "", $hLocation, "SelectString", $sLocation)
			ControlCommand($winIdentifierName, "", $hLocation, "HideDropDown")
		EndIf
		
		WinWait($winIdentifierName)		; Wait for Notes changing the Location profile
	EndIf
	
	
	
	#CS 
		Password Input 
	#CE
	$hNotes = WinGetHandle($winIdentifierName) 		
	$sanitizedPassword = sanitizeSendString($password) 		; Escapes AutoIt special characters from password
	
	If $debugMode == True Then 
		MsgBox($MB_ICONWARNING + $MB_SYSTEMMODAL, 'Debug mode', _ 
			"Password received: " & $password & @CRLF & @CRLF & _ 
			"Password sent: " & $sanitizedPassword)
	EndIf
	
	
	; Sends password to window referenced by $hNotes
	ControlSend($hNotes, "", "", $sanitizedPassword)		
	
	
	If $waitForUserInput == False Then ControlSend($hNotes, "", "", "{ENTER}")		
EndFunc


#CS
	Escapes special characters from a string that has to be passed to the Send* function
#CE
Func sanitizeSendString($input_string)
	Local $result = ""
	$result = StringReplace($input_string, "!", "{!}")
	$result = StringReplace($result, "=", "{=}")
	$result = StringReplace($result, "^", "{^}")
	$result = StringReplace($result, "#", "{#}")
	
	Return $result
EndFunc




Main()
