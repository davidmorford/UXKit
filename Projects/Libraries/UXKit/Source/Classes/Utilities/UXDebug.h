
/*!
@project    UXKit
@header     UXDebug.h
@copyright  Copyright 2009 Facebook
@created    11/29/09
*/

#import <Foundation/Foundation.h>

/*!
A priority-based, debug-only logging interface.

How to use it
-------------

To output text to the console:
UXDINFO(@"Logging text with args %@", stringArg);
or
UXDPRINT(@"Logging text with args %@", stringArg);
etc...

Each macro will only display its logging information if its level is below
UXMAXLOGLEVEL. UXDPRINT is an exception to this in that it will always
log the text, regardless of log level.  See "Default log level" for more info
about log levels.

Note: these logging macros will only log if the DEBUG macro is set.

To assert something in debug mode:
UXDASSERT(value == 4);

Default log level
-----------------

The default log level for the Three20 project is WARNING. This means that
only WARNING and ERROR logs will be displayed. Most of the logs in Three20
are INFO logs, so by default they will not be displayed.

Setting the log level
---------------------

You need to set UXMAXLOGLEVEL in your project settings as a preprocessor macro.
- To do so in Xcode, find the target you wish to configure in the
"Groups and Files" view. Right click it and click "Get Info".
- Under the "Build" tab, look for the Preprocessor Macros setting.
- Double-click the right-side column and click the "+" button.
- Type any of the following to set your log level:
UXMAXLOGLEVEL=3
or
UXMAXLOGLEVEL=UXLOGLEVEL_INFO
etc...

Available Macros
----------------

UXDASSERT(statement) - Jumps into the debugger if statement evaluates to false
					Use Cmd-Y in Xcode to ensure gdb is attached.

And the logging functions:
UXDERROR(text, ...)
UXDWARNING(text, ...)
UXDINFO(text, ...)
UXDPRINT(text, ...) - Generic logging function, similar to deprecated UXLOG

Output format example:
"/path/to/file(line_number): <message>"


^               ^
| Informational |
| - - - - - - - | <- The max log level. Only logs with a level
|    Warning    |    below this line will be output.
|               |
|     Error     |
|               |
-----------------*/

#define UXLOGLEVEL_INFO     5
#define UXLOGLEVEL_WARNING  3
#define UXLOGLEVEL_ERROR    1

#ifndef UXMAXLOGLEVEL
	#define UXMAXLOGLEVEL UXLOGLEVEL_WARNING
#endif

// The general purpose logger. This ignores logging levels.
#ifdef DEBUG
	#define UXDPRINT(xx, ...)  NSLog(@"%s(%d): " xx, __FILE__, __LINE__, ## __VA_ARGS__)
#else
	#define UXDPRINT(xx, ...)  ((void)0)
#endif

// Debug-only assertions.
#ifdef DEBUG
#include "TargetConditionals.h"

#if TARGET_IPHONE_SIMULATOR

int
UXIsInDebugger();

// We leave the __asm__ in this macro so that when a break occurs, we don't have to step out of
// a "breakInDebugger" function.
#define UXDASSERT(xx) { if (!(xx)) { UXDPRINT(@"UXDASSERT failed: %s", # xx); \
	if (UXIsInDebugger()) { __asm__("int $3\n" : : ); }; } }
#else
	#define UXDASSERT(xx) { if (!(xx)) { UXDPRINT(@"UXDASSERT failed: %s", # xx); } }
#endif
#else
#define UXDASSERT(xx) ((void)0)
#endif

// Log-level based logging macros.
#if UXLOGLEVEL_ERROR <= UXMAXLOGLEVEL
	#define UXDERROR(xx, ...)  UXDPRINT(xx, ## __VA_ARGS__)
#else
	#define UXDERROR(xx, ...)  ((void)0)
#endif

#if UXLOGLEVEL_WARNING <= UXMAXLOGLEVEL
	#define UXDWARNING(xx, ...)  UXDPRINT(xx, ## __VA_ARGS__)
#else
	#define UXDWARNING(xx, ...)  ((void)0)
#endif

#if UXLOGLEVEL_INFO <= UXMAXLOGLEVEL
	#define UXDINFO(xx, ...)  UXDPRINT(xx, ## __VA_ARGS__)
#else
	#define UXDINFO(xx, ...)  ((void)0)
#endif
