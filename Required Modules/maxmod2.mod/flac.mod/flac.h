#ifndef __MAXMOD_FLAC_H__
#define __MAXMOD_FLAC_H__

#include <maxmod2.mod/maxmod2.mod/code/maxmod2.h>
#include "libFLAC/FLAC/all.h"
using namespace std;

class FlacPlayer : public IMaxModMusic {

	public:

	IMaxModStream* 		CStream;

	FLAC__StreamDecoder *decoder;
	FLAC__StreamDecoderInitStatus init_status;
	
	signed short* OutputBuffer;
	int           OutputLength,
	              OutputWritePos,
	              OutputReadPos;
	
	// -----------------------------------------------------------------------------------
  
	FlacPlayer();
	virtual ~FlacPlayer();

	// -----------------------------------------------------------------------------------

	int FillBuffer(void* buffer,int Length);
	int Seek(int position,int mode);
	void DecodeChunk();
	
};

void FlacFreeFunction(IMaxModMusic* music);

#endif // __MAXMOD_FLAC_H__
