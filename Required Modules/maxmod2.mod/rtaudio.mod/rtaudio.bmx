SuperStrict

Rem  
bbdoc: MaxMod2.RtAudio
about: This module provides cross platform audio streaming via RtAudio<p>
<h2>RtAudio License</h2>
<table><table width=100%><td>
RtAudio: a set of realtime audio i/o C++ classes<br>
Copyright (c) 2001-2007 Gary P. Scavone<p>
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:<p>
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.<p>
Any person wishing to distribute modifications to the Software is asked to send the modifications to the original developer so that they can be incorporated into the canonical version. This is, however, not a binding provision of this license.<p>
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. <p>
</td></table>
<h2>RtAudio Information</h2>
<table><table width=100%>
<tr><th width=1%>Author</th><td>Gary P. Scavone</td></tr>
<tr><th>Website</th><td>http://www.music.mcgill.ca/~gary/rtaudio/</td></tr>
</table>
End Rem
Module MaxMod2.RtAudio
ModuleInfo "MaxMod2: RtAudio interface"
ModuleInfo "Author: REDi - Cliff Harman"
ModuleInfo "CC_OPTS: -fexceptions"

?Win32
Import "-ldsound"
Import "-lole32"
?Linux
Import "-lasound"
Import "-lpthread"
?MacOS
Import "-framework CoreAudio"
Import "-framework AudioUnit"
Import "-framework AudioToolbox"
Import "-lpthread"
?

Import MaxMod2.MaxMod2
Import "*.h"
Import "rtaudiodriver.cpp"
Import "RtAudioOS.cpp"

Extern
	Function CreateAudioDriver_RtAudio:IMaxModAudioDriver()
	Function CloseAudioDriver_RtAudio(Driver:IMaxModAudioDriver)
EndExtern

Type TMaxModRtAudioDriver Extends TMaxModDriver

	Global Active:TMaxModRtAudioDriver

	Method Delete()
		CloseAudioDriver_RtAudio(_driver)
	EndMethod

	Function Create:TMaxModDriver( name$ )
		If Active Return Active
		Local t:TMaxModRtAudioDriver = New TMaxModRtAudioDriver
		t._driver=CreateAudioDriver_RtAudio()
		t._name=name
		Active = t
		Return t
	End Function
	
End Type
TMaxModRtAudioDriver.Create("MaxMod RtAudio")
TMaxModStreamDriver.AddDriver(TMaxModRtAudioDriver.Active,"MaxMod RtAudio")
