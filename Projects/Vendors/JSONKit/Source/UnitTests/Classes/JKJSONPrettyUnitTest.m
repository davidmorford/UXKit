
/*!
@project    JSONKit
@header     JKJSONPrettyUnitTest.m
@copyright  (c) 2007 - 2009, Stig Brautaset
@changes    (c) 2009, Semantap
*/

#import <SenTestingKit/SenTestingKit.h>
#import <JSONKit/JSONKit.h>

@interface JKJSONPrettyUnitTest : SenTestCase

@end

@implementation JKJSONPrettyUnitTest

	-(void) testOutputFormat {
		JKJSON *json = [JKJSON new];
		
		NSBundle *unitTestBundle	= [NSBundle bundleForClass:[JKJSONPrettyUnitTest self]];
		NSString *inputJSONFile		= [unitTestBundle pathForResource:@"input" ofType:@"json"];    
		STAssertNotNil(inputJSONFile, @"Couldn't find path to file in Unit Test Bundle.");
		NSString *inputString = [NSString stringWithContentsOfFile:inputJSONFile 
														  encoding:NSASCIIStringEncoding 
															 error:nil];
		id input	= [json objectWithString:inputString error:nil];
		id output	= [json stringWithObject:input error:nil];
		STAssertEquals([[output componentsSeparatedByString:@"\n"] count], (NSUInteger)1, nil);
		
		json.humanReadable	= YES;
		id humanReadable	= [json stringWithObject:input error:NULL];
		STAssertEquals([[humanReadable componentsSeparatedByString:@"\n"] count], (NSUInteger)14, nil);
		
		json.sortKeys	= YES;
		id sortKeys		= [json stringWithObject:input error:nil];
		
		STAssertEquals([[sortKeys componentsSeparatedByString:@"\n"] count], (NSUInteger)14, nil);
		STAssertFalse([sortKeys isEqual:humanReadable], @"%@ == %@", sortKeys, humanReadable);


		NSString *humanReadableJSONFile	= [unitTestBundle pathForResource:@"HumanReadable" ofType:@"json"];    
		STAssertNotNil(humanReadableJSONFile, @"Couldn't find path to file in Unit Test Bundle.");
		NSString *expected				= [NSString stringWithContentsOfFile:humanReadableJSONFile encoding:NSASCIIStringEncoding error:nil];
		
		// chop off the newline
		expected = [expected substringToIndex:[expected length] - 1];
		STAssertEqualObjects(sortKeys, expected, nil);
	}

@end
