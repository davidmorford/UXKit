
/*!
@project    KTXMLDOMUnitTest
@header     KTXMLDOMUnitTest
@copyright  (c) 2008 Robbie Hanson / Deusty Designs LLC. All rights reserved.
@changes    (c) 2009 Semantap
*/

#import <Foundation/Foundation.h>
#import <SenTestingKit/SenTestingKit.h>
#import <XMLKit/XMLKit.h>

/*!
@class KTXMLDOMUnitTest 
@superclass SenTestCase
@abstract
@discussion
*/
@interface KTXMLDOMUnitTest : SenTestCase {
	NSDate *start;
}

	-(void) testLocalName;
	-(void) testPrefixName;
	-(void) testDoubleAdd;
	-(void) testNsGeneral;
	-(void) testNsLevel;
	-(void) testNsURI;
	-(void) testAttrGeneral;
	-(void) testAttrSiblings;
	-(void) testAttrDocOrder;
	-(void) testAttrChildren;
	-(void) testString;
	-(void) testChildren;
	-(void) testPreviousNextNode1;
	-(void) testPreviousNextNode2;
	-(void) testPrefix;
	-(void) testURI;
	-(void) testXmlns;
	-(void) testCopy;
	-(void) testCData;
	-(void) testElements;
	-(void) testXPath;
	-(void) testNodesForXPath;
	-(void) testInsertChild;
	-(void) testElementSerialization;

@end

#pragma mark -

@implementation KTXMLDOMUnitTest

	-(void) setUp {
		start = [NSDate date];
	}

	-(void) tearDown {
		NSTimeInterval ellapsed = [start timeIntervalSinceNow] * -1.0;
		NSLog(@"Testing took %f seconds", ellapsed);
	}


	#pragma mark -

	-(void) testLocalName {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSString *nsTest1 = [KTXMLNode localNameForName:@"a:quack"];
		NSString *ddTest1 = [KTXMLNode localNameForName:@"a:quack"];
		
		STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1");
		
		NSString *nsTest2 = [KTXMLNode localNameForName:@"a:a:quack"];
		NSString *ddTest2 = [KTXMLNode localNameForName:@"a:a:quack"];
		
		STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2");
		
		NSString *nsTest3 = [KTXMLNode localNameForName:@"quack"];
		NSString *ddTest3 = [KTXMLNode localNameForName:@"quack"];
		
		STAssertTrue([nsTest3 isEqualToString:ddTest3], @"Failed test 3");
		
		NSString *nsTest4 = [KTXMLNode localNameForName:@"a:"];
		NSString *ddTest4 = [KTXMLNode localNameForName:@"a:"];
		
		STAssertTrue([nsTest4 isEqualToString:ddTest4], @"Failed test 4");
		
		NSString *nsTest5 = [KTXMLNode localNameForName:nil];
		NSString *ddTest5 = [KTXMLNode localNameForName:nil];
		
		STAssertTrue(!nsTest5 && !ddTest5, @"Failed test 5");
		
		KTXMLNode *nsNode = [KTXMLNode namespaceWithName:@"tucker" stringValue:@"dog"];
		KTXMLNode *ddNode = [KTXMLNode namespaceWithName:@"tucker" stringValue:@"dog"];
		
		NSString *nsTest6 = [nsNode localName];
		NSString *ddTest6 = [ddNode localName];
		
		STAssertTrue([nsTest6 isEqualToString:ddTest6], @"Failed test 6");
		
		[pool release];
	}

	-(void) testPrefixName {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSString *nsTest1 = [KTXMLNode prefixForName:@"a:quack"];
		NSString *ddTest1 = [KTXMLNode prefixForName:@"a:quack"];
		
		STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1");
		
		NSString *nsTest2 = [KTXMLNode prefixForName:@"a:a:quack"];
		NSString *ddTest2 = [KTXMLNode prefixForName:@"a:a:quack"];
		
		STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2");
		
		NSString *nsTest3 = [KTXMLNode prefixForName:@"quack"];
		NSString *ddTest3 = [KTXMLNode prefixForName:@"quack"];
		
		STAssertTrue([nsTest3 isEqualToString:ddTest3], @"Failed test 3");
		
		NSString *nsTest4 = [KTXMLNode prefixForName:@"a:"];
		NSString *ddTest4 = [KTXMLNode prefixForName:@"a:"];
		
		STAssertTrue([nsTest4 isEqualToString:ddTest4], @"Failed test 4");
		
		NSString *nsTest5 = [KTXMLNode prefixForName:nil];
		NSString *ddTest5 = [KTXMLNode prefixForName:nil];
		
		STAssertTrue([nsTest5 isEqualToString:ddTest5], @"Failed test 5");
		
		KTXMLNode *nsNode = [KTXMLNode namespaceWithName:@"tucker" stringValue:@"dog"];
		KTXMLNode *ddNode = [KTXMLNode namespaceWithName:@"tucker" stringValue:@"dog"];
		
		NSString *nsTest6 = [nsNode prefix];
		NSString *ddTest6 = [ddNode prefix];
		
		STAssertTrue([nsTest6 isEqualToString:ddTest6], @"Failed test 6");
		
		[pool release];
	}

	-(void) testDoubleAdd {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		//	KTXMLElement *nsRoot1 = [KTXMLElement elementWithName:@"root1"];
		//	KTXMLElement *nsRoot2 = [KTXMLElement elementWithName:@"root2"];
		
		//	KTXMLElement *nsNode = [KTXMLElement elementWithName:@"node"];
		//	KTXMLNode *nsAttr = [KTXMLNode attributeWithName:@"key" stringValue:@"value"];
		//	KTXMLNode *nsNs = [KTXMLNode namespaceWithName:@"a" stringValue:@"domain.com"];
		
		//	[nsRoot1 addChild:nsAttr]; // Elements can only have text, elements, processing instructions, and comments as children
		//	[nsRoot1 addAttribute:nsNode]; // Not an attribute
		//	[nsRoot1 addNamespace:nsNode]; // Not a namespace
		
		//	[nsRoot1 addChild:nsNode];
		//	[nsRoot2 addChild:nsNode]; // Cannot add a child that has a parent; detach or copy first
		
		//	[nsRoot1 addAttribute:nsAttr];
		//	[nsRoot2 addAttribute:nsAttr]; // Cannot add an attribute with a parent; detach or copy first
		
		//	[nsRoot1 addNamespace:nsNs];
		//	[nsRoot2 addNamespace:nsNs]; // Cannot add a namespace with a parent; detach or copy first
		
		//	KTXMLElement *ddRoot1 = [KTXMLElement elementWithName:@"root1"];
		//	KTXMLElement *ddRoot2 = [KTXMLElement elementWithName:@"root2"];
		
		//	KTXMLElement *ddNode = [KTXMLElement elementWithName:@"node"];
		//	KTXMLNode *ddAttr = [KTXMLNode attributeWithName:@"key" stringValue:@"value"];
		//	KTXMLNode *ddNs = [KTXMLNode namespaceWithName:@"a" stringValue:@"domain.com"];
		
		//	[ddRoot1 addChild:ddAttr]; // Elements can only have text, elements, processing instructions, and comments as children
		//	[ddRoot1 addAttribute:ddNode]; // Not an attribute
		//	[ddRoot1 addNamespace:ddNode]; // Not a namespace
		
		//	[ddRoot1 addChild:ddNode];
		//	[ddRoot2 addChild:ddNode]; // Cannot add a child that has a parent; detach or copy first
		
		//	[ddRoot1 addAttribute:ddAttr];
		//	[ddRoot2 addAttribute:ddAttr]; // Cannot add an attribute with a parent; detach or copy first
		
		//	[ddRoot1 addNamespace:ddNs];
		//	[ddRoot2 addNamespace:ddNs]; // Cannot add a namespace with a parent; detach or copy first
		
		[pool release];
	}

	-(void) testNsGeneral {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		KTXMLNode *nsNs = [KTXMLNode namespaceWithName:@"a" stringValue:@"deusty.com"];
		KTXMLNode *ddNs = [KTXMLNode namespaceWithName:@"a" stringValue:@"deusty.com"];
		
		NSString *nsTest1 = [nsNs XMLString];
		NSString *ddTest1 = [ddNs XMLString];
		
		STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1");
		
		[nsNs setName:@"b"];
		[ddNs setName:@"b"];
		
		NSString *nsTest2 = [nsNs XMLString];
		NSString *ddTest2 = [ddNs XMLString];
		
		STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2");
		
		[nsNs setStringValue:@"robbiehanson.com"];
		[ddNs setStringValue:@"robbiehanson.com"];
		
		NSString *nsTest3 = [nsNs XMLString];
		NSString *ddTest3 = [ddNs XMLString];
		
		STAssertTrue([nsTest3 isEqualToString:ddTest3], @"Failed test 3");
		
		[pool release];
	}

	-(void) testNsLevel {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		// <root xmlns:a="apple.com">
		//   <node xmlns:d="deusty.com" xmlns:rh="robbiehanson.com"/>
		// </root>
		
		KTXMLElement *nsRoot = [KTXMLElement elementWithName:@"root"];
		KTXMLElement *nsNode = [KTXMLElement elementWithName:@"node"];
		KTXMLNode *nsNs0 = [KTXMLNode namespaceWithName:@"a" stringValue:@"apple.com"];
		KTXMLNode *nsNs1 = [KTXMLNode namespaceWithName:@"d" stringValue:@"deusty.com"];
		KTXMLNode *nsNs2 = [KTXMLNode namespaceWithName:@"rh" stringValue:@"robbiehanson.com"];
		[nsNode addNamespace:nsNs1];
		[nsNode addNamespace:nsNs2];
		[nsRoot addNamespace:nsNs0];
		[nsRoot addChild:nsNode];
		
		KTXMLElement *ddRoot = [KTXMLElement elementWithName:@"root"];
		KTXMLElement *ddNode = [KTXMLElement elementWithName:@"node"];
		KTXMLNode *ddNs0 = [KTXMLNode namespaceWithName:@"a" stringValue:@"apple.com"];
		KTXMLNode *ddNs1 = [KTXMLNode namespaceWithName:@"d" stringValue:@"deusty.com"];
		KTXMLNode *ddNs2 = [KTXMLNode namespaceWithName:@"rh" stringValue:@"robbiehanson.com"];
		[ddNode addNamespace:ddNs1];
		[ddNode addNamespace:ddNs2];
		[ddRoot addNamespace:ddNs0];
		[ddRoot addChild:ddNode];
		
		STAssertTrue([nsNs0 index] == [ddNs0 index], @"Failed test 1");
		STAssertTrue([nsNs1 index] == [ddNs1 index], @"Failed test 2");
		STAssertTrue([nsNs2 index] == [ddNs2 index], @"Failed test 3");
		
		STAssertTrue([nsNs0 level] == [ddNs0 level], @"Failed test 4");
		STAssertTrue([nsNs1 level] == [ddNs1 level], @"Failed test 5");
		STAssertTrue([nsNs2 level] == [ddNs2 level], @"Failed test 6");
		
		[pool release];
	}

	-(void) testNsURI {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		KTXMLElement *nsNode = [KTXMLElement elementWithName:@"duck" URI:@"quack.com"];
		KTXMLElement *ddNode = [KTXMLElement elementWithName:@"duck" URI:@"quack.com"];
		
		NSString *nsTest1 = [nsNode URI];
		NSString *ddTest1 = [ddNode URI];
		
		STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1");
		
		[nsNode setURI:@"food.com"];
		[ddNode setURI:@"food.com"];
		
		NSString *nsTest2 = [nsNode URI];
		NSString *ddTest2 = [ddNode URI];
		
		STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2");
		
		KTXMLNode *nsAttr = [KTXMLNode attributeWithName:@"duck" URI:@"quack.com" stringValue:@"quack"];
		KTXMLNode *ddAttr = [KTXMLNode attributeWithName:@"duck" URI:@"quack.com" stringValue:@"quack"];
		
		NSString *nsTest3 = [nsAttr URI];
		NSString *ddTest3 = [ddAttr URI];
		
		STAssertTrue([nsTest3 isEqualToString:ddTest3], @"Failed test 3");
		
		[nsAttr setURI:@"food.com"];
		[ddAttr setURI:@"food.com"];
		
		NSString *nsTest4 = [nsAttr URI];
		NSString *ddTest4 = [ddAttr URI];
		
		STAssertTrue([nsTest4 isEqualToString:ddTest4], @"Failed test 4");
		
		[pool release];
	}

	-(void) testAttrGeneral {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		KTXMLNode *nsAttr = [KTXMLNode attributeWithName:@"apple" stringValue:@"inc"];
		KTXMLNode *ddAttr = [KTXMLNode attributeWithName:@"apple" stringValue:@"inc"];
		
		NSString *nsStr1 = [nsAttr XMLString];
		NSString *ddStr1 = [ddAttr XMLString];
		
		STAssertTrue([nsStr1 isEqualToString:ddStr1], @"Failed test 1");
		
		[nsAttr setName:@"deusty"];
		[ddAttr setName:@"deusty"];
		
		NSString *nsStr2 = [nsAttr XMLString];
		NSString *ddStr2 = [ddAttr XMLString];
		
		STAssertTrue([nsStr2 isEqualToString:ddStr2], @"Failed test 2");
		
		[nsAttr setStringValue:@"designs"];
		[ddAttr setStringValue:@"designs"];
		
		NSString *nsStr3 = [nsAttr XMLString];
		NSString *ddStr3 = [ddAttr XMLString];
		
		STAssertTrue([nsStr3 isEqualToString:ddStr3], @"Failed test 3");
		
		[pool release];
	}

	-(void) testAttrSiblings {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		// <duck sound="quack" swims="YES" flys="YES"/>
		
		KTXMLElement *nsNode = [KTXMLElement elementWithName:@"duck"];
		[nsNode addAttribute:[KTXMLNode attributeWithName:@"sound" stringValue:@"quack"]];
		[nsNode addAttribute:[KTXMLNode attributeWithName:@"swims" stringValue:@"YES"]];
		[nsNode addAttribute:[KTXMLNode attributeWithName:@"flys" stringValue:@"YES"]];
		
		KTXMLElement *ddNode = [KTXMLElement elementWithName:@"duck"];
		[ddNode addAttribute:[KTXMLNode attributeWithName:@"sound" stringValue:@"quack"]];
		[ddNode addAttribute:[KTXMLNode attributeWithName:@"swims" stringValue:@"YES"]];
		[ddNode addAttribute:[KTXMLNode attributeWithName:@"flys" stringValue:@"YES"]];
		
		KTXMLNode *nsAttr = [nsNode attributeForName:@"swims"];
		KTXMLNode *ddAttr = [ddNode attributeForName:@"swims"];
		
		NSString *nsTest1 = [nsAttr XMLString];
		NSString *ddTest1 = [ddAttr XMLString];
		
		STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1");
		
		//	NSLog(@"nsAttr prev: %@", [[nsAttr previousSibling] XMLString]);  // nil
		//	NSLog(@"nsAttr next: %@", [[nsAttr nextSibling] XMLString]);      // nil
		
		//	NSLog(@"ddAttr prev: %@", [[ddAttr previousSibling] XMLString]);  // sound="quack"
		//	NSLog(@"ddAttr next: %@", [[ddAttr nextSibling] XMLString]);      // flys="YES"
		
		//	Analysis: KTXML works and KTXML doesn't. I see no need to cripple KTXML because of that.
		
		[pool release];
	}

	-(void) testAttrDocOrder {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		// <duck sound="quack" swims="YES" flys="YES"/>
		
		KTXMLElement *nsNode = [KTXMLElement elementWithName:@"duck"];
		[nsNode addAttribute:[KTXMLNode attributeWithName:@"sound" stringValue:@"quack"]];
		[nsNode addAttribute:[KTXMLNode attributeWithName:@"swims" stringValue:@"YES"]];
		[nsNode addAttribute:[KTXMLNode attributeWithName:@"flys" stringValue:@"YES"]];
		
		KTXMLElement *ddNode = [KTXMLElement elementWithName:@"duck"];
		[ddNode addAttribute:[KTXMLNode attributeWithName:@"sound" stringValue:@"quack"]];
		[ddNode addAttribute:[KTXMLNode attributeWithName:@"swims" stringValue:@"YES"]];
		[ddNode addAttribute:[KTXMLNode attributeWithName:@"flys" stringValue:@"YES"]];
		
		KTXMLNode *nsAttr = [nsNode attributeForName:@"swims"];
		KTXMLNode *ddAttr = [ddNode attributeForName:@"swims"];
		
		KTXMLNode *nsTest1 = [nsAttr previousNode];
		KTXMLNode *ddTest1 = [ddAttr previousNode];
		
		STAssertTrue((!nsTest1 && !ddTest1), @"Failed test 1");
		
		KTXMLNode *nsTest2 = [nsAttr nextNode];
		KTXMLNode *ddTest2 = [ddAttr nextNode];
		
		STAssertTrue((!nsTest2 && !ddTest2), @"Failed test 2");
		
		// Notes: Attributes play no part in the document order.
		
		[pool release];
	}

	-(void) testAttrChildren {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		KTXMLNode *nsAttr1 = [KTXMLNode attributeWithName:@"deusty" stringValue:@"designs"];
		KTXMLNode *ddAttr1 = [KTXMLNode attributeWithName:@"deusty" stringValue:@"designs"];
		
		KTXMLNode *nsTest1 = [nsAttr1 childAtIndex:0];
		KTXMLNode *ddTest1 = [ddAttr1 childAtIndex:0];
		
		STAssertTrue((!nsTest1 && !ddTest1), @"Failed test 1");
		
		NSUInteger nsTest2 = [nsAttr1 childCount];
		NSUInteger ddTest2 = [ddAttr1 childCount];
		
		STAssertTrue((nsTest2 == ddTest2), @"Failed test 2");
		
		NSArray *nsTest3 = [nsAttr1 children];
		NSArray *ddTest3 = [ddAttr1 children];
		
		STAssertTrue((!nsTest3 && !ddTest3), @"Failed test 3");
		
		// Notes: Attributes aren't supposed to have children, although in libxml they technically do.
		// The child is simply a pointer to a text node, which contains the attribute value.
		
		[pool release];
	}

	-(void) testString {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		// <pizza>
		//   <toppings>
		//     <pepperoni/>
		//     <sausage>
		//       <mild/>
		//       <spicy/>
		//     </sausage>
		//   </toppings>
		//   <crust>
		//     <thin/>
		//     <thick/>
		//   </crust>
		// </pizza>
		
		KTXMLElement *nsNode0 = [KTXMLElement elementWithName:@"pizza"];
		KTXMLElement *nsNode1 = [KTXMLElement elementWithName:@"toppings"];
		KTXMLElement *nsNode2 = [KTXMLElement elementWithName:@"pepperoni"];
		KTXMLElement *nsNode3 = [KTXMLElement elementWithName:@"sausage"];
		KTXMLElement *nsNode4 = [KTXMLElement elementWithName:@"mild"];
		KTXMLElement *nsNode5 = [KTXMLElement elementWithName:@"spicy"];
		KTXMLElement *nsNode6 = [KTXMLElement elementWithName:@"crust"];
		KTXMLElement *nsNode7 = [KTXMLElement elementWithName:@"thin"];
		KTXMLElement *nsNode8 = [KTXMLElement elementWithName:@"thick"];
		
		[nsNode0 addChild:nsNode1];
		[nsNode0 addChild:nsNode6];
		[nsNode1 addChild:nsNode2];
		[nsNode1 addChild:nsNode3];
		[nsNode3 addChild:nsNode4];
		[nsNode3 addChild:nsNode5];
		[nsNode6 addChild:nsNode7];
		[nsNode6 addChild:nsNode8];
		
		KTXMLElement *ddNode0 = [KTXMLElement elementWithName:@"pizza"];
		KTXMLElement *ddNode1 = [KTXMLElement elementWithName:@"toppings"];
		KTXMLElement *ddNode2 = [KTXMLElement elementWithName:@"pepperoni"];
		KTXMLElement *ddNode3 = [KTXMLElement elementWithName:@"sausage"];
		KTXMLElement *ddNode4 = [KTXMLElement elementWithName:@"mild"];
		KTXMLElement *ddNode5 = [KTXMLElement elementWithName:@"spicy"];
		KTXMLElement *ddNode6 = [KTXMLElement elementWithName:@"crust"];
		KTXMLElement *ddNode7 = [KTXMLElement elementWithName:@"thin"];
		KTXMLElement *ddNode8 = [KTXMLElement elementWithName:@"thick"];
		
		[ddNode0 addChild:ddNode1];
		[ddNode0 addChild:ddNode6];
		[ddNode1 addChild:ddNode2];
		[ddNode1 addChild:ddNode3];
		[ddNode3 addChild:ddNode4];
		[ddNode3 addChild:ddNode5];
		[ddNode6 addChild:ddNode7];
		[ddNode6 addChild:ddNode8];
		
		KTXMLNode *nsAttr1 = [KTXMLNode attributeWithName:@"price" stringValue:@"1.00"];
		KTXMLNode *ddAttr1 = [KTXMLNode attributeWithName:@"price" stringValue:@"1.00"];
		
		[nsNode1 addAttribute:nsAttr1];
		[ddNode1 addAttribute:ddAttr1];
		
		[nsNode4 setStringValue:@"<just right>"];
		[ddNode4 setStringValue:@"<just right>"];
		
		[nsNode5 setStringValue:@"too hot"];
		[ddNode5 setStringValue:@"too hot"];
		
		NSString *nsTest1 = [nsNode0 stringValue];  // Returns "<just right>too hot"
		NSString *ddTest1 = [ddNode0 stringValue];
		
		STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1");
		
		NSString *nsTest2 = [nsAttr1 stringValue];  // Returns "1.00"
		NSString *ddTest2 = [ddAttr1 stringValue];
		
		STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2");
		
		[nsAttr1 setStringValue:@"1.25"];
		[ddAttr1 setStringValue:@"1.25"];
		
		NSString *nsTest3 = [nsAttr1 stringValue];  // Returns "1.25"
		NSString *ddTest3 = [ddAttr1 stringValue];
		
		STAssertTrue([nsTest3 isEqualToString:ddTest3], @"Failed test 3");
		
		[nsNode0 setStringValue:@"<wtf>ESCAPE</wtf>"];
		[ddNode0 setStringValue:@"<wtf>ESCAPE</wtf>"];
		
		NSString *nsTest4 = [nsNode0 stringValue];  // Returns "<wtf>ESCAPE</wtf>"
		NSString *ddTest4 = [ddNode0 stringValue];
		
		STAssertTrue([nsTest4 isEqualToString:ddTest4], @"Failed test 4");
		
		//	NSString *nsTest5 = [nsNode0 XMLString];  // Returns "<pizza>&lt;wtf>ESCAPE&lt;/wtf></pizza>"
		//	NSString *ddTest5 = [ddNode0 XMLString];  // Returns "<pizza>&lt;wtf&gt;ESCAPE&lt;/wtf&gt;</pizza>"
		//
		//	NSAssert([nsTest5 isEqualToString:ddTest5], @"Failed test 5");
		//
		//  The KTXML version is actually more accurate, so we'll accept the difference.
		
		[pool release];
	}

	-(void) testChildren {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSMutableString *xmlStr = [NSMutableString stringWithCapacity:100];
		[xmlStr appendString:@"<?xml version=\"1.0\"?>"];
		[xmlStr appendString:@"<beers>            "];
		[xmlStr appendString:@"  <sam_adams/>     "];
		[xmlStr appendString:@"  <left_hand/>     "];
		[xmlStr appendString:@"  <goose_island/>  "];
		[xmlStr appendString:@" <!-- budweiser -->"];
		[xmlStr appendString:@"</beers>           "];
		
		KTXMLDocument *nsDoc = [[KTXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
		KTXMLDocument *ddDoc = [[KTXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
		
		NSUInteger nsChildCount = [[nsDoc rootElement] childCount];
		NSUInteger ddChildCount = [[ddDoc rootElement] childCount];
		
		STAssertTrue(nsChildCount == ddChildCount, @"Failed test 1");
		
		NSArray *nsChildren = [[nsDoc rootElement] children];
		NSArray *ddChildren = [[ddDoc rootElement] children];
		
		STAssertTrue([nsChildren count] == [ddChildren count], @"Failed test 2");
		
		NSString *nsBeer = [[[nsDoc rootElement] childAtIndex:1] name];
		NSString *ddBeer = [[[ddDoc rootElement] childAtIndex:1] name];
		
		STAssertTrue([nsBeer isEqualToString:ddBeer], @"Failed test 3");
		
		[pool release];
	}

	-(void) testPreviousNextNode1 {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		// <pizza>
		//   <toppings>
		//     <pepperoni/>
		//     <sausage>
		//       <mild/>
		//       <spicy/>
		//     </sausage>
		//   </toppings>
		//   <crust>
		//     <thin/>
		//     <thick/>
		//   </crust>
		// </pizza>
		
		KTXMLElement *nsNode0 = [KTXMLElement elementWithName:@"pizza"];
		KTXMLElement *nsNode1 = [KTXMLElement elementWithName:@"toppings"];
		KTXMLElement *nsNode2 = [KTXMLElement elementWithName:@"pepperoni"];
		KTXMLElement *nsNode3 = [KTXMLElement elementWithName:@"sausage"];
		KTXMLElement *nsNode4 = [KTXMLElement elementWithName:@"mild"];
		KTXMLElement *nsNode5 = [KTXMLElement elementWithName:@"spicy"];
		KTXMLElement *nsNode6 = [KTXMLElement elementWithName:@"crust"];
		KTXMLElement *nsNode7 = [KTXMLElement elementWithName:@"thin"];
		KTXMLElement *nsNode8 = [KTXMLElement elementWithName:@"thick"];
		
		[nsNode0 addChild:nsNode1];
		[nsNode0 addChild:nsNode6];
		[nsNode1 addChild:nsNode2];
		[nsNode1 addChild:nsNode3];
		[nsNode3 addChild:nsNode4];
		[nsNode3 addChild:nsNode5];
		[nsNode6 addChild:nsNode7];
		[nsNode6 addChild:nsNode8];
		
		KTXMLElement *ddNode0 = [KTXMLElement elementWithName:@"pizza"];
		KTXMLElement *ddNode1 = [KTXMLElement elementWithName:@"toppings"];
		KTXMLElement *ddNode2 = [KTXMLElement elementWithName:@"pepperoni"];
		KTXMLElement *ddNode3 = [KTXMLElement elementWithName:@"sausage"];
		KTXMLElement *ddNode4 = [KTXMLElement elementWithName:@"mild"];
		KTXMLElement *ddNode5 = [KTXMLElement elementWithName:@"spicy"];
		KTXMLElement *ddNode6 = [KTXMLElement elementWithName:@"crust"];
		KTXMLElement *ddNode7 = [KTXMLElement elementWithName:@"thin"];
		KTXMLElement *ddNode8 = [KTXMLElement elementWithName:@"thick"];
		
		[ddNode0 addChild:ddNode1];
		[ddNode0 addChild:ddNode6];
		[ddNode1 addChild:ddNode2];
		[ddNode1 addChild:ddNode3];
		[ddNode3 addChild:ddNode4];
		[ddNode3 addChild:ddNode5];
		[ddNode6 addChild:ddNode7];
		[ddNode6 addChild:ddNode8];
		
		NSString *nsTest1 = [[nsNode2 nextNode] name];
		NSString *ddTest1 = [[ddNode2 nextNode] name];
		
		STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1: ns(%@) dd(%@)", nsTest1, ddTest1);
		
		NSString *nsTest2 = [[nsNode3 nextNode] name];
		NSString *ddTest2 = [[ddNode3 nextNode] name];
		
		STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2: ns(%@) dd(%@)", nsTest2, ddTest2);
		
		NSString *nsTest3 = [[nsNode5 nextNode] name];
		NSString *ddTest3 = [[ddNode5 nextNode] name];
		
		STAssertTrue([nsTest3 isEqualToString:ddTest3], @"Failed test 3: ns(%@) dd(%@)", nsTest3, ddTest3);
		
		NSString *nsTest4 = [[nsNode5 previousNode] name];
		NSString *ddTest4 = [[ddNode5 previousNode] name];
		
		STAssertTrue([nsTest4 isEqualToString:ddTest4], @"Failed test 4: ns(%@) dd(%@)", nsTest4, ddTest4);
		
		NSString *nsTest5 = [[nsNode6 previousNode] name];
		NSString *ddTest5 = [[ddNode6 previousNode] name];
		
		STAssertTrue([nsTest5 isEqualToString:ddTest5], @"Failed test 5: ns(%@) dd(%@)", nsTest5, ddTest5);
		
		NSString *nsTest6 = [[nsNode8 nextNode] name];
		NSString *ddTest6 = [[ddNode8 nextNode] name];
		
		STAssertTrue((!nsTest6 && !ddTest6), @"Failed test 6: ns(%@) dd(%@)", nsTest6, ddTest6);
		
		NSString *nsTest7 = [[nsNode0 previousNode] name];
		NSString *ddTest7 = [[ddNode0 previousNode] name];
		
		STAssertTrue((!nsTest7 && !ddTest7), @"Failed test 7: ns(%@) dd(%@)", nsTest7, ddTest7);
		
		[pool release];
	}

	-(void) testPreviousNextNode2 {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		NSMutableString *xmlStr = [NSMutableString stringWithCapacity:100];
		[xmlStr appendString:@"<?xml version=\"1.0\"?>"];
		[xmlStr appendString:@"<pizza>         "];
		[xmlStr appendString:@"  <toppings>    "];
		[xmlStr appendString:@"    <pepperoni/>"];
		[xmlStr appendString:@"    <sausage>   "];
		[xmlStr appendString:@"      <mild/>   "];
		[xmlStr appendString:@"      <spicy/>  "];
		[xmlStr appendString:@"    </sausage>  "];
		[xmlStr appendString:@"  </toppings>   "];
		[xmlStr appendString:@"  <crust>       "];
		[xmlStr appendString:@"    <thin/>     "];
		[xmlStr appendString:@"    <thick/>    "];
		[xmlStr appendString:@"  </crust>      "];
		[xmlStr appendString:@"</pizza>        "];
		
		KTXMLDocument *nsDoc = [[KTXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
		KTXMLDocument *ddDoc = [[KTXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
		
		KTXMLNode *nsNode0 = [nsDoc rootElement]; // pizza
		KTXMLNode *ddNode0 = [ddDoc rootElement]; // pizza
		
		KTXMLNode *nsNode2 = [[[nsDoc rootElement] childAtIndex:0] childAtIndex:0]; // pepperoni
		KTXMLNode *ddNode2 = [[[ddDoc rootElement] childAtIndex:0] childAtIndex:0]; // pepperoni
		
		KTXMLNode *nsNode3 = [[[nsDoc rootElement] childAtIndex:0] childAtIndex:1]; // sausage
		KTXMLNode *ddNode3 = [[[ddDoc rootElement] childAtIndex:0] childAtIndex:1]; // sausage
		
		KTXMLNode *nsNode5 = [[[[nsDoc rootElement] childAtIndex:0] childAtIndex:1] childAtIndex:1]; // spicy
		KTXMLNode *ddNode5 = [[[[ddDoc rootElement] childAtIndex:0] childAtIndex:1] childAtIndex:1]; // spicy
		
		KTXMLNode *nsNode6 = [[nsDoc rootElement] childAtIndex:1]; // crust
		KTXMLNode *ddNode6 = [[ddDoc rootElement] childAtIndex:1]; // crust
		
		KTXMLNode *nsNode8 = [[[nsDoc rootElement] childAtIndex:1] childAtIndex:1]; // crust
		KTXMLNode *ddNode8 = [[[ddDoc rootElement] childAtIndex:1] childAtIndex:1]; // crust
		
		NSString *nsTest1 = [[nsNode2 nextNode] name];
		NSString *ddTest1 = [[ddNode2 nextNode] name];
		
		STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1: ns(%@) dd(%@)", nsTest1, ddTest1);
		
		NSString *nsTest2 = [[nsNode3 nextNode] name];
		NSString *ddTest2 = [[ddNode3 nextNode] name];
		
		STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2: ns(%@) dd(%@)", nsTest2, ddTest2);
		
		NSString *nsTest3 = [[nsNode5 nextNode] name];
		NSString *ddTest3 = [[ddNode5 nextNode] name];
		
		STAssertTrue([nsTest3 isEqualToString:ddTest3], @"Failed test 3: ns(%@) dd(%@)", nsTest3, ddTest3);
		
		NSString *nsTest4 = [[nsNode5 previousNode] name];
		NSString *ddTest4 = [[ddNode5 previousNode] name];
		
		STAssertTrue([nsTest4 isEqualToString:ddTest4], @"Failed test 4: ns(%@) dd(%@)", nsTest4, ddTest4);
		
		NSString *nsTest5 = [[nsNode6 previousNode] name];
		NSString *ddTest5 = [[ddNode6 previousNode] name];
		
		STAssertTrue([nsTest5 isEqualToString:ddTest5], @"Failed test 5: ns(%@) dd(%@)", nsTest5, ddTest5);
		
		NSString *nsTest6 = [[nsNode8 nextNode] name];
		NSString *ddTest6 = [[ddNode8 nextNode] name];
		
		STAssertTrue((!nsTest6 && !ddTest6), @"Failed test 6: ns(%@) dd(%@)", nsTest6, ddTest6);
		
		NSString *nsTest7 = [[nsNode0 previousNode] name];
		NSString *ddTest7 = [[ddNode0 previousNode] name];
		
		STAssertTrue((!nsTest7 && !ddTest7), @"Failed test 7: ns(%@) dd(%@)", nsTest7, ddTest7);
		
		[pool release];
	}

	-(void) testPrefix {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		// <root xmlns:a="beagle" xmlns:b="lab">
		//   <dog/>
		//   <a:dog/>
		//   <a:b:dog/>
		//   <dog xmlns="beagle"/>
		// </root>
		
		KTXMLElement *nsNode1 = [KTXMLElement elementWithName:@"dog"];
		KTXMLElement *nsNode2 = [KTXMLElement elementWithName:@"a:dog"];
		KTXMLElement *nsNode3 = [KTXMLElement elementWithName:@"a:b:dog"];
		KTXMLElement *nsNode4 = [KTXMLElement elementWithName:@"dog" URI:@"beagle"];
		
		KTXMLElement *ddNode1 = [KTXMLElement elementWithName:@"dog"];
		KTXMLElement *ddNode2 = [KTXMLElement elementWithName:@"a:dog"];
		KTXMLElement *ddNode3 = [KTXMLElement elementWithName:@"a:b:dog"];
		KTXMLElement *ddNode4 = [KTXMLElement elementWithName:@"dog" URI:@"beagle"];
		
		NSString *nsTest1 = [nsNode1 prefix];
		NSString *ddTest1 = [ddNode1 prefix];
		
		STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1");
		
		NSString *nsTest2 = [nsNode2 prefix];
		NSString *ddTest2 = [ddNode2 prefix];
		
		STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2");
		
		NSString *nsTest3 = [nsNode3 prefix];
		NSString *ddTest3 = [ddNode3 prefix];
		
		STAssertTrue([nsTest3 isEqualToString:ddTest3], @"Failed test 3");
		
		NSString *nsTest4 = [nsNode4 prefix];
		NSString *ddTest4 = [ddNode4 prefix];
		
		STAssertTrue([nsTest4 isEqualToString:ddTest4], @"Failed test 4");
		
		[pool release];
	}

	-(void) testURI {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		// <root xmlns:a="deusty.com" xmlns:b="robbiehanson.com">
		//     <test test="1"/>
		//     <a:test test="2"/>
		//     <b:test test="3"/>
		//     <test xmlns="deusty.com" test="4"/>
		//     <test xmlns="quack.com" test="5"/>
		// </root>
		
		KTXMLElement *nsRoot = [KTXMLElement elementWithName:@"root"];
		[nsRoot addNamespace:[KTXMLNode namespaceWithName:@"a" stringValue:@"deusty.com"]];
		[nsRoot addNamespace:[KTXMLNode namespaceWithName:@"b" stringValue:@"robbiehanson.com"]];
		
		KTXMLElement *nsNode1 = [KTXMLElement elementWithName:@"test"];
		[nsNode1 addAttribute:[KTXMLNode attributeWithName:@"test" stringValue:@"1"]];
		
		KTXMLElement *nsNode2 = [KTXMLElement elementWithName:@"a:test"];
		[nsNode2 addAttribute:[KTXMLNode attributeWithName:@"test" stringValue:@"2"]];
		
		KTXMLElement *nsNode3 = [KTXMLElement elementWithName:@"b:test"];
		[nsNode3 addAttribute:[KTXMLNode attributeWithName:@"test" stringValue:@"3"]];
		
		KTXMLElement *nsNode4 = [KTXMLElement elementWithName:@"test" URI:@"deusty.com"];
		[nsNode4 addAttribute:[KTXMLNode attributeWithName:@"test" stringValue:@"4"]];
		
		KTXMLElement *nsNode5 = [KTXMLElement elementWithName:@"test" URI:@"quack.com"];
		[nsNode5 addAttribute:[KTXMLNode attributeWithName:@"test" stringValue:@"5"]];
		
		[nsRoot addChild:nsNode1];
		[nsRoot addChild:nsNode2];
		[nsRoot addChild:nsNode3];
		[nsRoot addChild:nsNode4];
		[nsRoot addChild:nsNode5];
		
		KTXMLElement *ddRoot = [KTXMLElement elementWithName:@"root"];
		[ddRoot addNamespace:[KTXMLNode namespaceWithName:@"a" stringValue:@"deusty.com"]];
		[ddRoot addNamespace:[KTXMLNode namespaceWithName:@"b" stringValue:@"robbiehanson.com"]];
		
		KTXMLElement *ddNode1 = [KTXMLElement elementWithName:@"test"];
		[ddNode1 addAttribute:[KTXMLNode attributeWithName:@"test" stringValue:@"1"]];
		
		KTXMLElement *ddNode2 = [KTXMLElement elementWithName:@"a:test"];
		[ddNode2 addAttribute:[KTXMLNode attributeWithName:@"test" stringValue:@"2"]];
		
		KTXMLElement *ddNode3 = [KTXMLElement elementWithName:@"b:test"];
		[ddNode3 addAttribute:[KTXMLNode attributeWithName:@"test" stringValue:@"3"]];
		
		KTXMLElement *ddNode4 = [KTXMLElement elementWithName:@"test" URI:@"deusty.com"];
		[ddNode4 addAttribute:[KTXMLNode attributeWithName:@"test" stringValue:@"4"]];
		
		KTXMLElement *ddNode5 = [KTXMLElement elementWithName:@"test" URI:@"quack.com"];
		[ddNode5 addAttribute:[KTXMLNode attributeWithName:@"test" stringValue:@"5"]];
		
		[ddRoot addChild:ddNode1];
		[ddRoot addChild:ddNode2];
		[ddRoot addChild:ddNode3];
		[ddRoot addChild:ddNode4];
		[ddRoot addChild:ddNode5];
		
		NSString *nsTest1 = [[nsNode1 resolveNamespaceForName:[nsNode1 name]] stringValue];
		NSString *ddTest1 = [[ddNode1 resolveNamespaceForName:[ddNode1 name]] stringValue];
		
		STAssertTrue(!nsTest1 && !ddTest1, @"Failed test 1");
		
		NSString *nsTest2 = [[nsNode2 resolveNamespaceForName:[nsNode2 name]] stringValue];
		NSString *ddTest2 = [[ddNode2 resolveNamespaceForName:[ddNode2 name]] stringValue];
		
		STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2: ns(%@) dd(%@)", nsTest2, ddTest2);
		
		NSString *nsTest3 = [[nsNode3 resolveNamespaceForName:[nsNode3 name]] stringValue];
		NSString *ddTest3 = [[ddNode3 resolveNamespaceForName:[ddNode3 name]] stringValue];
		
		STAssertTrue([nsTest3 isEqualToString:ddTest3], @"Failed test 3");
		
		NSString *nsTest4 = [[nsNode4 resolveNamespaceForName:[nsNode4 name]] stringValue];
		NSString *ddTest4 = [[ddNode4 resolveNamespaceForName:[ddNode4 name]] stringValue];
		
		STAssertTrue(!nsTest4 && !ddTest4, @"Failed test 4: ns(%@) dd(%@)", nsTest4, ddTest4);
		
		NSString *nsTest5 = [nsNode4 resolvePrefixForNamespaceURI:@"deusty.com"];
		NSString *ddTest5 = [ddNode4 resolvePrefixForNamespaceURI:@"deusty.com"];
		
		STAssertTrue([nsTest5 isEqualToString:ddTest5], @"Failed test 5: ns(%@) dd(%@)", nsTest5, ddTest5);
		
		NSString *nsTest6 = [nsNode4 resolvePrefixForNamespaceURI:@"robbiehanson.com"];
		NSString *ddTest6 = [ddNode4 resolvePrefixForNamespaceURI:@"robbiehanson.com"];
		
		STAssertTrue([nsTest6 isEqualToString:ddTest6], @"Failed test 6");
		
		NSString *nsTest7 = [nsNode4 resolvePrefixForNamespaceURI:@"quack.com"];
		NSString *ddTest7 = [ddNode4 resolvePrefixForNamespaceURI:@"quack.com"];
		
		STAssertTrue(!nsTest7 && !ddTest7, @"Failed test 7");
		
		NSString *nsTest8 = [nsNode4 resolvePrefixForNamespaceURI:nil];
		NSString *ddTest8 = [ddNode4 resolvePrefixForNamespaceURI:nil];
		
		STAssertTrue(!nsTest8 && !ddTest8, @"Failed test 8");
		
		NSUInteger nsTest9  = [[nsRoot elementsForName:@"test"] count];  // Returns test1, test4, test5
		NSUInteger ddTest9  = [[ddRoot elementsForName:@"test"] count];  // Returns test1, test4, test5
		
		STAssertTrue(nsTest9 == ddTest9, @"Failed test 9");
		
		NSUInteger nsTest10 = [[nsRoot elementsForName:@"a:test"] count];  // Returns node2 and node4
		NSUInteger ddTest10 = [[ddRoot elementsForName:@"a:test"] count];  // Returns node2 and node4
		
		STAssertTrue(nsTest10 == ddTest10, @"Failed test 10");
		
		NSUInteger nsTest11 = [[nsRoot elementsForLocalName:@"test" URI:@"deusty.com"] count];  // Returns node2 and node4
		NSUInteger ddTest11 = [[ddRoot elementsForLocalName:@"test" URI:@"deusty.com"] count];  // Returns node2 and node4
		
		STAssertTrue(nsTest11 == ddTest11, @"Failed test 11");
		
		NSUInteger nsTest12 = [[nsRoot elementsForLocalName:@"a:test" URI:@"deusty.com"] count];  // Returns nothing
		NSUInteger ddTest12 = [[ddRoot elementsForLocalName:@"a:test" URI:@"deusty.com"] count];  // Returns nothing
		
		STAssertTrue(nsTest12 == ddTest12, @"Failed test 12");
		
		NSUInteger nsTest13 = [[nsRoot elementsForLocalName:@"test" URI:@"quack.com"] count];  // Returns node5
		NSUInteger ddTest13 = [[ddRoot elementsForLocalName:@"test" URI:@"quack.com"] count];  // Returns node5
		
		STAssertTrue(nsTest13 == ddTest13, @"Failed test 13");
		
		[pool release];
	}

	-(void) testXmlns {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSString *parseMe = @"<query xmlns=\"jabber:iq:roster\"></query>";
		NSData *data = [parseMe dataUsingEncoding:NSUTF8StringEncoding];
		
		KTXMLDocument *nsDoc = [[KTXMLDocument alloc] initWithData:data options:0 error:nil];
		KTXMLElement *nsRootElement = [nsDoc rootElement];
		
		KTXMLDocument *ddDoc = [[KTXMLDocument alloc] initWithData:data options:0 error:nil];
		KTXMLElement *ddRootElement = [ddDoc rootElement];
		
		// Both URI and namespaceForPrefix:@"" should return "jabber:iq:roster"
		
		NSString *nsTest1 = [nsRootElement URI];
		NSString *ddTest1 = [ddRootElement URI];
		
		STAssertTrue([nsTest1 isEqualToString:ddTest1], @"Failed test 1");
		
		NSString *nsTest2 = [[nsRootElement namespaceForPrefix:@""] stringValue];
		NSString *ddTest2 = [[ddRootElement namespaceForPrefix:@""] stringValue];
		
		STAssertTrue([nsTest2 isEqualToString:ddTest2], @"Failed test 2");
		
		// In KTXML namespaceForPrefix:nil returns nil
		// In KTXML namespaceForPrefix:nil returns the same as namespaceForPrefix:@""
		//
		// This actually makes more sense, as many users would consider a prefix of nil or an empty string to be the same.
		// Plus many XML documents state that a prefix of nil or "" should be treated equally.
		//
		// This difference comes into play in other areas.
		//
		// In KTXML creating a namespace with prefix:nil doesn't work.
		// In KTXML creating a namespace with prefix:nil acts as if you had passed an empty string.
		
		NSUInteger nsTest3 = [[nsRootElement namespaces] count];
		NSUInteger ddTest3 = [[ddRootElement namespaces] count];
		
		STAssertTrue(nsTest3 == ddTest3, @"Failed test 3");
		
		// An odd quirk of KTXML is that if the data is parsed, then the namespaces array contains the default namespace.
		// However, if the XML tree is generated in code, and the default namespace was set via setting the URI,
		// then the namespaces array doesn't contain that default namespace.
		// If instead the addNamespace method is used to add the default namespace, then it is contained in the array,
		// and the URI is also properly set.
		//
		// I consider this to be a bug in KTXML.
		
		NSString *nsTest4 = [[nsRootElement resolveNamespaceForName:@""] stringValue];
		NSString *ddTest4 = [[ddRootElement resolveNamespaceForName:@""] stringValue];
		
		STAssertTrue([nsTest4 isEqualToString:ddTest4], @"Failed test 4");
		
		// Oddly enough, even though KTXML seems completely resistant to nil namespace prefixes, this works fine
		NSString *nsTest5 = [[nsRootElement resolveNamespaceForName:nil] stringValue];
		NSString *ddTest5 = [[ddRootElement resolveNamespaceForName:nil] stringValue];
		
		STAssertTrue([nsTest5 isEqualToString:ddTest5], @"Failed test 5");
		
		KTXMLElement *nsNode = [KTXMLElement elementWithName:@"query"];
		[nsNode addNamespace:[KTXMLNode namespaceWithName:@"" stringValue:@"jabber:iq:auth"]];
		
		KTXMLElement *ddNode = [KTXMLElement elementWithName:@"query"];
		[ddNode addNamespace:[KTXMLNode namespaceWithName:@"" stringValue:@"jabber:iq:auth"]];
		
		NSString *nsTest6 = [[nsNode resolveNamespaceForName:@""] stringValue];
		NSString *ddTest6 = [[ddNode resolveNamespaceForName:@""] stringValue];
		
		STAssertTrue([nsTest6 isEqualToString:ddTest6], @"Failed test 6");
		
		NSString *nsTest7 = [[nsNode resolveNamespaceForName:nil] stringValue];
		NSString *ddTest7 = [[ddNode resolveNamespaceForName:nil] stringValue];
		
		STAssertTrue([nsTest7 isEqualToString:ddTest7], @"Failed test 7");
		
		NSString *nsTest8 = [nsNode URI];
		NSString *ddTest8 = [ddNode URI];
		
		STAssertTrue([nsTest8 isEqualToString:ddTest8], @"Failed test 8");
		
		NSUInteger nsTest9 = [[nsNode namespaces] count];
		NSUInteger ddTest9 = [[ddNode namespaces] count];
		
		STAssertTrue(nsTest9 == ddTest9, @"Failed test 9");
		
		[pool release];
	}

	-(void) testCopy {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		// <parent>
		//   <child age="4">Billy</child>
		// </parent>
		
		NSString *xmlStr = @"<parent><child age=\"4\">Billy</child></parent>";
		
		KTXMLDocument *nsDoc = [[[KTXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil] autorelease];
		KTXMLDocument *ddDoc = [[[KTXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil] autorelease];
		
		// Test Document copy
		
		KTXMLDocument *nsDocCopy = [[nsDoc copy] autorelease];
		[[nsDocCopy rootElement] addAttribute:[KTXMLNode attributeWithName:@"type" stringValue:@"mom"]];
		
		KTXMLNode *nsDocAttr = [[nsDoc rootElement] attributeForName:@"type"];
		KTXMLNode *nsDocCopyAttr = [[nsDocCopy rootElement] attributeForName:@"type"];
		
		STAssertTrue(nsDocAttr == nil, @"Failed CHECK 1");
		STAssertTrue(nsDocCopyAttr != nil, @"Failed CHECK 2");
		
		KTXMLDocument *ddDocCopy = [[ddDoc copy] autorelease];
		[[ddDocCopy rootElement] addAttribute:[KTXMLNode attributeWithName:@"type" stringValue:@"mom"]];
		
		KTXMLNode *ddDocAttr = [[ddDoc rootElement] attributeForName:@"type"];
		KTXMLNode *ddDocCopyAttr = [[ddDocCopy rootElement] attributeForName:@"type"];
		
		STAssertNil(ddDocAttr, @"Failed test 1");
		STAssertNotNil(ddDocCopyAttr, @"Failed test 2");
		
		// Test Element copy
		
		KTXMLElement *nsElement = [[[nsDoc rootElement] elementsForName:@"child"] objectAtIndex:0];
		KTXMLElement *nsElementCopy = [[nsElement copy] autorelease];
		
		STAssertTrue([nsElement parent] != nil, @"Failed CHECK 3");
		STAssertTrue([nsElementCopy parent] == nil, @"Failed CHECK 4");
		
		[nsElementCopy addAttribute:[KTXMLNode attributeWithName:@"type" stringValue:@"son"]];
		
		KTXMLNode *nsElementAttr = [nsElement attributeForName:@"type"];
		KTXMLNode *nsElementCopyAttr = [nsElementCopy attributeForName:@"type"];
		
		STAssertTrue(nsElementAttr == nil, @"Failed CHECK 5");
		STAssertTrue(nsElementCopyAttr != nil, @"Failed CHECK 6");
		
		KTXMLElement *ddElement = [[[ddDoc rootElement] elementsForName:@"child"] objectAtIndex:0];
		KTXMLElement *ddElementCopy = [[ddElement copy] autorelease];
		
		STAssertTrue([nsElement parent] != nil, @"Failed test 3");
		STAssertTrue([nsElementCopy parent] == nil, @"Failed test 4");
		
		[ddElementCopy addAttribute:[KTXMLNode attributeWithName:@"type" stringValue:@"son"]];
		
		KTXMLNode *ddElementAttr = [ddElement attributeForName:@"type"];
		KTXMLNode *ddElementCopyAttr = [ddElementCopy attributeForName:@"type"];
		
		STAssertTrue(ddElementAttr == nil, @"Failed test 5");
		STAssertTrue(ddElementCopyAttr != nil, @"Failed test 6");
		
		// Test Node copy
		
		KTXMLNode *nsAttr = [nsElement attributeForName:@"age"];
		KTXMLNode *nsAttrCopy = [[nsAttr copy] autorelease];
		
		STAssertTrue([nsAttr parent] != nil, @"Failed CHECK 7");
		STAssertTrue([nsAttrCopy parent] == nil, @"Failed CHECK 8");
		
		[nsAttrCopy setStringValue:@"5"];
		
		NSString *nsAttrValue = [nsAttr stringValue];
		NSString *nsAttrCopyValue = [nsAttrCopy stringValue];
		
		STAssertTrue([nsAttrValue isEqualToString:@"4"], @"Failed CHECK 9");
		STAssertTrue([nsAttrCopyValue isEqualToString:@"5"], @"Failed CHECK 10");
		
		KTXMLNode *ddAttr = [ddElement attributeForName:@"age"];
		KTXMLNode *ddAttrCopy = [[ddAttr copy] autorelease];
		
		STAssertTrue([ddAttr parent] != nil, @"Failed test 7");
		STAssertTrue([ddAttrCopy parent] == nil, @"Failed test 8");
		
		[ddAttrCopy setStringValue:@"5"];
		
		NSString *ddAttrValue = [ddAttr stringValue];
		NSString *ddAttrCopyValue = [ddAttrCopy stringValue];
		
		STAssertTrue([ddAttrValue isEqualToString:@"4"], @"Failed test 9");
		STAssertTrue([ddAttrCopyValue isEqualToString:@"5"], @"Failed test 10");
		
		[pool release];
	}

	-(void) testCData {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		// <?xml version="1.0"?>
		// <request>
		//   <category>
		//     <name><![CDATA[asdfdsfafasdfsf]]></name>
		//     <type><![CDATA[post]]></type>
		//   </category>
		// </request>
		
		NSMutableString *xmlStr = [NSMutableString stringWithCapacity:100];
		[xmlStr appendString:@"<?xml version=\"1.0\"?>"];
		[xmlStr appendString:@"<request>"];
		[xmlStr appendString:@"  <category>"];
		[xmlStr appendString:@"    <name><![CDATA[asdfdsfafasdfsf]]></name>"];
		[xmlStr appendString:@"    <type><![CDATA[post]]></type>"];
		[xmlStr appendString:@"  </category>"];
		[xmlStr appendString:@"</request>"];
		
		KTXMLDocument *ddDoc = [[KTXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
		
		[ddDoc release];
		
		[pool release];
	}

	-(void) testElements {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSMutableString *xmlStr = [NSMutableString stringWithCapacity:100];
		[xmlStr appendString:@"<?xml version=\"1.0\"?>"];
		[xmlStr appendString:@"<request>"];
		[xmlStr appendString:@"  <category>"];
		[xmlStr appendString:@"    <name>Jojo</name>"];
		[xmlStr appendString:@"    <type>Mama</type>"];
		[xmlStr appendString:@"  </category>"];
		[xmlStr appendString:@"</request>"];
		
		NSArray *children = nil;
		int i = 0;
		
		KTXMLDocument *nsDoc = [[KTXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
		
		children = [[nsDoc rootElement] children];
		for (i = 0; i < [children count]; i++) {
			KTXMLNode *child = [children objectAtIndex:i];
			
			if ([child kind] == KTXMLElementKind) {
				STAssertTrue([child isMemberOfClass:[KTXMLElement class]], @"Failed CHECK 1");
			}
		}
		[nsDoc release];
		
		KTXMLDocument *ddDoc = [[KTXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
		
		children = [[ddDoc rootElement] children];
		for (i = 0; i < [children count]; i++) {
			KTXMLNode *child = [children objectAtIndex:i];
			
			if ([child kind] == KTXMLElementKind) {
				STAssertTrue([child isMemberOfClass:[KTXMLElement class]], @"Failed test 1");
			}
		}
		[ddDoc release];
		
		[pool release];
	}

	-(void) testXPath {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSMutableString *xmlStr = [NSMutableString stringWithCapacity:100];
		[xmlStr appendString:@"<?xml version=\"1.0\"?>"];
		[xmlStr appendString:@"<menu xmlns=\"food.com\" xmlns:a=\"deusty.com\">"];
		[xmlStr appendString:@"  <salad>"];
		[xmlStr appendString:@"    <name>Ceasar</name>"];
		[xmlStr appendString:@"    <price>1.99</price>"];
		[xmlStr appendString:@"  </salad>"];
		[xmlStr appendString:@"  <pizza>"];
		[xmlStr appendString:@"    <name>Supreme</name>"];
		[xmlStr appendString:@"    <price>9.99</price>"];
		[xmlStr appendString:@"  </pizza>"];
		[xmlStr appendString:@"  <pizza>"];
		[xmlStr appendString:@"    <name>Three Cheese</name>"];
		[xmlStr appendString:@"    <price>7.99</price>"];
		[xmlStr appendString:@"  </pizza>"];
		[xmlStr appendString:@"  <beer tap=\"yes\"/>"];
		[xmlStr appendString:@"</menu>"];
		
		KTXMLDocument *nsDoc = [[KTXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
		KTXMLDocument *ddDoc = [[KTXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
		
		NSString *nsDocXPath = [nsDoc XPath]; // empty string
		NSString *ddDocXPath = [ddDoc XPath]; // empty string
		
		STAssertTrue([nsDocXPath isEqualToString:ddDocXPath], @"Failed test 1");
		
		KTXMLElement *nsMenu = [nsDoc rootElement];
		KTXMLElement *ddMenu = [ddDoc rootElement];
		
		NSString *nsMenuXPath = [nsMenu XPath];
		NSString *ddMenuXPath = [ddMenu XPath];
		
		STAssertTrue([nsMenuXPath isEqualToString:ddMenuXPath], @"Failed test 2");
		
		NSArray *nsChildren = [nsMenu children];
		NSArray *ddChildren = [ddMenu children];
		
		STAssertTrue([nsChildren count] == [ddChildren count], @"Failed CHECK 1");
		
		for (NSUInteger i = 0; i < [nsChildren count]; i++) {
			NSString *nsChildXPath = [[nsChildren objectAtIndex:i] XPath];
			NSString *ddChildXPath = [[ddChildren objectAtIndex:i] XPath];
			
			STAssertTrue([nsChildXPath isEqualToString:ddChildXPath], @"Failed test 3");
		}
		
		KTXMLElement *nsBeer = [[nsMenu elementsForName:@"beer"] objectAtIndex:0];
		KTXMLElement *ddBeer = [[ddMenu elementsForName:@"beer"] objectAtIndex:0];
		
		NSArray *nsAttributes = [nsBeer attributes];
		NSArray *ddAttributes = [ddBeer attributes];
		
		STAssertTrue([nsAttributes count] == [ddAttributes count], @"Failed CHECK 2");
		
		for (NSUInteger i = 0; i < [nsAttributes count]; i++) {
			NSString *nsAttrXPath = [[nsAttributes objectAtIndex:i] XPath];
			NSString *ddAttrXPath = [[ddAttributes objectAtIndex:i] XPath];
			
			STAssertTrue([nsAttrXPath isEqualToString:ddAttrXPath], @"Failed test 4: ns(%@) != dd(%@)", nsAttrXPath, ddAttrXPath);
		}
		
		NSArray *nsNamespaces = [nsMenu namespaces];
		NSArray *ddNamespaces = [ddMenu namespaces];
		
		STAssertTrue([nsNamespaces count] == [ddNamespaces count], @"Failed CHECK 3");
		
		for (NSUInteger i = 0; i < [nsNamespaces count]; i++) {
			NSString *nsNamespaceXPath = [[nsNamespaces objectAtIndex:i] XPath];
			NSString *ddNamespaceXPath = [[ddNamespaces objectAtIndex:i] XPath];
			STAssertTrue([nsNamespaceXPath isEqualToString:ddNamespaceXPath], @"Failed test 5");
		}
		
		[nsDoc release];
		[ddDoc release];
		
		KTXMLElement *nsElement1 = [KTXMLElement elementWithName:@"duck"];
		KTXMLElement *nsElement2 = [KTXMLElement elementWithName:@"quack"];
		[nsElement1 addChild:nsElement2];
		
		KTXMLElement *ddElement1 = [KTXMLElement elementWithName:@"duck"];
		KTXMLElement *ddElement2 = [KTXMLElement elementWithName:@"quack"];
		[ddElement1 addChild:ddElement2];
		
		NSString *nsElement1XPath = [nsElement1 XPath];
		NSString *ddElement1XPath = [ddElement1 XPath];
		
		STAssertTrue([nsElement1XPath isEqualToString:ddElement1XPath], @"Failed test 6: ns(%@) != dd(%@)", nsElement1XPath, ddElement1XPath);
		
		NSString *nsElement2XPath = [nsElement2 XPath];
		NSString *ddElement2XPath = [ddElement2 XPath];
		
		STAssertTrue([nsElement2XPath isEqualToString:ddElement2XPath], @"Failed test 7: ns(%@) != dd(%@)", nsElement2XPath, ddElement2XPath);
		
		KTXMLNode *nsAttr = [KTXMLNode attributeWithName:@"deusty" stringValue:@"designs"];
		KTXMLNode *ddAttr = [KTXMLNode attributeWithName:@"deusty" stringValue:@"designs"];
		
		STAssertTrue([[nsAttr XPath] isEqualToString:[ddAttr XPath]], @"Failed test 8");
		
		[pool release];
	}

	-(void) testNodesForXPath {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSMutableString *xmlStr = [NSMutableString stringWithCapacity:100];
		[xmlStr appendString:@"<?xml version=\"1.0\"?>"];
		[xmlStr appendString:@"<menu xmlns:a=\"tap\">"];
		[xmlStr appendString:@"  <salad>"];
		[xmlStr appendString:@"    <name>Ceasar</name>"];
		[xmlStr appendString:@"    <price>1.99</price>"];
		[xmlStr appendString:@"  </salad>"];
		[xmlStr appendString:@"  <pizza>"];
		[xmlStr appendString:@"    <name>Supreme</name>"];
		[xmlStr appendString:@"    <price>9.99</price>"];
		[xmlStr appendString:@"  </pizza>"];
		[xmlStr appendString:@"  <pizza>"];
		[xmlStr appendString:@"    <name>Three Cheese</name>"];
		[xmlStr appendString:@"    <price>7.99</price>"];
		[xmlStr appendString:@"  </pizza>"];
		[xmlStr appendString:@"  <a:beer delicious=\"yes\"/>"];
		[xmlStr appendString:@"</menu>"];
		
		NSError *err;
		KTXMLDocument *ddDoc = [[KTXMLDocument alloc] initWithXMLString:xmlStr options:0 error:nil];
				
		NSArray *ddTest0 = [ddDoc nodesForXPath:@"/menu/b:salad[1]" error:&err];
		STAssertNil(ddTest0, @"Failed test 0");
		
		NSArray *ddTest1 = [ddDoc nodesForXPath:@"/menu/salad[1]" error:&err];
		STAssertNotNil(ddTest1, @"Failed test 1");
		
		NSArray *ddTest2 = [ddDoc nodesForXPath:@"menu/pizza" error:&err];
		STAssertNotNil(ddTest2, @"Failed test 2");
		
		NSArray *ddTest3 = [ddDoc nodesForXPath:@"menu/a:beer/@delicious" error:&err];
		STAssertTrue([ddTest3 count], @"Failed test 3");
		
		NSString *ddYes = [[ddTest3 objectAtIndex:0] stringValue];
		STAssertNotNil(ddYes, @"Failed test 4");
		
		[ddDoc release];
		
		KTXMLElement *ddElement1 = [KTXMLElement elementWithName:@"duck"];
		KTXMLElement *ddElement2 = [KTXMLElement elementWithName:@"quack"];
		[ddElement1 addChild:ddElement2];
		
		NSArray *ddTest4 = [ddElement1 nodesForXPath:@"quack[1]" error:nil];
		STAssertNotNil(ddTest4, @"Failed test 5");
		
		[pool release];
	}

	-(void) testInsertChild {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		KTXMLElement *ddParent = [KTXMLElement elementWithName:@"parent"];
		KTXMLElement *ddChild2 = [KTXMLElement elementWithName:@"child2"];
		[ddParent insertChild:ddChild2 atIndex:0];
		
		//NSAssert([[nsParent XMLString] isEqualToString:[ddParent XMLString]], @"Failed test 1");
		
		KTXMLElement *ddChild0 = [KTXMLElement elementWithName:@"child0"];
		[ddParent insertChild:ddChild0 atIndex:0];
		
		//NSAssert([[nsParent XMLString] isEqualToString:[ddParent XMLString]], @"Failed test 2");
		
		KTXMLElement *ddChild1 = [KTXMLElement elementWithName:@"child1"];
		[ddParent insertChild:ddChild1 atIndex:1];
		
		//NSAssert([[nsParent XMLString] isEqualToString:[ddParent XMLString]], @"Failed test 3");
		
		KTXMLElement *ddChild3 = [KTXMLElement elementWithName:@"child3"];
		[ddParent insertChild:ddChild3 atIndex:3];
		
		//NSAssert([[nsParent XMLString] isEqualToString:[ddParent XMLString]], @"Failed test 4");
		
		//KTXMLElement *ddChild5 = [KTXMLElement elementWithName:@"child5"];
		//[ddParent insertChild:ddChild5 atIndex:5];  // Exception - index (5) beyond bounds (5)
		
		[pool release];
	}

	-(void) testElementSerialization {
		NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
		
		NSString *str = @"<soup spicy=\"no\">chicken noodle</soup>";
		NSError *err = nil;
		KTXMLElement *dde = [[[KTXMLElement alloc] initWithXMLString:str error:&err] autorelease];
		STAssertNotNil(dde, @"element is nil and should not be.");
		STAssertNil(err, @"Error is not nil and should be.");
		
		[pool release];
	}
	
@end
