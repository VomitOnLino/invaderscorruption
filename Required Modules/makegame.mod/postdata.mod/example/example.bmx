SuperStrict

Framework makegame.postdata

'
' Init TPost width host, path and port
'
Local post:TPost = TPost.Init("makegame.de", "/server/test/server.php")

'
' add a inputfield with name and value
'
post.AddInputField("action", "äöü")

'
' send it and get a readable stream
'
Local stream:TSocketStream = post.SendData()

'
' read the output without the header
'
While Not stream.Eof()
	DebugLog ">> "+stream.ReadLine()
Wend

stream.Close()

End 