SuperStrict

Import BRL.Blitz

Import "src/*.h"
Import "src/SFMT.c"

?MacOSPPC
Import "src/ppc/*.h"
Import "src/ppc/SFMT-alti.c"
?MacOSX86
'Import "src/x86/*.h"
'Import "src/x86/SFMT-sse2.c"
?


Import "sfmtglue.cpp"

Extern
	Function init_gen_rand(seed:Int)
	Function gen_rand32:Int()
	Function bmx_gen_rand64(v:Long Ptr)
	
	Function bmx_genrand_real1:Double()
	Function bmx_genrand_real2:Double()
	Function bmx_genrand_real3:Double()
	Function bmx_genrand_res53:Double()
	
End Extern


