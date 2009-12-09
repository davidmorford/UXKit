
/*!
@project    
@header     UXKitUnitTest.m.h
@copyright  (c) 2009 - Semantap
@author     david [at] semantap.com
@created    
*/

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import <UXKit/UXKit.h>

/*!
@class UXKitUnitTest
@superclass SenTestCase
@abstract
@discussion
*/
@interface UXKitUnitTest : SenTestCase {
	NSDate *start;
}

@end

#pragma mark -

@implementation UXKitUnitTest

	-(void) setUp {
		start = [NSDate date];
		/*
		NSBundle *unitTestBundle = [NSBundle bundleForClass:[UXKitUnitTest class]];
		NSString *fixturePath	= [unitTestBundle pathForResource:@"" ofType:@""];
		*/
	}

	-(void) tearDown {
		NSTimeInterval ellapsed = [start timeIntervalSinceNow] * -1.0;
		NSLog(@"Testing took %f seconds", ellapsed);
	}


	#pragma mark -

	-(void) testCreate {
		/*
		STAssertTrue([a isKindOfClass:[NSDictionary class]], nil);
		STAssertTrue([[a valueForKeyPath:@"bill.session"] isEqualToString:@"111"], nil);
		STAssertNotNil([a valueForKeyPath:@"bill.introduced.date"], nil);
		STAssertTrue([[a valueForKey:@"statuses"] isKindOfClass:[NSArray class]], nil);
		STAssertEquals([actions count], (NSUInteger)3, nil);
		STAssertEqualObjects([title objectForKey:@"type"], @"official", nil);
		STAssertEqualObjects([title objectForKey:@"content"], @"Providing for consideration of motions to suspend the rules, and for other purposes.", nil);
		STAssertEqualObjects([subCommittee valueForKeyPath:@"thomas-names.name.content"], @"Forestry, Water Resources, and Environment", nil);
		*/
	}

@end
