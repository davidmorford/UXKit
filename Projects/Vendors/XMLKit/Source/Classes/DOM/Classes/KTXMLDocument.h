
/*!
@project    XMLKit
@header     KTXMLDocument.h
@copyright  (c) 2008 Robbie Hanson / Deusty Designs LLC. All rights reserved.
@changes    (c) 2009 Semantap
*/

#import <Foundation/Foundation.h>
#import <XMLKit/KTXMLNode.h>

@class KTXMLElement;

typedef NSUInteger KTXMLDocumentContentKind;
enum {
	KTXMLDocumentXMLKind = 0,
	KTXMLDocumentXHTMLKind,
	KTXMLDocumentHTMLKind,
	KTXMLDocumentTextKind
};

/*!
@class KTXMLDocument 
@superclass KTXMLNode
@abstract ￼
@discussion ￼
*/
@interface KTXMLDocument : KTXMLNode

	/*!
	@abstract Returns the root element of the receiver.
	*/
	@property (nonatomic, readonly) KTXMLElement *rootElement;

	#pragma mark -

	/*!
	@abstract Initializes and returns a KTXMLDocument object created from an NSData object.
	@discussion Returns an initialized KTXMLDocument object, or nil if initialization fails
	because of parsing errors or other reasons.
	*/
	-(id) initWithXMLString:(NSString *)aString options:(NSUInteger)aNask error:(NSError **)anError;

	/*!
	@abstract Initializes and returns a KTXMLDocument object created from an NSData object.
	@discussion Returns an initialized KTXMLDocument object, or nil if initialization fails
	because of parsing errors or other reasons.
	*/
	-(id) initWithData:(NSData *)aByteArray options:(NSUInteger)aMask error:(NSError **)anError;

	#pragma mark -

	-(NSData *) XMLData;
	-(NSData *) XMLDataWithOptions:(NSUInteger)options;

@end

#pragma mark -

/*!
@category KTXMLDocument (Internal)
@abstract
@discussion
*/
@interface KTXMLDocument ()

	+(id) nodeWithPrimitive:(xmlKindPtr)aNodeRef;

	-(id) initWithCheckedPrimitive:(xmlKindPtr)aNodeRef;
	-(id) initWithUncheckedPrimitive:(xmlKindPtr)aNodeRef;

@end
