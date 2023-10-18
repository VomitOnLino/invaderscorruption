#include <maxmod2.mod/maxmod2.mod/code/maxmod2.h>
#include "dumb/include/dumb.h"

class DumbPlayer : public IMaxModMusic {

	public:
	
	DUH* myduh;
	DUMBFILE* dumbfile;
	DUH_SIGRENDERER *sr;
	DUMB_IT_SIGRENDERER *srit;
	DUMB_IT_SIGDATA *sd;

	float delta;

	IMaxModStream* Stream;

	DumbPlayer();
	~DumbPlayer();
	
	// -----------------------------------------------------------------------------------
	int 	FillBuffer(void* buffer,int Length);
 	void Stop();
	int 	Seek(int position,int mode);
	int  GetLength(int mode);
	int  GetPosition(int mode);

};

