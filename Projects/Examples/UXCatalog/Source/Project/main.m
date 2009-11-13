
/*!
@project	UXCatalog
@file		main.m
@copyright	(c) 2009 - Semanteme
@created	8/23/09 - David
*/

#import <UIKit/UIKit.h>

/*!
@function main
@abstract If nil is specified for principalClassName, the value for NSPrincipalClass 
from the Info.plist is used. If there is no NSPrincipalClass key specified, the 
UIApplication class is used. The delegate class will be instantiated using init.
*/
int
main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, @"UXCatalogApplicationDelegate");
	[pool release];
	return retVal;
}
