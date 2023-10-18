SuperStrict

Rem
bbdoc: Modul zum senden von Daten per POST
End Rem
Module makegame.postdata

ModuleInfo "Version: 0.10"
ModuleInfo "Author: Jens [bruZard] Henschel"
ModuleInfo "License: LGPL"
ModuleInfo "Modserver:makegame"

ModuleInfo "History: 0.10 Release"
ModuleInfo "History: erstes Release"

Import brl.linkedlist
'Import brl.socketstream
'Import brl.httpstream
Import vertex.bnetex
Import makegame.StringOps


Type TInputFields
	Global _list:TList
	Field input_name:String
	Field input_value:String
	
	Function AddInputField:TInputFields(input_name:String, input_value:String)
		Local inp:TInputFields = New TInputFields
		If inp._list = Null Then inp._list = New TList
		inp._list.AddLast(inp)
		
		inp.input_name	= input_name
		inp.input_value	= input_value
		
		Return inp
	End Function
	
	Method GetContentSize:Int()
		Return Self.input_name.Length + Self.input_value.Length
	End Method
	
	Method FreeField()
		Self._list.remove(Self)
	End Method
End Type



Type TPost
	Field input_fields:TInputFields
	Field host:String
	Field path:String
	Field port:Int
	Field host_ip:Int
	Field host_ip_dotted:String
	Field protocol:String
	Field user_agent:String
	
	Function Init:TPost(host:String, path:String, port:Int = 80,useragent:String)
		Local post:TPost = New TPost
		post.host						= host
		post.path						= path
		post.port						= port
		post.host_ip				= TNetwork.GetHostIP(host)
		post.host_ip_dotted	= TNetwork.StringIP(post.host_ip)
		post.protocol				= "1.0"
		post.user_agent			= useragent
		
		Return post
	End Function
	
	
	
	Rem
		-------------------------------------------------------------------
		Einen Wert hinzufügen
		-------------------------------------------------------------------
	endrem
	Method AddInputField(inputfield_name:String, inputfield_value:String)
		Self.input_fields = TInputFields.AddInputField(inputfield_name, inputfield_value)
	End Method
	
	
	Rem
		-------------------------------------------------------------------
		Daten senden
		-------------------------------------------------------------------
	endrem
	Method SendData:TTCPStream()
		Local data_string:String = ""
		
		'
		' Kombinierten Daten-String erstellen
		'
		If Self.input_fields <> Null
			For input_fields = EachIn input_fields._list
				data_string:+ input_fields.input_name+"="+input_fields.input_value+"&"
			Next
			
			'
			' TCP Socket erzeugen, mit Host verbinden und Stream aufbauen
			'
			Local Client:TTCPStream = New TTCPStream
			'Local sock:TSocket = CreateTCPSocket()
			If Not Client.Init() Then
			'If Client = Null
				'
				' Es konnte kein TCP Socket erstellt werden
				'
				DebugLog "Es konnte kein TCP Socket erstellt werden."

			Else
				Client.SetTimeouts(5000, 5000)
				If Not Client.SetLocalPort() Then DebugLog "Can't set local port"
				
				Client.SetRemoteIP(Self.Host_IP)
				Client.SetRemotePort(Self.Port)
				
				If Not Client.Connect() Then
				
				'If Not sock.Connect(Self.host_ip, Self.port)
					'
					' Es konnte keine Verbindung zum Host hergestellt werden
					'
					DebugLog "Es konnte keine Verbindung zum Host hergestellt werden."
					
				Else
					'Local stream:TSocketStream = CreateSocketStream(sock, True)
					'If Not Client.Connect() Then
					'If stream = Null
						'
						' Es konnte kein Stream erzeugt werden
						'
						'DebugLog "Es konnte kein Stream zum Host aufgebaut werden."
					'Else
						'
						' Daten in den Stream schreiben
						'
						'stream.WriteLine("POST "+Self.path+" HTTP/"+Self.protocol)
						'stream.WriteLine("Accept: */*")
						'stream.WriteLine("Host: "+Self.host)
						'stream.WriteLine("User-Agent: "+Self.user_agent)
						'stream.WriteLine("Content-Type: application/x-www-form-urlencoded")
						'stream.WriteLine("Content-Length: "+String(data_string.Length))
						'stream.WriteLine("Pragma: no-cache")
						'stream.WriteLine("Connection: keep-alive")
						'stream.WriteLine("")
						'stream.WriteLine(data_string)
						'stream.WriteLine("")
					
						Client.WriteLine("POST "+Self.path+" HTTP/"+Self.protocol)
						Client.WriteLine("Accept: */*")
						Client.WriteLine("Host: "+Self.host)
						Client.WriteLine("User-Agent: "+Self.user_agent)
						Client.WriteLine("Content-Type: application/x-www-form-urlencoded")
						Client.WriteLine("Content-Length: "+String(data_string.Length))
						Client.WriteLine("Pragma: no-cache")
						Client.WriteLine("Connection: keep-alive")
						Client.WriteLine("")
						Client.WriteLine(data_string)
						Client.WriteLine("")
					
						
						While Client.SendMsg() ; Wend
						'stream.flush()
						
						Local Start:Int = MilliSecs()
						Repeat
							Local Result:Int
						
							If MilliSecs() - Start > 5000
								DebugLog "Socket Timeout Error"
								Exit
							End If
						
							Result = Client.RecvAvail()
							
							If Result = -1 Then
								DebugLog "Socket Error"
							ElseIf Result > 0 Then
								Exit
							EndIf
						Forever
						
						While Client.RecvMsg() ; Wend
						
						Local in:String = Client.ReadLine()
						While in <> ""
							DebugLog "HEAD:"+in
							If Instr(Upper(in),"404 NOT FOUND",1) Then
								DebugLog "ERROR 404."
								Return Null
							End If
							If Instr(in,"503",1) And Instr(Upper(in),"SERVER ERROR") Then
								DebugLog "ERROR 503."
								Return Null
							End If
							in = Client.ReadLine()
						Wend
						
						'Local in:String = stream.ReadLine()
						'While in <> ""
						'	DebugLog "HEAD: "+in
						'	in = stream.ReadLine()
						'Wend
						
						Return client
						'Return stream
					EndIf
				EndIf
			'End If
		Else
			'
			' Es gibt keine Daten zu senden
			'
			DebugLog "Es wurden keine Daten zum senden definiert."
		EndIf
	End Method
End Type 