#include "rtaudiodriver.h"
 
extern "C" {
	IMaxModAudioDriver* CreateAudioDriver_RtAudio()           {return new RtAudioDriver();}
	void CloseAudioDriver_RtAudio(IMaxModAudioDriver* Driver) {delete static_cast<RtAudioDriver*>(Driver);}
}

int RtCallback( void *outputBuffer, void *inputBuffer, unsigned int nBufferFrames,double streamTime, RtAudioStreamStatus status, void *data ) {
	MaxMod_ProcessChannels(outputBuffer,nBufferFrames);
	return 0;
}
 
// ______________________________________________________________________________________________________________

RtAudioDriver::RtAudioDriver(){

	mmPrint("RtAudioDriver::RtAudioDriver");
	Terminate = 0;
	Active = 0;
	unsigned int devices = dac.getDeviceCount();
	if ( devices<1 ) {mmPrint("No audio output device found!"); return;} 
	else {mmPrint("Audio drivers found=",(int)devices);}

	parameters.deviceId     = dac.getDefaultOutputDevice();
	parameters.nChannels    = 2;
	parameters.firstChannel = 0;
	bufferFrames            = 1024;
}

RtAudioDriver::~RtAudioDriver(){
	mmPrint("~RtAudioStream");
	if (!Terminate) Shutdown();
}
	
int RtAudioDriver::Startup(){
	if (Active==1) return 1;
	mmPrint("RtAudioDriver::Startup");
	options.flags = RTAUDIO_SCHEDULE_REALTIME;
	options.numberOfBuffers = 3;
	options.priority = 1;	
	dac.openStream( &parameters, NULL, RTAUDIO_FLOAT32, 44100, &bufferFrames, &RtCallback, this, &options );
	dac.startStream();
	Active=1;
	return 1;
}

int RtAudioDriver::Shutdown(){
	mmPrint("RtAudioDriver::Shutdown");
	Terminate=1;
	dac.closeStream();
	return 1;
}

IMaxModSound* RtAudioDriver::CreateSound( int samplerate, int channels, int bits, int flags, void* data, int size ){
}

