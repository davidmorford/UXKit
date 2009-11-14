
/*!
@project    JSONKit
@header     JKJSONProxyUnitTest.m.h
@copyright  (c) 2007 - 2009, Stig Brautaset
@changes    (c) 2009, Semantap
*/

#import <SenTestingKit/SenTestingKit.h>
#import <JSONKit/JSONKit.h>

@class JKJSONWriter;

@interface JKJSONProxyUnitTest : SenTestCase {
	JKJSONWriter *writer;
}

@end

@interface True : NSObject
@end

@implementation True

-(id) proxyForJson {
	return [NSNumber numberWithBool:YES];
}

@end

@interface False : NSObject
@end

@implementation False

-(id) proxyForJson {
	return [NSNumber numberWithBool:NO];
}

@end

@interface Bool : NSObject

@end

@implementation Bool

-(id) proxyForJson {
	return [NSArray arrayWithObjects:[True new], [False new], nil];
}

@end

@implementation NSDate (Private)

-(id) proxyForJson {
	return [self description];
}

@end

#pragma mark -

@implementation JKJSONProxyUnitTest

	-(void)setUp {
		writer = [JKJSONWriter new];
	}

	-(void) testUnsupportedWithoutProxy {
		STAssertNil([writer stringWithObject:[NSArray arrayWithObject:[NSObject new]]], nil);
		STAssertEquals([[writer.errorTrace objectAtIndex:0] code], (NSInteger)EUNSUPPORTED, nil);
	}

	-(void) testUnsupportedWithProxy {
		STAssertEqualObjects([writer stringWithObject:[NSArray arrayWithObject:[True new]]], @"[true]", nil);
	}

	-(void) testUnsupportedWithNestedProxy {
		STAssertEqualObjects([writer stringWithObject:[NSArray arrayWithObject:[Bool new]]], @"[[true,false]]", nil);
	}

	-(void) testUnsupportedWithProxyAsCategory {
		STAssertNotNil([writer stringWithObject:[NSArray arrayWithObject:[NSDate date]]], nil);
	}

@end
