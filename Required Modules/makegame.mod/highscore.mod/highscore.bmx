SuperStrict

Rem
bbdoc:Online-Highscore Module
End Rem
Module makegame.highscore

ModuleInfo "Version: 0.30"
ModuleInfo "Author: Jens [bruZard] Henschel"
ModuleInfo "License: LGPL"
ModuleInfo "Modserver:makegame"

ModuleInfo "History: 0.30 Release"
ModuleInfo "History: HTTP POST Modul neu implementiert."
ModuleInfo "History: 0.20 Release"
ModuleInfo "History: HTTP Post zum senden von Scores eingeführt."
ModuleInfo "History: 0.10 Release"
ModuleInfo "History: erstes Release"

'Import brl.retro
'Import brl.FileSystem
'Import brl.StandardIO
Import makegame.postdata
Import makegame.StringOps

Rem
	====================================================================
	Sichern der Highscores
	====================================================================
endrem
Type TScores
	Global list:TList
	
	Field score_id:String			' SQL ID
	Field user_name:String		' Benutzername
	Field user_score:Int			' Highscore
	Field ScoreSeed:String
	Field ScoreDifficulty:String
	Field ScoreTime:Int
	
	
	Rem
		-------------------------------------------------------------------
		Der Liste eine Score hinzufügen
		-------------------------------------------------------------------
	endrem
	Function AddScore:TScores(id:String, user_name:String, user_score:String,ScoreSeed:String, ScoreDifficulty:String, Scoretime:Int)
		Local score:TScores = New TScores
		If score.list = Null Then score.list = New TList
		score.list.AddLast(score)
		
		score.score_id		= id
		score.user_name		= user_name
		score.user_score	= Int(user_score)
		score.ScoreSeed		= ScoreSeed
		score.ScoreDifficulty	= ScoreDifficulty
		score.ScoreTime		= ScoreTime
		
		Return score
		
		
		
	End Function
	
	Rem
		-------------------------------------------------------------------
		Eine Score aus der Liste entfernen
		-------------------------------------------------------------------
	endrem
	Method KillScore()
		Self.list.remove(Self)
		'GCCollect()
	End Method
	
	Method KillAll()
		If Not list Return
		
		For Local Score:TScores = EachIn List
			KillScore()
		Next
	End Method
		
End Type


Rem
	bbdoc: Highscore Type
	about: Klasse zum senden, empfangen und löschen von Online-Highscores
endrem
Type TOnlineHighScore
	Const ACTION_GETSCORE:Byte			= 1			' Highscores vom Server lesen
	Const ACTION_SETSCORE:Byte			= 2			' Highscore an den Server schicken
	'Const ACTION_KILLSCORE:Byte			= 3			' Highscore l schen
	'Const ACTION_RESETTABLE:Byte		= 4			' komplette Highscore-Tabelle auf dem Server zur cksetzen
	Const ACTION_COUNTSCORES:Byte		= 5			' Anzahl der Servereinträge lesen
	Const ACTION_GETRANK:Byte		= 6
	Const ACTION_GETMONTHLY:Byte	= 7
	Const ACTION_GETMONTH:Byte		= 8
	
	Field scores:TScores										' Highscore-Liste
	Field current_version:String						' Spielversion
	Field url:String												' Host des PHP Script
	Field php_script:String									' PHP Script
	Field port:Int
	Field TimeStamp:Int													' Kommunikations-Port (Default = 80)

	
	Rem
		bbdoc: Type initialisieren
		returns: Ein Objekt vom Typ #THighScore
		about: Initialisiert die Highscore mit Startwerten
	endrem
	Function InitHighScore:TOnlineHighScore(current_version:String, url:String = "", php_script:String = "", port:Int = 80) 
		
		DebugLog current_version
		
		If Left(url, 7) = "http://" Then url = Right(url, url.Length-7)
		If Right(url, 1) = "/" Then url = Left(url, url.Length-1)
		If Left(php_script, 1) <> "/" Then php_script = "/"+php_script
		If port <= 0 Then port = 80
		
		Local highscore:TOnlineHighScore	= New TOnlineHighScore
		highscore.current_version		= current_version
		highscore.url								= url
		highscore.php_script				= php_script
		highscore.port							= port
		
		
		Return highscore
	End Function
	
	
	
	Rem
		bbdoc: Highscores vom Server lesen
		returns: -
		about: Liest die aktuelle Highscore Liste vom Server und legt diese in THighScore.scores:TScores ab.<br/><br/>"begin" definiert den ersten zu lesenden Eintrag, "limit" die Anzahl der zu lesenden Einträge.
	endrem

	
	Method GetScores:Byte(begin:Int = 0, limit:Int = 0)
		'Self.Unload()
		
		Local post:TPost = TPost.Init(Self.url, Self.php_script, Self.port,"Invaders Corruption")
		post.AddInputField("action", String(Self.ACTION_GETSCORE))
		post.AddInputField("v", Self.current_version)
		post.AddInputField("f", String(begin))
		post.AddInputField("l", String(limit))
		
		'Local stream:TSocketStream = post.SendData()
	
		Local stream:TTCPStream = post.SendData()
		If stream
			While Not stream.Eof()
				Local score_id:String	= Trim(stream.ReadLine())
				Local user_name:String	= Trim(stream.ReadLine())
				Local user_score:String	= Trim(stream.ReadLine())
				Local scoreseed:String		= Trim(stream.ReadLine())
				Local scoredifficulty:String= Trim(stream.ReadLine())
				Local scoretime:String		= Trim(stream.ReadLine())
				Self.scores				= TScores.AddScore(score_id, user_name, user_score, scoreseed,scoredifficulty,Int(scoretime))
			Wend
			
			stream.Close()
			post = Null
			TimeStamp=MilliSecs()
			Return True
		Else
			Return False
		End If

	End Method
	
	Method GetMonthly:Byte(begin:Int = 0, limit:Int = 0)
		'Self.Unload()
		
		Local post:TPost = TPost.Init(Self.url, Self.php_script, Self.port,"Invaders Corruption")
		post.AddInputField("action", String(Self.ACTION_GETMONTHLY))
		post.AddInputField("v", Self.current_version)
		post.AddInputField("f", String(begin))
		post.AddInputField("l", String(limit))
		
		'Local stream:TSocketStream = post.SendData()
	
		Local stream:TTCPStream = post.SendData()
		If stream
			While Not stream.Eof()
				Local score_id:String	= Trim(stream.ReadLine())
				Local user_name:String	= Trim(stream.ReadLine())
				Local user_score:String	= Trim(stream.ReadLine())
				'Local Date:String			= Trim(stream.ReadLine())
				Local scoreseed:String		= Trim(stream.ReadLine())
				Local scoredifficulty:String= Trim(stream.ReadLine())
				Local scoretime:String		= Trim(stream.ReadLine())
				Self.scores				= TScores.AddScore(score_id, user_name, user_score,scoreseed,scoredifficulty,Int(scoretime))
			Wend
			
			stream.Close()
			post = Null
			TimeStamp=MilliSecs()
			Return True
		Else
			Return False
		End If
	End Method
	
	Method GetMonth:Int()
		'Self.Unload()
		Local server_month:String
		Local post:TPost = TPost.Init(Self.url, Self.php_script, Self.port,"Invaders Corruption")
		post.AddInputField("action", String(Self.ACTION_GETMONTH))	
		'Local stream:TSocketStream = post.SendData()
	
		Local stream:TTCPStream = post.SendData()
		If stream
			While Not stream.Eof()
				server_month	= Trim(stream.ReadLine())
				DebugLog server_month
			Wend
			stream.Close()
			post = Null
			TimeStamp=MilliSecs()
			Return Int(server_month)
		Else
			Return False
		End If
		
		
	End Method
	Rem
		bbdoc: Neue Score an den Server schicken
		returns: Im Erfolgsfall True, ansonsten False
		about: Schickt die Daten "user_name" und "score" an den Server
	EndRem
	Method SetScore:Byte(user_name:String, score:String, uniqueid:String, scoreseed:String,PlayTime:String,CheckSum:String)
		Local result:Byte = False
		Local post:TPost = TPost.Init(Self.url, Self.php_script, Self.port,"Invaders Corruption")
		post.AddInputField("action", String(Self.ACTION_SETSCORE))
		post.AddInputField("user", user_name)
		post.AddInputField("score", score)
		post.AddInputField("uuid",uniqueid)
		post.AddInputField("seed",scoreseed)
		post.AddInputField("playtime",PlayTime)
		post.AddInputField("avatar",CheckSum)
		post.AddInputField("v", Self.current_version)

		'Local stream:TSocketStream = post.SendData()
		Local stream:TTCPStream = post.SendData()
		
		If stream
			While Not stream.Eof()
				Local Bum:String
				Bum=Trim(Lower(stream.ReadLine()))
				If Left(Bum, 7) = "success" Then result = True
			Wend
			
			stream.Close()
		End If
		
		post = Null
		
		Return result
	End Method
	
	
	
	Rem
		bbdoc: Eine Score löschen
		returns: Im Erfolgsfall True, ansonsten False
		about: Entfernt eine Score aus der Datenbank
	EndRem
	Rem
	'RESERVED FOR ADMIN BUILD
	Method RemoveScore:Byte(score:TScores)
		Local result:Byte = False
		
		Local post:TPost = TPost.Init(Self.url, Self.php_script, Self.port)
		post.AddInputField("action", String(Self.ACTION_KILLSCORE))
		post.AddInputField("v", Self.current_version)
		post.AddInputField("sc", String(score.score_id))
		
		'Local stream:TSocketStream = post.SendData()
		Local stream:TTCPStream = post.SendData()
		
		If stream
			While Not stream.Eof()
				If Left(Trim(Lower(stream.ReadLine())), 7) = "success" Then result = True
			Wend
			
			stream.Close()
		End If
		
		post = Null
		
		Return result
	End Method
	End Rem
	
	
	Rem
		bbdoc: Highscore-Tabelle zurücksetzen
		returns: Im Erfolgsfall True, ansonsten False
		about: Löscht die gesamte Highscore-Tabelle, unabhängig von der definierten Version.
	EndRem
		Rem
	'RESERVED FOR ADMIN BUILD
	Method ResetTable:Byte()
		Local result:Byte = False
		
		Local post:TPost = TPost.Init(Self.url, Self.php_script, Self.port)
		post.AddInputField("action", String(Self.ACTION_RESETTABLE))
		
		'Local stream:TSocketStream = post.SendData()
		Local stream:TTCPStream = post.SendData()
		
		If stream
			While Not stream.Eof()
				If Left(Trim(Lower(stream.ReadLine())), 7) = "success" Then result = True
			Wend
			
			stream.Close()
		EndIf
		post = Null
		Return result
	End Method
	End Rem
	
	Rem
		bbdoc: Scores zählen
		returns: Anzahl der Einträge
		about: Z hlt die auf dem Server gesicherte Anzahl an Highscore-Eintr gen
	EndRem
	Method CountScores:Int()
		Local result:Int				= 0
		Local post:TPost = TPost.Init(Self.url, Self.php_script, Self.port,"Invaders Corruption")
		
		post.AddInputField("action", String(Self.ACTION_COUNTSCORES))
		post.AddInputField("v", Self.current_version)
		
		'Local stream:TSocketStream = post.SendData()
		Local stream:TTCPStream = post.SendData()
				
		If stream
			While Not stream.Eof()
				Local res:Int = Int(Trim(stream.ReadLine()))
				If res > 0
					result = res
					Exit
				EndIf
			Wend
			
			stream.Close()
		Else
			Result=0
		EndIf
		post = Null
		Return result
	End Method
	
	
	Method RankScore:Int(score:String)
		Local result:Int = -1
		Local post:TPost = TPost.Init(Self.url, Self.php_script, Self.port,"Invaders Corruption")
		post.AddInputField("action", String(Self.ACTION_GETRANK))
		'post.AddInputField("user", user_name)
		post.AddInputField("score", score)
		post.AddInputField("v", Self.current_version)

		'Local stream:TSocketStream = post.SendData()
		Local stream:TTCPStream = post.SendData()
		
		If stream
			result=Int(Trim(stream.ReadLine()))
			result:+1
			stream.Close()
		Else 
			result=-1
		End If
		
		post = Null
		
		Return result
	End Method
	Rem
		-------------------------------------------------------------------
		Liste l schen
		-------------------------------------------------------------------
	endrem
	Method Unload()
		If Self.scores.list <> Null
			For Local score:TScores = EachIn Self.scores.list
				score.KillScore()
			Next
		EndIf
		Self.Scores.List = Null
		Self.scores = Null
	End Method

	
End Type
