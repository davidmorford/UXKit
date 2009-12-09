
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <SenTestingKit/SenTestingKit.h>
#import <StorageKit/STKNSSortDescriptor.h>

@interface STKNSSortDescriptorTest : SenTestCase {
	
}

@end

#pragma mark -

@implementation STKNSSortDescriptorTest

	-(void) setUp {
		[super setUp];
	}

	-(void) tearDown {
		[super tearDown];
	}

	#pragma mark Tests

	-(void) testSortDescriptorsWithString {
		NSArray *sortDescriptors;
		
		sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"title"];
		STAssertTrue(1 == [sortDescriptors count], @"");
		STAssertEquals(@"title", [[sortDescriptors objectAtIndex:0] key], @"");
		STAssertTrue([[sortDescriptors objectAtIndex:0] ascending], @"");
		
		sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"title asc"];
		STAssertTrue(1 == [sortDescriptors count], @"");
		STAssertTrue([[[sortDescriptors objectAtIndex:0] key] isEqualToString:@"title"], @"");
		STAssertTrue([[sortDescriptors objectAtIndex:0] ascending], @"");
		
		sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"title desc"];
		STAssertTrue(1 == [sortDescriptors count], @"");
		STAssertTrue([[[sortDescriptors objectAtIndex:0] key] isEqualToString:@"title"], @"");
		STAssertTrue(![[sortDescriptors objectAtIndex:0] ascending], @"");
		
		sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"title, date"];
		STAssertTrue(2 == [sortDescriptors count], @"");
		STAssertTrue([[[sortDescriptors objectAtIndex:0] key] isEqualToString:@"title"], @"");
		STAssertTrue([[sortDescriptors objectAtIndex:0] ascending], @"");
		STAssertTrue([[[sortDescriptors objectAtIndex:1] key] isEqualToString:@"date"], @"");
		STAssertTrue([[sortDescriptors objectAtIndex:1] ascending], @"");
		
		sortDescriptors = [NSSortDescriptor sortDescriptorsWithString:@"title desc, date desc"];
		STAssertTrue(2 == [sortDescriptors count], @"");
		STAssertTrue([[[sortDescriptors objectAtIndex:0] key] isEqualToString:@"title"], @"");
		STAssertTrue(![[sortDescriptors objectAtIndex:0] ascending], @"");
		STAssertTrue([[[sortDescriptors objectAtIndex:1] key]isEqualToString:@"date"], @"");
		STAssertTrue(![[sortDescriptors objectAtIndex:1] ascending], @"");
	}

	-(void) dealloc {
		[super dealloc];
	}

@end
