
#import <XMLKit/KTXMLDocument.h>
#import <XMLKit/XMLKit.h>

@interface KTXMLDocument (Unimplemented)
	/*
	@property (retain) NSString *characterEncoding;
	@property (retain) NSString *version;
	@property (assign) BOOL isStandalone;
	@property (assign) KTXMLDocumentContentKind documentContentKind;
	@property (retain) NSString *MIMEType;
	@property (retain) KTXMLDTD *DTD;
	*/

	//+(Class) replacementClassForClass:(Class)cls;

	//-(id) initWithContentsOfURL:(NSURL *)url options:(NSUInteger)mask error:(NSError **)error;
	//-(id) initWithRootElement:(KTXMLElement *)element;
	
	//-(void) setRootElement:(KTXMLNode *)root;

	//-(void) insertChild:(KTXMLNode *)child atIndex:(NSUInteger)index;
	//-(void) insertChildren:(NSArray *)children atIndex:(NSUInteger)index;
	//-(void) removeChildAtIndex:(NSUInteger)index;
	//-(void) setChildren:(NSArray *)children;
	//-(void) addChild:(KTXMLNode *)child;
	//-(void) replaceChildAtIndex:(NSUInteger)index withNode:(KTXMLNode *)node;

	//-(id) objectByApplyingXSLT:(NSData *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
	//-(id) objectByApplyingXSLTString:(NSString *)xslt arguments:(NSDictionary *)arguments error:(NSError **)error;
	//-(id) objectByApplyingXSLTAtURL:(NSURL *)xsltURL arguments:(NSDictionary *)argument error:(NSError **)error;

	//-(BOOL) validateAndReturnError:(NSError **)error;

@end

#pragma mark -

@implementation KTXMLDocument

	+(id) nodeWithPrimitive:(xmlKindPtr)nodePtr {
		if ((nodePtr == NULL) || (nodePtr->type != XML_DOCUMENT_NODE)) {
			return nil;
		}
		xmlDocPtr doc = (xmlDocPtr)nodePtr;
		if (doc->_private == NULL) {
			return [[[KTXMLDocument alloc] initWithCheckedPrimitive:nodePtr] autorelease];
		}
		else{
			return [[((KTXMLDocument *)(doc->_private))retain] autorelease];
		}
	}

	#pragma mark Initializers

	-(id) initWithUncheckedPrimitive:(xmlKindPtr)nodePtr {
		if ((nodePtr == NULL) || (nodePtr->type != XML_DOCUMENT_NODE)) {
			[self release];
			return nil;
		}
		
		xmlDocPtr doc = (xmlDocPtr)nodePtr;
		if (doc->_private == NULL) {
			return [self initWithCheckedPrimitive:nodePtr];
		}
		else {
			[self release];
			return [((KTXMLDocument *)(doc->_private))retain];
		}
	}

	-(id) initWithCheckedPrimitive:(xmlKindPtr)nodePtr {
		self = [super initWithCheckedPrimitive:nodePtr];
		return self;
	}

	-(id) initWithXMLString:(NSString *)string options:(NSUInteger)mask error:(NSError **)error {
		return [self initWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:mask error:error];
	}

	-(id) initWithData:(NSData *)data options:(NSUInteger)mask error:(NSError **)error {
		if ((data == nil) || ([data length] == 0)) {
			if (error) {
				*error = [NSError errorWithDomain:@"KTXMLErrorDomain" code:0 userInfo:nil];
			}
			[self release];
			return nil;
		}
		
		// Even though xmlKeepBlanksDefault(0) is called in KTXMLNode's initialize method,
		// this call seems to get reset on the iPhone: Therefore, call it again to be safe.
		xmlKeepBlanksDefault(0);
		
		xmlDocPtr doc = xmlParseMemory([data bytes], [data length]);
		if (doc == NULL) {
			if (error) {
				*error = [NSError errorWithDomain:@"KTXMLErrorDomain" code:1 userInfo:nil];
			}
			[self release];
			return nil;
		}
		return [self initWithCheckedPrimitive:(xmlKindPtr)doc];
	}

	#pragma mark -

	-(KTXMLElement *) rootElement {
		xmlDocPtr doc		= (xmlDocPtr)genericPtr;
		// doc->children is a list containing possibly comments, DTDs, etc...
		xmlNodePtr rootNode = xmlDocGetRootElement(doc);
		
		if (rootNode != NULL) {
			return [KTXMLElement nodeWithPrimitive:(xmlKindPtr)(rootNode)];
		}
		else {
			return nil;
		}
	}

	-(NSData *) XMLData {
		return [[self XMLString] dataUsingEncoding:NSUTF8StringEncoding];
	}

	-(NSData *) XMLDataWithOptions:(NSUInteger)options {
		return [[self XMLStringWithOptions:options] dataUsingEncoding:NSUTF8StringEncoding];
	}

@end
