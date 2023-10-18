Graphics 640,480
Const MaxParticles:Int=100000
Local ParticleX:Float[MaxParticles]
Local ParticleY:Float[MaxParticles]
Local Counter:Int=0
Local Item:Int
Repeat

   Cls
   DrawText Counter + " particles",0,16
	
   'Check for adding a new particle - overwrite the highest new element









   Flip 0
Until KeyHit(KEY_ESCAPE) Or AppTerminate()
