SuperStrict

Rem  
bbdoc: MaxMod2.Dumb
about: This module provides cross platform module streaming, supported formats are MOD,XM,IT and S3M<p>
<h2>DUMB License</h2>
<table><table width=100%><td>
Dynamic Universal Music Bibliotheque, Version 0.9.3<p>
Copyright (C) 2001-2005 Ben Davis, Robert J Ohannessian and Julien Cugniere<p>
This software is provided 'as-is', without any express or implied warranty.<br>
In no event shall the authors be held liable for any damages arising from the<br>
use of this software.<p>
Permission is granted to anyone to use this software for any purpose,<br>
including commercial applications, and to alter it and redistribute it<br>
freely, subject to the following restrictions:<p>
1. The origin of this software must not be misrepresented; you must not claim<br>
   that you wrote the original software. If you use this software in a<br>
   product, you are requested to acknowledge its use in the product<br>
   documentation, along with details on where to get an unmodified version of<br>
   this software, but this is not a strict requirement.<p>
   [Note that the above point asks for a link to DUMB, not just a mention.<br>
   Googling for DUMB doesn't help much! The URL is "http://dumb.sf.net/".]<p>
   [The link was originally strictly required. This was changed for two<br>
   reasons. Firstly, if many projects request an acknowledgement, the list of<br>
   acknowledgements can become quite unmanageable. Secondly, DUMB was placing<br>
   a restriction on the code using it, preventing people from using the GNU<br>
   General Public Licence which disallows any such restrictions. See<br>
   http://www.gnu.org/philosophy/bsd.html for more information on this<br>
   subject. However, if DUMB plays a significant part in your project, we do<br>
   urge you to acknowledge its use.]<p>
2. Altered source versions must be plainly marked as such, and must not be<br>
   misrepresented as being the original software.<p>
3. This notice may not be removed from or altered in any source distribution.<p>
4. If you are using the Program in someone else's bedroom on any Monday at<br>
   3:05 pm, you are not allowed to modify the Program for ten minutes. [This<br>
   clause provided by Inphernic; every licence should contain at least one<br>
   clause, the reasoning behind which is far from obvious.]<p>
5. Users who wish to use DUMB for the specific purpose of playing music are<br>
   required to feed their dog on every full moon (if deemed appropriate).<br>
   [This clause provided by Allefant, who couldn't remember what Inphernic's<br>
   clause was.]<p>
6. No clause in this licence shall prevent this software from being depended<br>
   upon by a product licensed under the GNU General Public Licence. If such a<br>
   clause is deemed to exist, Debian, then it shall be respected in spirit as<br>
   far as possible and all other clauses shall continue to apply in full<br>
   force.<p>
We regret that we cannot provide any warranty, not even the implied warranty<br>
of merchantability or fitness for a particular purpose.<p>
Some files generated or copied by automake, autoconf and friends are<br>
available in an extra download. These fall under separate licences but are<br>
all free to distribute. Please check their licences as necessary.<p>
</td></table>
<h2>DUMB Information</h2>
<table><table width=100%>
<tr><th width=1%>Author</th><td>Copyright (C) 2001-2005 Ben Davis, Robert J Ohannessian and Julien Cugniere</td></tr>
<tr><th>Website</th><td>http://dumb.sourceforge.net/index.php?page=about</td></tr>
</table>
End Rem
Module MaxMod2.Dumb
ModuleInfo "MaxMod: Dumb plugin module for MaxMod2"
ModuleInfo "Author: REDi - Cliff Harman"
ModuleInfo "CC_OPTS: -Iinclude"
ModuleInfo "CC_OPTS: -I../../include"
ModuleInfo "CC_OPTS: -DDUMB_RQ_LINEAR"

Import MaxMod2.MaxMod2

Import "dumb/src/core/atexit.c"
Import "dumb/src/core/duhlen.c"
Import "dumb/src/core/duhtag.c"
Import "dumb/src/core/dumbfile.c"
Import "dumb/src/core/loadduh.c"
Import "dumb/src/core/makeduh.c"
Import "dumb/src/core/rawsig.c"
Import "dumb/src/core/readduh.c"
Import "dumb/src/core/register.c"
Import "dumb/src/core/rendduh.c"
Import "dumb/src/core/rendsig.c"
Import "dumb/src/core/unload.c"

Import "dumb/src/helpers/clickrem.c"
Import "dumb/src/helpers/memfile.c"
Import "dumb/src/helpers/resample.c"
Import "dumb/src/helpers/sampbuf.c"
Import "dumb/src/helpers/silence.c"
Import "dumb/src/helpers/stdfile.c"

Import "dumb/src/it/itload2.c"
Import "dumb/src/it/itload.c"
Import "dumb/src/it/itmisc.c"
Import "dumb/src/it/itorder.c"
Import "dumb/src/it/itread2.c"
Import "dumb/src/it/itread.c"
Import "dumb/src/it/itrender.c"
Import "dumb/src/it/itunload.c"
Import "dumb/src/it/loadmod2.c"
Import "dumb/src/it/loadmod.c"
Import "dumb/src/it/loads3m2.c"
Import "dumb/src/it/loads3m.c"
Import "dumb/src/it/loadxm2.c"
Import "dumb/src/it/readmod2.c"
Import "dumb/src/it/readmod.c"
Import "dumb/src/it/reads3m2.c"
Import "dumb/src/it/reads3m.c"
Import "dumb/src/it/readxm2.c"
Import "dumb/src/it/readxm.c"
Import "dumb/src/it/xmeffect.c"

Import "glue.cpp"
Extern
	Function LoadMusic_Dumb:IMaxModMusic(Stream:IMaxModStream)
EndExtern

MaxModLoader.Create(TMusicDumb.Loader,"Tracker modules ~q.mod,.xm,.it,.s3m~q","mod,xm,it,s3m")
Type TMusicDumb Extends TMusic

	Function Loader:TMusic(Stream:IMaxModStream,Filename$)
		If Not Stream Return Null
		Local IMS:IMaxModMusic = LoadMusic_Dumb(Stream)
		If Not IMS Return Null
		IMS.AddRef()
		Local This:TMusicDumb = New TMusicDumb
		This.Music = IMS
		This.Stream = Stream
		Return This
	EndFunction

	Method Delete()
		If Music Music.RemoveRef()
	EndMethod

EndType
