
/*!
@project    XMLKit
@header     KTXMLElement.h
@copyright  (c) 2008 Robbie Hanson / Deusty Designs LLC. All rights reserved.
@changes    (c) 2009 Semantap
*/

#import <Foundation/Foundation.h>
#import <XMLKit/KTXMLNode.h>

/*!
@class KTXMLElement
@superclass KTXMLNode
@abstract
@discussion
*/
@interface KTXMLElement : KTXMLNode

	-(id) initWithName:(NSString *)aName;
	-(id) initWithName:(NSString *)aName URI:(NSString *)URI;
	-(id) initWithName:(NSString *)aName stringValue:(NSString *)aValue;
	-(id) initWithXMLString:(NSString *)aString error:(NSError **)anError;

	#pragma mark Elements

	-(NSArray *) elementsForName:(NSString *)aName;
	-(NSArray *) elementsForLocalName:(NSString *)aLocalName URI:(NSString *)aURI;

	#pragma mark Attributes

	-(void) addAttribute:(KTXMLNode *)anAttributeNode;
	-(void) removeAttributeForName:(NSString *)aName;
	-(void) setAttributes:(NSArray *)anAttributeList;

	-(NSArray *) attributes;
	-(KTXMLNode *) attributeForName:(NSString *)aName;

	#pragma mark Namespaces

	-(NSArray *) namespaces;
	-(void) setNamespaces:(NSArray *)aNamespaceList;
	
	-(void) addNamespace:(KTXMLNode *)aNamespace;
	-(void) removeNamespaceForPrefix:(NSString *)aName;

	-(KTXMLNode *) namespaceForPrefix:(NSString *)prefix;
	-(KTXMLNode *) resolveNamespaceForName:(NSString *)aName;
	-(NSString *) resolvePrefixForNamespaceURI:(NSString *)namespaceURI;

	#pragma mark Children

	-(void) insertChild:(KTXMLNode *)aNode atIndex:(NSUInteger)anIndex;
	-(void) removeChildAtIndex:(NSUInteger)anIndex;
	-(void) setChildren:(NSArray *)aChildList;
	-(void) addChild:(KTXMLNode *)aNode;

@end

#pragma mark -

/*!
@class KTXMLElement (Additions)
@abstract
@discussion 
*/
@interface KTXMLElement (Additions)

	+(KTXMLElement *) elementWithName:(NSString *)aName xmlns:(NSString *)aNamespace;

	-(KTXMLElement *) elementForName:(NSString *)aName;
	-(KTXMLElement *) elementForName:(NSString *)aName xmlns:(NSString *)aNamespace;

	-(NSString *) xmlns;
	-(void) setXmlns:(NSString *)aNamespace;

	-(void) addAttributeWithName:(NSString *)aName stringValue:(NSString *)aValue;

@end

#pragma mark -

/*!
@class KTXMLElement (Internal)
@abstract ￼Internal interfaces. Do not use. 
@discussion ￼
*/
@interface KTXMLElement (Internal)

	+(id) nodeWithPrimitive:(xmlKindPtr)aNodeRef;

	-(id) initWithCheckedPrimitive:(xmlKindPtr)aNodeRef;
	-(id) initWithUncheckedPrimitive:(xmlKindPtr)aNodeRef;

	-(NSArray *) elementsWithName:(NSString *)aName uri:(NSString *)aURI;

	#pragma mark -

	+(KTXMLNode *) resolveNamespaceForPrefix:(NSString *)aPrefix atNode:(xmlNodePtr)aNodeRef;
	+(NSString *) resolvePrefixForURI:(NSString *)aURI atNode:(xmlNodePtr)aNodeRef;

@end
