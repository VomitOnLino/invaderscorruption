#include <iostream>
#include "flac.h"
using namespace std;

 
// ------------------------------------------------------------------------------------------

FLAC__StreamDecoderWriteStatus write_callback(const FLAC__StreamDecoder *decoder, const FLAC__Frame *frame, const FLAC__int32 * const buffer[], void *client_data) {

	FlacPlayer* f = (FlacPlayer*)client_data;

	if (f->SIZE==0) {
		mmPrint("ERROR: this example only works for FLAC files that have a total_samples count in STREAMINFO");
		return FLAC__STREAM_DECODER_WRITE_STATUS_ABORT;
	}
	if (f->CHANNELS!=2 or f->BITS!=16) {
		mmPrint("ERROR: this example only supports 16bit stereo streams");
		return FLAC__STREAM_DECODER_WRITE_STATUS_ABORT;
	}

	for(size_t i=0; i < frame->header.blocksize; i++) {
		//write_little_endian_int16(f, (FLAC__int16)buffer[0][i]);
		//write_little_endian_int16(f, (FLAC__int16)buffer[1][i]);
		
		f->OutputBuffer[f->OutputWritePos]=(FLAC__int16)(buffer[0][i]);
		f->OutputWritePos++;
		f->OutputLength++;
		
		f->OutputBuffer[f->OutputWritePos]=(FLAC__int16)(buffer[1][i]);
		f->OutputWritePos++;
		f->OutputLength++;
	}
	
	return FLAC__STREAM_DECODER_WRITE_STATUS_CONTINUE;
}

// ------------------------------------------------------------------------------------------

void metadata_callback(const FLAC__StreamDecoder *decoder, const FLAC__StreamMetadata *metadata, void *client_data) {
	FlacPlayer* f = (FlacPlayer*)client_data;
	if(metadata->type == FLAC__METADATA_TYPE_STREAMINFO) {
		f->SAMPLERATE 	= metadata->data.stream_info.sample_rate;
		f->CHANNELS 	= metadata->data.stream_info.channels;
		f->BITS		= metadata->data.stream_info.bits_per_sample;
		f->SIZE 		= metadata->data.stream_info.total_samples * f->CHANNELS * (f->BITS/8);
	}
}

// ------------------------------------------------------------------------------------------

void error_callback(const FLAC__StreamDecoder *decoder, FLAC__StreamDecoderErrorStatus status, void *client_data){
	FlacPlayer* f = (FlacPlayer*)client_data;
	mmPrint("Got error callback: ",FLAC__StreamDecoderErrorStatusString[status]);
}

// ------------------------------------------------------------------------------------------

FLAC__StreamDecoderReadStatus read_callback(const FLAC__StreamDecoder *decoder, FLAC__byte buffer[], size_t *bytes, void *client_data){

	FlacPlayer* f = (FlacPlayer*)client_data;
	if(*bytes > 0) {
		*bytes = f->CStream->Read(buffer, *bytes*sizeof(FLAC__byte));
		if(*bytes == 0) {
			return FLAC__STREAM_DECODER_READ_STATUS_END_OF_STREAM;
		} else {
			return FLAC__STREAM_DECODER_READ_STATUS_CONTINUE;
		}
	} else {
		return FLAC__STREAM_DECODER_READ_STATUS_ABORT;
	}
}

// ------------------------------------------------------------------------------------------

FLAC__StreamDecoderSeekStatus seek_callback(const FLAC__StreamDecoder *decoder, FLAC__uint64 absolute_byte_offset, void *client_data) {
	FlacPlayer* f = (FlacPlayer*)client_data;
	if (f->CStream->Seek(absolute_byte_offset)==absolute_byte_offset){
		return FLAC__STREAM_DECODER_SEEK_STATUS_OK;
	} else {
		return FLAC__STREAM_DECODER_SEEK_STATUS_ERROR;
	}
}

// ------------------------------------------------------------------------------------------

FLAC__StreamDecoderTellStatus tell_callback(const FLAC__StreamDecoder *decoder, FLAC__uint64 *absolute_byte_offset, void *client_data) {
	FlacPlayer* f = (FlacPlayer*)client_data;
	off_t pos = f->CStream->Position();

	if (pos>=0) {
		*absolute_byte_offset = (FLAC__uint64)pos;
		return FLAC__STREAM_DECODER_TELL_STATUS_OK;
	} else {
		return FLAC__STREAM_DECODER_TELL_STATUS_ERROR;
	}
}

// ------------------------------------------------------------------------------------------

FLAC__StreamDecoderLengthStatus length_callback(const FLAC__StreamDecoder *decoder, FLAC__uint64 *stream_length, void *client_data) {
	FlacPlayer* f = (FlacPlayer*)client_data;
	*stream_length = (FLAC__uint64)f->CStream->Size();
	return FLAC__STREAM_DECODER_LENGTH_STATUS_OK;
}

// ------------------------------------------------------------------------------------------

FLAC__bool eof_callback(const FLAC__StreamDecoder *decoder, void *client_data) {
	FlacPlayer* f = (FlacPlayer*)client_data;
	if (f->CStream->Eof()) {return true;}
	return false;
}

// ------------------------------------------------------------------------------------------










void FlacFreeFunction(IMaxModMusic* music){
	delete static_cast<FlacPlayer*>(music);
}


FlacPlayer::FlacPlayer() {

	LOOP     		= 0;
	SEEKABLE		= 1;
	CStream		= NULL;
	FreeFunction	= FlacFreeFunction;

	OutputBuffer	= new short[44100*4];
	OutputLength	= 0;
	OutputReadPos  = 0;
	OutputWritePos = 0;
	
	if((decoder = FLAC__stream_decoder_new()) == NULL) {
		mmPrint("ERROR: allocating flac decoder");
		return;
	}

	FLAC__stream_decoder_set_md5_checking(decoder, true);

	if(FLAC__stream_decoder_init_stream(
		decoder,
		read_callback,
		seek_callback,
		tell_callback,
		length_callback,
		eof_callback,
		write_callback,
		metadata_callback,
		error_callback,
		this
	) != FLAC__STREAM_DECODER_INIT_STATUS_OK) {mmPrint("ERROR: FLAC__stream_decoder_init_stream");}

};

// ------------------------------------------------------------------------------------------

FlacPlayer::~FlacPlayer() {
	mmPrint("~FlacPlayer");
	FLAC__stream_decoder_delete(decoder);
	delete[] OutputBuffer;
	POS=0;
	if (CStream!=NULL) {
		CStream->Close();
		delete CStream;
	}
};

// -----------------------------------------------------------------------------------

void FlacPlayer::DecodeChunk() {

	OutputLength=0;
	OutputReadPos=0;
	OutputWritePos=0;
	
//	do {

		if (CStream->Eof()) {
//			mmPrint("Eof!");
			Seek(0,MM_BYTES);
			FLAC__stream_decoder_reset(decoder);
			if(LOOP==0){STATUS=0; return;}
		};

		if (!FLAC__stream_decoder_process_single(decoder)) {

			mmPrint("ERROR: FLAC__stream_decoder_process_");
			mmPrint("ERROR= ", FLAC__StreamDecoderStateString[FLAC__stream_decoder_get_state(decoder)]);
		}
//	} while(OutputLength==0);
	
}

// -----------------------------------------------------------------------------------

int FlacPlayer::FillBuffer(void* buffer,int Length) {
	if (STATUS==0) return 0;
	short* buf=(short*)buffer;
	int i=0;
	for (i=0;i<Length/2;i++) {
		if (OutputReadPos>=OutputLength) {DecodeChunk();}
		if (OutputLength>0) {*buf++=OutputBuffer[OutputReadPos++]; POS+=2;}
	}
	return Length;
}

// -----------------------------------------------------------------------------------

int FlacPlayer::Seek(int Pos,int mode) {

	// convert Pos into samples
	int position = 0;
	switch(mode) {
		case MM_BYTES:		position=Pos/(BITS/8)/CHANNELS	; break;
		case MM_SAMPLES:	position=Pos					; break;
//		case MM_MILLISECS:	position=Pos*(SAMPLERATE/1000.0)	; break;
	}
//	mmPrint("flac seek to:",position);
//	FLAC__stream_decoder_reset(decoder);
	FLAC__stream_decoder_flush(decoder);
	
	if(position>=(SIZE/(BITS/8)/CHANNELS)) {STATUS=0; return SIZE;}
	
	if (FLAC__stream_decoder_seek_absolute(decoder, position)) {POS = position*((BITS/8)*CHANNELS);}
	if (FLAC__stream_decoder_get_state(decoder)==FLAC__STREAM_DECODER_SEEK_ERROR) {FLAC__stream_decoder_flush(decoder);}
	DecodeChunk();
	return POS;
}

// -----------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------

extern "C" {

	IMaxModMusic* LoadMusic_Flac(IMaxModStream* Stream) {

		if (!Stream) return NULL;
		mmPrint("Flac Loader...");
		
		Stream->Seek(0);
		if (Stream->ReadString(4)!="fLaC") {mmPrint("Flac tag rejected"); return NULL;}
		Stream->Seek(0);
	
		FlacPlayer* This 	= new FlacPlayer;
		This->CStream		= Stream;
		This->SAMPLERATE	= 0;
		This->CHANNELS		= 0;
		This->BITS		= 16;
		This->SIZE		= 0;
		This->STATUS		= 1;
		
		FLAC__stream_decoder_process_single(This->decoder);
		if (This->SAMPLERATE==0 or This->CHANNELS==0 or This->SIZE==0) {
			This->CStream = NULL;		// do not delete the stream!
			delete This;
			mmPrint("Flac decoder rejected");
			return NULL;
		}
		
//		mmPrint("pcm length=",This->SIZE);
//		mmPrint("BITS=",This->BITS);
		
		return This;
	
	}

	void CloseMusic_Flac(IMaxModMusic* music) {delete static_cast<FlacPlayer*>(music);}
}
