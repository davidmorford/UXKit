
#ifndef _GTMDevLog
	#ifdef DEBUG
		#define _GTMDevLog(...) NSLog(__VA_ARGS__)
	#else
		#define _GTMDevLog(...) do { } while (0)
	#endif
#endif

@class NSString;

extern void _GTMUnittestDevLog(NSString *format, ...);

#ifndef _GTMDevAssert
	#if !defined(NS_BLOCK_ASSERTIONS)
	#define _GTMDevAssert(condition, ...) \
		do { \
			if (!(condition)) { \
				[[NSAssertionHandler currentHandler] \
				 handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__] \
				 file:[NSString stringWithCString:__FILE__] \
				 lineNumber:__LINE__ \
				 description:__VA_ARGS__]; \
			} \
		} while (0)
	#else
		#define _GTMDevAssert(condition, ...) do { } while (0)
	#endif
#endif

#ifndef _GTMCompileAssert
	#define _GTMCompileAssertSymbolInner(line, msg) _GTMCOMPILEASSERT ## line ## __ ## msg
	#define _GTMCompileAssertSymbol(line, msg)		_GTMCompileAssertSymbolInner(line, msg)
	#define _GTMCompileAssert(test, msg)			typedef char _GTMCompileAssertSymbol(__LINE__, msg) [ ((test) ? 1 : -1) ]
#endif

#include <TargetConditionals.h>

#if TARGET_OS_IPHONE
	#define GTM_IPHONE_SDK 1
#else
	#define GTM_MACOS_SDK 1
#endif
