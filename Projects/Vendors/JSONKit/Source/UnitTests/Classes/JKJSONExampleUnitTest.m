
/*!
@project    JSONKit
@header     JKJSONExampleUnitTest.m.h
@copyright  (c) 2007 - 2009, Stig Brautaset
@changes    (c) 2009, Semantap
*/

#import <SenTestingKit/SenTestingKit.h>
#import <JSONKit/JSONKit.h>

@interface JKJSONExampleUnitTest : SenTestCase
@end

@implementation JKJSONExampleUnitTest

	-(void) testJsonOrg {
		NSString *file, *dir = @"../../Source/UnitTests/Resources/Data/Json.Org";
		NSDirectoryEnumerator *files = [[NSFileManager defaultManager] enumeratorAtPath:dir];
		
		while ((file = [files nextObject])) {
			if (![[file pathExtension] isEqualToString:@"json"]) {
				continue;
			}
			
			NSString *jsonPath = [dir stringByAppendingPathComponent:file];
			NSString *plistPath = [[jsonPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"plist"];
			
			NSString *jsonRep = [NSString stringWithContentsOfFile:jsonPath
														  encoding:NSASCIIStringEncoding
															 error:nil];
			id json;
			STAssertNoThrow(json = [jsonRep JSONValue], nil);
			STAssertNotNil(json, nil);
			
			// Check that we roundtrip properly
			STAssertEqualObjects([[json JSONRepresentation] JSONValue], json, nil);
			
			NSString *plist = [NSString stringWithContentsOfFile:plistPath
														encoding:NSASCIIStringEncoding
														   error:nil];
			
			if (!plist) {
				continue;
			}
			
			id expected = [plist propertyList];
			STAssertEqualObjects(json, expected, nil);
			STAssertEqualObjects([[expected JSONRepresentation] JSONValue], expected, nil);
		}
	}

	-(void) testRFC4627 {
		NSString *file, *dir = @"../../Source/UnitTests/Resources/Data/RFC4627";
		NSDirectoryEnumerator *files = [[NSFileManager defaultManager] enumeratorAtPath:dir];
		
		while ((file = [files nextObject])) {
			if (![[file pathExtension] isEqualToString:@"json"]) {
				continue;
			}
			
			NSString *jsonPath = [dir stringByAppendingPathComponent:file];
			NSString *plistPath = [[jsonPath stringByDeletingPathExtension] stringByAppendingPathExtension:@"plist"];
			
			NSString *jsonRep = [NSString stringWithContentsOfFile:jsonPath
														  encoding:NSASCIIStringEncoding
															 error:nil];
			id json;
			STAssertNoThrow(json = [jsonRep JSONValue], nil);
			STAssertNotNil(json, nil);
			
			// Check that we roundtrip properly
			STAssertEqualObjects([[json JSONRepresentation] JSONValue], json, nil);
			
			NSString *plist = [NSString stringWithContentsOfFile:plistPath
														encoding:NSASCIIStringEncoding
														   error:nil];
			
			id expected = [plist propertyList];
			STAssertEqualObjects(json, expected, nil);
			STAssertEqualObjects([[expected JSONRepresentation] JSONValue], expected, nil);
		}
	}

	-(void) testJsonChecker {
		NSString *file, *dir = @"../../Source/UnitTests/Resources/Data/JSONChecker";
		NSDirectoryEnumerator *files = [[NSFileManager defaultManager] enumeratorAtPath:dir];
		
		JKJSON *sbjson = [JKJSON new];
		sbjson.maxDepth = 19;
		while ((file = [files nextObject])) {
			if (![[file pathExtension] isEqualToString:@"json"]) {
				continue;
			}
			
			NSString *json = [NSString stringWithContentsOfFile:[dir stringByAppendingPathComponent:file]
													   encoding:NSASCIIStringEncoding
														  error:nil];
			
			if ([file hasPrefix:@"pass"]) {
				STAssertNotNil([sbjson objectWithString:json error:NULL], nil);
				
			}
			else {
				STAssertNil([sbjson objectWithString:json error:NULL], json);
			}
		}
	}

@end
