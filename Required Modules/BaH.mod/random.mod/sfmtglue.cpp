
extern "C" {

#include "blitz.h"
#include <SFMT.h>

	double bmx_genrand_real1();
	double bmx_genrand_real2();
	double bmx_genrand_real3();
	void bmx_gen_rand64(BBInt64 * r);
	double bmx_genrand_res53();
}


double bmx_genrand_real1() {
	return genrand_real1();
}

double bmx_genrand_real2() {
	return genrand_real2();
}

double bmx_genrand_real3() {
	return genrand_real3();
}


void bmx_gen_rand64(BBInt64 * r) {
	*r = gen_rand64();
}

double bmx_genrand_res53() {
	return genrand_res53();
}
