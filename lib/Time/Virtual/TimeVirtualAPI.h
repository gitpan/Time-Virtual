/*
 * Time is the our most definitive limitation.
 *
 * If one doesn't take time seriously and study its workings how can one
 * hope to accomplish anything?  Very likely, your aims are so
 * unrealistic that there is not enough time to do what you want to do.
 *
 * Stop waiting!  There is not so much time that you can afford to waste
 * it.  Not even one moment!
 *
 * Time is impersonal.
 */

#ifndef _time_virtual_api_H_
#define _time_virtual_api_H_

#define TIME_VIRTUAL_API_VERSION 1

struct TimeVirtualAPI {
  IV Version;

  /* try to be flexible about representation */
  void    (*now_u3)(U32 *ret);
  double  (*now_nv)();
};

#define FETCH_TIME_VIRTUAL_API(YourName, api)				\
STMT_START {								\
  SV *sv = perl_get_sv("Time::API",0);					\
  if (!sv) croak("Time::API not found");				\
  api = (struct TimeVirtualAPI*) SvIV(sv);				\
  if (api->Version != TIME_VIRTUAL_API_VERSION) {			\
    croak("Time::API version mismatch -- you must recompile %s",	\
	  YourName);							\
  }									\
} STMT_END

#endif
