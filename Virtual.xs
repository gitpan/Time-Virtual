#define MIN_PERL_DEFINE 1

#include <EXTERN.h>
#include <perl.h>
#include <XSUB.h>

#include "TimeVirtualAPI.h"

/*-----------------------------------------------------*/

static void pure_now_u3(U32 *ret)
{ croak("Time::Virtual::now_u3 is not implemented"); }

static double pure_now_nv()
{ croak("Time::Virtual::now_nv is not implemented"); }

/*-----------------------------------------------------*/

static SV *pcb_u3=0, *pcb_nv=0;

static void perl_now_u3(U32 *ret)
{
  int cnt;
  I32 ax;
  dSP;
  assert(pcb_u3);
  PUSHMARK(SP);
  PUTBACK;
  cnt = perl_call_sv(pcb_u3, G_ARRAY|G_NOARGS);
  SPAGAIN;
  SP -= cnt;
  ax = (SP - PL_stack_base) + 1;
  if (cnt == 3) {
    ret[0] = SvIOK(ST(0))? SvIVX(ST(0)) : SvIV(ST(0));
    ret[1] = SvIOK(ST(1))? SvIVX(ST(1)) : SvIV(ST(1));
    ret[2] = SvIOK(ST(2))? SvIVX(ST(2)) : SvIV(ST(2));
  }
  else warn("U3time returned %d arguments instead of 3", cnt);
  PUTBACK;
}

static double perl_now_nv()
{
  double got;
  dSP;
  assert(pcb_nv);
  PUSHMARK(SP);
  PUTBACK;
  perl_call_sv(pcb_nv, G_SCALAR|G_NOARGS);
  SPAGAIN;
  got = POPn;
  PUTBACK;
  return got;
}

/*-----------------------------------------------------*/
static struct TimeVirtualAPI api;
static SV *nvsv;
static SV *u3sv[3];

MODULE = Time::Virtual		PACKAGE = Time::Virtual

PROTOTYPES: ENABLE

BOOT:
  {
    int xx;
    SV *apisv;
    api.Version = TIME_VIRTUAL_API_VERSION;
    api.now_u3 = pure_now_u3;
    api.now_nv = pure_now_nv;
    apisv = perl_get_sv("Time::Virtual::API", 1);
    sv_setiv(apisv, (IV)&api);
    SvREADONLY_on(apisv);
    nvsv = newSVnv(0);
    SvREADONLY_on(nvsv);
    for (xx=0; xx < 3; xx++) {
      u3sv[xx] = newSViv(0);
      SvREADONLY_on(u3sv[xx]);
    }
  }

void
install(...)
	PPCODE:
	STRLEN na;
	int xx;
	if (items & 1) { warn("odd number of args"); --items; }
	for (xx=0; xx < items; xx += 2) {
	  char *key = SvPV(ST(xx), na);
	  if        (strEQ(key, "nv")) {
	    SvREFCNT_dec(pcb_nv);
	    pcb_nv = SvREFCNT_inc(ST(xx+1));
	    api.now_nv = perl_now_nv;
	  } else if (strEQ(key, "u3")) {
	    SvREFCNT_dec(pcb_u3);
	    pcb_u3 = SvREFCNT_inc(ST(xx+1));
	    api.now_u3 = perl_now_u3;
	  } else {
	    warn("install '%s' unrecognized (ignored)", key);
	  }
	}

void
NVtime()
	PPCODE:
	SvNVX(nvsv) = api.now_nv();
	XPUSHs(nvsv);

void
U3time()
	PPCODE:
	U32 tm[3];
	api.now_u3(tm);
	SvIVX(u3sv[0]) = tm[0];
	SvIVX(u3sv[1]) = tm[1];
	SvIVX(u3sv[2]) = tm[2];
	EXTEND(SP,3);
	PUSHs(u3sv[0]);
	PUSHs(u3sv[1]);
	PUSHs(u3sv[2]);
