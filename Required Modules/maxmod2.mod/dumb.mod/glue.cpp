#include "glue.h"

void DumbFreeFunction(IMaxModMusic* music){
	delete static_cast<DumbPlayer*>(music);
}


int loop_callback(void *data) {
	DumbPlayer* dp = static_cast<DumbPlayer*>(data);
	dp->POS=0;
	if(dp->LOOP==false) {dp->Seek(0,MM_SAMPLES); dp->STATUS=0; return 1;}
	return 0;
}


// -----------------------------------------------------------------------------------


DumbPlayer::DumbPlayer(){
	Stream         = NULL;
	FreeFunction	= DumbFreeFunction;
	POS			= 0;
	dumb_register_stdfiles();
}

DumbPlayer::~DumbPlayer(){
	mmPrint("~DumbPlayer");
	Stop();
	if (Stream!=NULL) {
		Stream->Close();
		delete Stream;
	}
	duh_end_sigrenderer(sr);
	unload_duh(myduh);
	dumbfile_close(dumbfile);
}

// -----------------------------------------------------------------------------------

int DumbPlayer::FillBuffer(void* buffer,int Length) {

	if (Length==0 or STATUS==0) {return 0;}
	short* buf = (short*)buffer;
	int got = duh_render(sr, 16, 0, 1.0f, delta, Length/4, buffer)*4;
	POS+=got;
	return got;

}
 
// -----------------------------------------------------------------------------------

void DumbPlayer::Stop() {
	POS=0;
}

// -----------------------------------------------------------------------------------

int DumbPlayer::GetLength(int mode) {
	switch(mode) {
		case MM_SEQUENCE:	return dumb_it_sd_get_n_orders(sd);
		case MM_BYTES:		return SIZE;
		case MM_SAMPLES:	return SIZE/((BITS/8)*CHANNELS);
		case MM_MILLISECS:	return ((double)SIZE/((BITS/8)*CHANNELS))/(SAMPLERATE/1000.0);
	}
}

// -----------------------------------------------------------------------------------
 
int DumbPlayer::GetPosition(int mode)	{
	switch(mode) {
		case MM_BYTES:		return POS;
		case MM_SAMPLES:	return POS/((BITS/8)*CHANNELS);
		case MM_MILLISECS:	return ((double)POS/((BITS/8)*CHANNELS))/(SAMPLERATE/1000.0);
		case MM_SEQUENCE:	return dumb_it_sr_get_current_order(srit);
		case MM_LINE:		return dumb_it_sr_get_current_row(srit);
	}
}

// -----------------------------------------------------------------------------------

int DumbPlayer::Seek(int Pos,int mode) {
	int position = 0;
	
	if(mode==MM_SEQUENCE) {

		sr = dumb_it_start_at_order(myduh, 2, Pos);
		srit = duh_get_it_sigrenderer(sr);
		dumb_it_set_loop_callback(srit, loop_callback, this);
		POS = (65536.0f/44100)*duh_sigrenderer_get_position(sr);
		return POS;

	}
	
	switch(mode) {
		case MM_BYTES:		position=Pos/(BITS/8)/CHANNELS	; break;
		case MM_SAMPLES:	position=Pos					; break;
		case MM_MILLISECS:	position=Pos*(SAMPLERATE/1000.0)	; break;
		default: 			return POS;
	}

	sr = duh_start_sigrenderer(myduh, 0, 2, (65536.0f/44100)*position );
	srit = duh_get_it_sigrenderer(sr);
	dumb_it_set_loop_callback(srit, loop_callback, this);

	POS = position*((BITS/8)*CHANNELS);
	return POS;

}

// -----------------------------------------------------------------------------------


extern "C" {

	IMaxModMusic* LoadMusic_Dumb(IMaxModStream* Stream) {
	
		mmPrint("Dumb Loader...");

		Stream->Seek(0);
		DumbPlayer* This 	= new DumbPlayer;
	
		// stream is from file
		if(Stream->TypeID==0) {
			mmPrint("Dumb File Loader...");
			cfile* s = static_cast<cfile*>(Stream);
			FILE* file = s->pFile;
			This->dumbfile = dumbfile_open_stdfile(file);
			This->myduh	= dumb_read_it(This->dumbfile);

			if(!This->myduh) {
				dumbfile_close(This->dumbfile);
				Stream->Seek(0);
				This->dumbfile = dumbfile_open_stdfile(file);
				This->myduh = dumb_read_xm(This->dumbfile);
			}
			if(!This->myduh) {
				dumbfile_close(This->dumbfile);
				Stream->Seek(0);
				This->dumbfile = dumbfile_open_stdfile(file);
				This->myduh = dumb_read_mod(This->dumbfile);
			}
			if(!This->myduh) {
				dumbfile_close(This->dumbfile);
				Stream->Seek(0);
				This->dumbfile = dumbfile_open_stdfile(file);
				This->myduh = dumb_read_s3m(This->dumbfile);
			}
		
		// stream is from memory
		} else if(Stream->TypeID==1) {
			mmPrint("Dumb Memory Loader...");
			cmem* m = static_cast<cmem*>(Stream);
			This->dumbfile = dumbfile_open_memory(m->pFile, m->SIZE);
			This->myduh	= dumb_read_it(This->dumbfile);

			if(!This->myduh) {
				dumbfile_close(This->dumbfile);
				Stream->Seek(0);
				This->dumbfile = dumbfile_open_memory(m->pFile, m->SIZE);
				This->myduh = dumb_read_xm(This->dumbfile);
			}
			if(!This->myduh) {
				dumbfile_close(This->dumbfile);
				Stream->Seek(0);
				This->dumbfile = dumbfile_open_memory(m->pFile, m->SIZE);
				This->myduh = dumb_read_mod(This->dumbfile);
			}
			if(!This->myduh) {
				dumbfile_close(This->dumbfile);
				Stream->Seek(0);
				This->dumbfile = dumbfile_open_memory(m->pFile, m->SIZE);
				This->myduh = dumb_read_s3m(This->dumbfile);
			}
		}		

		This->sr = duh_start_sigrenderer(This->myduh, 0, 2, 0);
		if (!This->sr) {
			mmPrint("Dumb rejected");
			dumbfile_close(This->dumbfile);
			unload_duh(This->myduh);
			delete This;
			return NULL;
		}	

		This->Stream 		= Stream;
		This->CHANNELS 	= 2;
		This->SAMPLERATE 	= 44100;
		This->BITS		= 16;
		This->SEEKABLE		= 1;
		This->STATUS		= 0;
		This->SIZE 		= (((double)duh_get_length(This->myduh)/65536.0)*44100)*4;

		This->delta 		= 65536.0f/44100;

		This->srit 		= duh_get_it_sigrenderer(This->sr);
		This->sd			= duh_get_it_sigdata(This->myduh);

		dumb_it_set_loop_callback(This->srit, loop_callback, This);


		return This;
		
	}

}

