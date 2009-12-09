
/*!
@project    TableKit
@header     TVKTableControllerTest.m
@copyright  (c) 2009 - Semantap
@author     david [at] semantap.com
@created	12/6/09 – 7:43 PM
*/

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import <TableKit/TableKit.h>

/*!
@class TVKTableControllerTest
@abstract
@discussion
*/
@interface TVKTableControllerTest : SenTestCase {
	TVKTableController *tableController;
}

	-(void) testSectionAdd;
	-(void) testSectionRemove;

@end

#pragma mark -

@implementation TVKTableControllerTest
	
	-(void) setUp {
		tableController = [[TVKTableController alloc] init];
	}

	-(void) tearDown {
		[tableController release];
		tableController = nil;
	}

	#pragma mark -

	-(void) testSectionAdd {
		TVKTableGroup *tableGroup = nil;
		tableGroup = [[TVKTableGroup alloc] initWithName:@"1"];
		[tableController addSection:tableGroup];
		[tableGroup release];
		tableGroup = nil;
		STAssertEquals([tableController.sections count], (NSUInteger)1, nil);
	}

	-(void) testSectionRemove {
		TVKTableGroup *tableGroup = nil;
		tableGroup = [tableController sectionWithName:@"1"];
		[tableController removeSection:tableGroup];
		STAssertEquals([tableController.sections count], (NSUInteger)0, nil);
	}

@end
