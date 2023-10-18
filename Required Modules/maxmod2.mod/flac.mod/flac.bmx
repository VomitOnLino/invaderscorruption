SuperStrict

Rem  
bbdoc: MaxMod2.Flac
about: This module provides cross platform flac streaming via libFLAC<p>

<h2>libFLAC License</h2>
<table><table width=100%><td>
libFLAC - Free Lossless Audio Codec library<br>
Copyright (C) 2000,2001,2002,2003,2004,2005,2006,2007  Josh Coalson<p>

Redistribution and use in source and binary forms, with or without<br>
modification, are permitted provided that the following conditions<br>
are met:<p>

- Redistributions of source code must retain the above copyright<br>
  notice, this list of conditions and the following disclaimer.<p>

- Redistributions in binary form must reproduce the above copyright<br>
  notice, this list of conditions and the following disclaimer in the<br>
  documentation and/or other materials provided with the distribution.<p>

- Neither the name of the Xiph.org Foundation nor the names of its<br>
  contributors may be used to endorse or promote products derived from<br>
  this software without specific prior written permission.<p>

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS<br>
``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT<br>
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR<br>
A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE FOUNDATION OR<br>
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,<br>
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,<br>
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR<br>
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF<br>
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING<br>
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS<br>
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.<br>
</td></table>
End Rem
Module MaxMod2.Flac
ModuleInfo "MaxMod: LibFlac 0.1"
ModuleInfo "Author: REDi - Cliff Harman"
ModuleInfo "License: MIT"
ModuleInfo "CC_OPTS: -fexceptions"

Import MaxMod2.MaxMod2
Import "libFLAC/*.h"
Import "libFLAC/bitmath.c"
Import "libFLAC/bitreader.c"
Import "libFLAC/bitwriter.c"
Import "libFLAC/cpu.c"
Import "libFLAC/crc.c"
Import "libFLAC/fixed.c"
Import "libFLAC/float.c"
Import "libFLAC/format.c"
Import "libFLAC/lpc.c"
Import "libFLAC/md5.c"
Import "libFLAC/memory.c"
Import "libFLAC/metadata_iterators.c"
Import "libFLAC/metadata_object.c"
Import "libFLAC/stream_decoder.c"
Import "libFLAC/stream_encoder.c"
Import "libFLAC/stream_encoder_framing.c"
Import "libFLAC/window.c"
'Import "libflac/ogg_decoder_aspect.c"
'Import "libflac/ogg_encoder_aspect.c"
'Import "libflac/ogg_helper.c"
'Import "libflac/ogg_mapping.c"

Import "*.h"
Import "flac.cpp"

Extern
	Function LoadMusic_Flac:IMaxModMusic(Stream:IMaxModStream)
EndExtern

MaxModLoader.Create(TMusicFlac.Loader,"Free lossless audio codec ~q.flac~q","flac")
Type TMusicFlac Extends TMusic

	Function Loader:TMusic(Stream:IMaxModStream,Filename$)
		If Not Stream Return Null
		Local IMS:IMaxModMusic = LoadMusic_Flac(Stream)
		If Not IMS Return Null
		IMS.AddRef()
		Local This:TMusicFlac = New TMusicFlac
		This.Music = IMS
		This.Stream = Stream
		Return This
	EndFunction

	Method Delete()
		If Music Music.RemoveRef()
	EndMethod

EndType
