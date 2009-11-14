
#import <XMLKit/KTXMLNode.h>
#import <XMLKit/XMLKit.h>

@implementation KTXMLNode

	static void
	MyErrorHandler(void *userData, xmlErrorPtr error);

	#pragma mark Class Initializer

	-(void) initialize {
		static BOOL initialized = NO;
		if (!initialized) {
			// Redirect error output to our own function (don't clog up the console)
			initGenericErrorDefaultFunc(NULL);
			xmlSetStructuredErrorFunc(NULL, MyErrorHandler);
			
			// Tell libxml not to keep ignorable whitespace (such as node indentation, formatting, etc).
			// NSXML ignores such whitespace.
			// This also has the added benefit of taking up less RAM when parsing formatted XML documents.
			xmlKeepBlanksDefault(0);
			
			initialized = YES;
		}
	}


	#pragma mark Element Constructors

	+(id) elementWithName:(NSString *)name {
		return [[[KTXMLElement alloc] initWithName:name] autorelease];
	}

	+(id) elementWithName:(NSString *)name stringValue:(NSString *)string {
		return [[[KTXMLElement alloc] initWithName:name stringValue:string] autorelease];
	}

	+(id) elementWithName:(NSString *)name children:(NSArray *)children attributes:(NSArray *)attributes {
		KTXMLElement *result = [[[KTXMLElement alloc] initWithName:name] autorelease];
		[result setChildren:children];
		[result setAttributes:attributes];
		
		return result;
	}

	+(id) elementWithName:(NSString *)name URI:(NSString *)URI {
		return [[[KTXMLElement alloc] initWithName:name URI:URI] autorelease];
	}

	+(id) attributeWithName:(NSString *)name stringValue:(NSString *)stringValue {
		xmlAttrPtr attr = xmlNewProp(NULL, [name xmlChar], [stringValue xmlChar]);
		
		if (attr == NULL) {
			return nil;
		}
		
		return [[[KTXMLNode alloc] initWithCheckedPrimitive:(xmlKindPtr)attr] autorelease];
	}

	+(id) attributeWithName:(NSString *)name URI:(NSString *)URI stringValue:(NSString *)stringValue {
		xmlAttrPtr attr = xmlNewProp(NULL, [name xmlChar], [stringValue xmlChar]);
		
		if (attr == NULL) {
			return nil;
		}
		
		KTXMLNode *result = [[[KTXMLNode alloc] initWithCheckedPrimitive:(xmlKindPtr)attr] autorelease];
		[result setURI:URI];
		
		return result;
	}

	// If the user passes a nil or empty string name, they are trying to create a default namespace
	+(id) namespaceWithName:(NSString *)name stringValue:(NSString *)stringValue {
		const xmlChar *xmlName	= [name length] > 0 ? [name xmlChar] : NULL;
		xmlNsPtr ns				= xmlNewNs(NULL, [stringValue xmlChar], xmlName);
		if (ns == NULL) {
			return nil;
		}
		return [[[KTXMLNode alloc] initWithCheckedPrimitive:(xmlKindPtr)ns] autorelease];
	}

	+(id) processingInstructionWithName:(NSString *)name stringValue:(NSString *)stringValue {
		xmlNodePtr procInst = xmlNewPI([name xmlChar], [stringValue xmlChar]);
		if (procInst == NULL) {
			return nil;
		}
		return [[[KTXMLNode alloc] initWithCheckedPrimitive:(xmlKindPtr)procInst] autorelease];
	}

	+(id) commentWithStringValue:(NSString *)stringValue {
		xmlNodePtr comment = xmlNewComment([stringValue xmlChar]);
		if (comment == NULL) {
			return nil;
		}
		return [[[KTXMLNode alloc] initWithCheckedPrimitive:(xmlKindPtr)comment] autorelease];
	}

	+(id) textWithStringValue:(NSString *)stringValue {
		xmlNodePtr text = xmlNewText([stringValue xmlChar]);
		if (text == NULL) {
			return nil;
		}
		return [[[KTXMLNode alloc] initWithCheckedPrimitive:(xmlKindPtr)text] autorelease];
	}


	#pragma mark Class Constructors

	+(id) nodeWithPrimitive:(xmlKindPtr)nodePtr {
		if (nodePtr == NULL) {
			return nil;
		}
		// Warning: The _private variable is in a different location in the xmlNsPtr
		
		if ([[self class] isXmlNsPtr:nodePtr]) {
			xmlNsPtr ns = (xmlNsPtr)nodePtr;
			if (ns->_private != NULL) {
				return [[((KTXMLNode *)(ns->_private))retain] autorelease];
			}
		}
		else {
			xmlStdPtr node = (xmlStdPtr)nodePtr;
			if (node->_private != NULL) {
				return [[((KTXMLNode *)(node->_private))retain] autorelease];
			}
		}
		
		return [[[KTXMLNode alloc] initWithCheckedPrimitive:nodePtr] autorelease];
	}

	+(id) nodeWithPrimitive:(xmlKindPtr)nodePtr nsParent:(xmlNodePtr)parentPtr {
		if ((nodePtr == NULL) || (nodePtr->type != XML_NAMESPACE_DECL)) {
			return nil;
		}
		xmlNsPtr ns = (xmlNsPtr)nodePtr;
		if (ns->_private == NULL) {
			return [[[KTXMLNode alloc] initWithCheckedPrimitive:nodePtr nsParent:parentPtr] autorelease];
		}
		else{
			return [[((KTXMLNode *)(ns->_private))retain] autorelease];
		}
	}


	#pragma mark Initializers

	-(id) initWithUncheckedPrimitive:(xmlKindPtr)nodePtr {
		if (nodePtr == NULL) {
			[self release];
			return nil;
		}
		// Warning: The _private variable is in a different location in the xmlNsPtr
		if ([[self class] isXmlNsPtr:nodePtr]) {
			xmlNsPtr ns = (xmlNsPtr)nodePtr;
			if (ns->_private != NULL) {
				[self release];
				return [((KTXMLNode *)(ns->_private))retain];
			}
		}
		else {
			xmlStdPtr node = (xmlStdPtr)nodePtr;
			if (node->_private != NULL) {
				[self release];
				return [((KTXMLNode *)(node->_private))retain];
			}
		}
		
		return [self initWithCheckedPrimitive:nodePtr];
	}

	-(id) initWithCheckedPrimitive:(xmlKindPtr)nodePtr {
		BOOL maybeIsaSwizzle = [self isMemberOfClass:[KTXMLNode class]];
		
		if ((self = [super init])) {
			genericPtr = nodePtr;
			nsParentPtr = NULL;
			[self nodeRetain];
		}
		
		if (self && maybeIsaSwizzle) {
			if (nodePtr->type == XML_ELEMENT_NODE) {
				self->isa = [KTXMLElement class];
			}
			else if (nodePtr->type == XML_DOCUMENT_NODE)   {
				self->isa = [KTXMLDocument class];
			}
		}
		return self;
	}

	-(id) initWithUncheckedPrimitive:(xmlKindPtr)nodePtr nsParent:(xmlNodePtr)parentPtr {
		if ((nodePtr == NULL) || (nodePtr->type != XML_NAMESPACE_DECL)) {
			[self release];
			return nil;
		}
		
		xmlNsPtr ns = (xmlNsPtr)nodePtr;
		if (ns->_private == NULL) {
			return [self initWithCheckedPrimitive:nodePtr nsParent:parentPtr];
		}
		else {
			[self release];
			return [((KTXMLNode *)(ns->_private))retain];
		}
	}

	-(id) initWithCheckedPrimitive:(xmlKindPtr)nodePtr nsParent:(xmlNodePtr)parentPtr {
		BOOL maybeIsaSwizzle = [self isMemberOfClass:[KTXMLNode class]];
		
		if ((self = [super init])) {
			genericPtr	= nodePtr;
			nsParentPtr = parentPtr;
			[self nodeRetain];
		}
		
		if (maybeIsaSwizzle) {
			if (nodePtr->type == XML_ELEMENT_NODE) {
				self->isa = [KTXMLElement class];
			}
			else if (nodePtr->type == XML_DOCUMENT_NODE)   {
				self->isa = [KTXMLDocument class];
			}
		}
		return self;
	}

	/*!
	Check if genericPtr is NULL
	This may be the case if, eg, KTXMLElement calls [self release] from it's init method
	*/
	-(void) dealloc {
		if (genericPtr != NULL) {
			[self nodeRelease];
		}
		[super dealloc];
	}


	#pragma mark <NSCopying>

	/*!
	Todo: Do these copied object have the same _private ptr?
	If so, the pointer needs to be reset.
	*/
	-(id) copyWithZone:(NSZone *)zone {		
		if ([self isXmlDocPtr]) {
			xmlDocPtr copyDocPtr = xmlCopyDoc((xmlDocPtr)genericPtr, 1);
			return [[KTXMLDocument alloc] initWithUncheckedPrimitive:(xmlKindPtr)copyDocPtr];
		}
		
		if ([self isXmlNodePtr]) {
			xmlNodePtr copyNodePtr = xmlCopyNode((xmlNodePtr)genericPtr, 1);
			if ([self isKindOfClass:[KTXMLElement class]]) {
				return [[KTXMLElement alloc] initWithUncheckedPrimitive:(xmlKindPtr)copyNodePtr];
			}
			else{
				return [[KTXMLNode alloc] initWithUncheckedPrimitive:(xmlKindPtr)copyNodePtr];
			}
		}
		
		if ([self isXmlAttrPtr]) {
			xmlAttrPtr copyAttrPtr = xmlCopyProp(NULL, (xmlAttrPtr)genericPtr);
			return [[KTXMLNode alloc] initWithUncheckedPrimitive:(xmlKindPtr)copyAttrPtr];
		}
		
		if ([self isXmlNsPtr]) {
			xmlNsPtr copyNsPtr = xmlCopyNamespace((xmlNsPtr)genericPtr);
			return [[KTXMLNode alloc] initWithUncheckedPrimitive:(xmlKindPtr) copyNsPtr nsParent:nil];
		}
		
		if ([self isXmlDtdPtr]) {
			xmlDtdPtr copyDtdPtr = xmlCopyDtd((xmlDtdPtr)genericPtr);
			return [[KTXMLNode alloc] initWithUncheckedPrimitive:(xmlKindPtr)copyDtdPtr];
		}
		return nil;
	}


	#pragma mark Properties

	-(KTXMLNodeKind) kind {
		if (genericPtr != NULL) {
			return genericPtr->type;
		}
		else {
			return KTXMLInvalidKind;
		}
	}

	-(NSString *) name {
		if ([self isXmlNsPtr]) {
			xmlNsPtr ns = (xmlNsPtr)genericPtr;
			if (ns->prefix != NULL) {
				return [NSString stringWithUTF8String:((const char *)ns->prefix)];
			}
			else {
				return @"";
			}
		}
		else {
			const char *name = (const char *)((xmlStdPtr)genericPtr)->name;
			
			if (name == NULL) {
				return nil;
			}
			else {
				return [NSString stringWithUTF8String:name];
			}
		}
	}

	-(void) setName:(NSString *)aName {
		if ([self isXmlNsPtr]) {
			xmlNsPtr ns		= (xmlNsPtr)genericPtr;
			xmlFree((xmlChar *)ns->prefix);
			ns->prefix		= xmlStrdup([aName xmlChar]);
		}
		else {
			// The xmlNodeSetName function works for both nodes and attributes
			xmlNodeSetName((xmlNodePtr)genericPtr, [aName xmlChar]);
		}
	}

	-(NSString *) stringValue {
		if ([self isXmlNsPtr]) {
			return [NSString stringWithUTF8String:((const char *)((xmlNsPtr)genericPtr)->href)];
		}
		else if ([self isXmlAttrPtr])   {
			xmlAttrPtr attr = (xmlAttrPtr)genericPtr;
			if (attr->children != NULL) {
				return [NSString stringWithUTF8String:(const char *)attr->children->content];
			}
			return nil;
		}
		else if ([self isXmlNodePtr])   {
			xmlChar *content = xmlNodeGetContent((xmlNodePtr)genericPtr);
			NSString *result = [NSString stringWithUTF8String:(const char *)content];
			xmlFree(content);
			return result;
		}
		return nil;
	}

	-(void) setStringValue:(NSString *)string {
		if ([self isXmlNsPtr]) {
			xmlNsPtr ns = (xmlNsPtr)genericPtr;
			
			xmlFree((xmlChar *)ns->href);
			ns->href = xmlEncodeSpecialChars(NULL, [string xmlChar]);
		}
		else if ([self isXmlAttrPtr])   {
			xmlAttrPtr attr = (xmlAttrPtr)genericPtr;
			
			if (attr->children != NULL) {
				xmlChar *escapedString = xmlEncodeSpecialChars(attr->doc, [string xmlChar]);
				xmlNodeSetContent((xmlNodePtr)attr, escapedString);
				xmlFree(escapedString);
			}
			else {
				xmlNodePtr text		= xmlNewText([string xmlChar]);
				attr->children		= text;
			}
		}
		else if ([self isXmlNodePtr])   {
			xmlStdPtr node = (xmlStdPtr)genericPtr;
			
			// Setting the content of a node erases any existing child nodes.
			// Therefore, we need to remove them properly first.
			[[self class] removeAllChildrenFromNode:(xmlNodePtr)node];
			xmlChar *escapedString = xmlEncodeSpecialChars(node->doc, [string xmlChar]);
			xmlNodeSetContent((xmlNodePtr)node, escapedString);
			xmlFree(escapedString);
		}
	}


	#pragma mark Tree Navigation

	-(NSUInteger) index {
		if ([self isXmlNsPtr]) {
			// The xmlNsPtr has no prev pointer, so we have to search from the parent
			if (nsParentPtr == NULL) {
				return 0;
			}
			
			xmlNsPtr currentNs	= nsParentPtr->nsDef;
			NSUInteger result	= 0;
			while (currentNs != NULL) {
				if (currentNs == (xmlNsPtr)genericPtr) {
					return result;
				}
				result++;
				currentNs = currentNs->next;
			}
			return 0;
		}
		else {
			xmlStdPtr node		= ((xmlStdPtr)genericPtr)->prev;
			NSUInteger result	= 0;
			while (node != NULL) {
				result++;
				node = node->prev;
			}
			return result;
		}
	}

	-(NSUInteger) level {
		xmlNodePtr currentNode;
		if ([self isXmlNsPtr]) {
			currentNode = nsParentPtr;
		}
		else{
			currentNode = ((xmlStdPtr)genericPtr)->parent;
		}
		
		NSUInteger result = 0;
		while (currentNode != NULL) {
			result++;
			currentNode = currentNode->parent;
		}
		return result;
	}

	-(KTXMLDocument *) rootDocument {
		xmlStdPtr node;
		if ([self isXmlNsPtr]) {
			node = (xmlStdPtr)nsParentPtr;
		}
		else {
			node = (xmlStdPtr)genericPtr;
		}
		
		if (node == NULL) {
			return nil;
		}
		else{
			return [KTXMLDocument nodeWithPrimitive:(xmlKindPtr)node->doc];
		}
	}

	-(KTXMLNode *) parent {
		if ([self isXmlNsPtr]) {
			return [KTXMLNode nodeWithPrimitive:(xmlKindPtr)nsParentPtr];
		}
		xmlStdPtr node = (xmlStdPtr)genericPtr;
		
		return [KTXMLNode nodeWithPrimitive:(xmlKindPtr)node->parent];
	}

	-(NSUInteger) childCount {
		if (![self isXmlDocPtr] && ![self isXmlNodePtr] && ![self isXmlDtdPtr]) {
			return 0;
		}
		NSUInteger result	= 0;
		xmlNodePtr child	= ((xmlStdPtr)genericPtr)->children;
		while (child != NULL) {
			result++;
			child = child->next;
		}
		return result;
	}

	-(NSArray *) children {
		if (![self isXmlDocPtr] && ![self isXmlNodePtr] && ![self isXmlDtdPtr]) {
			return nil;
		}
		
		NSMutableArray *result	= [NSMutableArray array];
		xmlNodePtr child		= ((xmlStdPtr)genericPtr)->children;
		while (child != NULL) {
			[result addObject:[KTXMLNode nodeWithPrimitive:(xmlKindPtr)child]];
			child = child->next;
		}
		return [[result copy] autorelease];
	}

	-(KTXMLNode *) childAtIndex:(NSUInteger)index {
		if (![self isXmlDocPtr] && ![self isXmlNodePtr] && ![self isXmlDtdPtr]) {
			return nil;
		}
		
		NSUInteger i		= 0;
		xmlNodePtr child	= ((xmlStdPtr)genericPtr)->children;
		
		if (child == NULL) {
			// NSXML doesn't raise an exception if there are no children
			return nil;
		}
		
		while (child != NULL) {
			if (i == index) {
				return [KTXMLNode nodeWithPrimitive:(xmlKindPtr)child];
			}
			
			i++;
			child = child->next;
		}
		
		// NSXML version uses this same assertion
		KTCheck(NO, @"index (%u) beyond bounds (%u)", (unsigned)index, (unsigned)i);
		return nil;
	}

	-(KTXMLNode *) previousSibling {
		if ([self isXmlNsPtr]) {
			return nil;
		}
		
		xmlStdPtr node = (xmlStdPtr)genericPtr;
		
		return [KTXMLNode nodeWithPrimitive:(xmlKindPtr)node->prev];
	}

	-(KTXMLNode *) nextSibling {
		if ([self isXmlNsPtr]) {
			return nil;
		}
		
		xmlStdPtr node = (xmlStdPtr)genericPtr;
		
		return [KTXMLNode nodeWithPrimitive:(xmlKindPtr)node->next];
	}

	-(KTXMLNode *) previousNode {
		if ([self isXmlNsPtr] || [self isXmlAttrPtr]) {
			return nil;
		}
		
		// If the node has a previous sibling,
		// then we need the last child of the last child of the last child etc
		
		// Note: Try to accomplish this task without creating dozens of intermediate wrapper objects
		
		xmlStdPtr node = (xmlStdPtr)genericPtr;
		xmlStdPtr previousSibling = node->prev;
		
		if (previousSibling != NULL) {
			if (previousSibling->last != NULL) {
				xmlNodePtr lastChild = previousSibling->last;
				while (lastChild->last != NULL) {
					lastChild = lastChild->last;
				}
				
				return [KTXMLNode nodeWithPrimitive:(xmlKindPtr)lastChild];
			}
			else
			{
				// The previous sibling has no children, so the previous node is simply the previous sibling
				return [KTXMLNode nodeWithPrimitive:(xmlKindPtr)previousSibling];
			}
		}
		
		// If there are no previous siblings, then the previous node is simply the parent
		
		// Note: rootNode.parent == docNode
		
		if ((node->parent == NULL) || (node->parent->type == XML_DOCUMENT_NODE)) {
			return nil;
		}
		else{
			return [KTXMLNode nodeWithPrimitive:(xmlKindPtr)node->parent];
		}
	}

	-(KTXMLNode *) nextNode {
		if ([self isXmlNsPtr] || [self isXmlAttrPtr]) {
			return nil;
		}
		
		// If the node has children, then next node is the first child
		KTXMLNode *firstChild = [self childAtIndex:0];
		if (firstChild) {
			return firstChild;
		}
		
		// If the node has a next sibling, then next node is the same as next sibling
		
		KTXMLNode *nextSibling = [self nextSibling];
		if (nextSibling) {
			return nextSibling;
		}
		
		// There are no children, and no more siblings, so we need to get the next sibling of the parent.
		// If that is nil, we need to get the next sibling of the grandparent, etc.
		
		// Note: Try to accomplish this task without creating dozens of intermediate wrapper objects
		
		xmlNodePtr parent = ((xmlStdPtr)genericPtr)->parent;
		while (parent != NULL) {
			xmlNodePtr parentNextSibling = parent->next;
			if (parentNextSibling != NULL) {
				return [KTXMLNode nodeWithPrimitive:(xmlKindPtr)parentNextSibling];
			}
			else{
				parent = parent->parent;
			}
		}
		
		return nil;
	}

	-(void) detach {
		if ([self isXmlNsPtr]) {
			if (nsParentPtr != NULL) {
				[[self class] removeNamespace:(xmlNsPtr) genericPtr fromNode:nsParentPtr];
			}
			return;
		}
		
		xmlStdPtr node = (xmlStdPtr)genericPtr;
		
		if (node->parent == NULL) {
			return;
		}
		
		if ([self isXmlAttrPtr]) {
			[[self class] detachAttribute:(xmlAttrPtr) node fromNode:node->parent];
		}
		else if ([self isXmlNodePtr])   {
			[[self class] detachChild:(xmlNodePtr) node fromNode:node->parent];
		}
	}

	-(NSString *) XPath {
		NSMutableString *result = [NSMutableString stringWithCapacity:25];
		
		// Examples:
		// /rootElement[1]/subElement[4]/thisNode[2]
		// topElement/thisNode[2]
		
		xmlStdPtr node = NULL;
		
		if ([self isXmlNsPtr]) {
			node = (xmlStdPtr)nsParentPtr;
			if (node == NULL) {
				[result appendFormat:@"namespace::%@", [self name]];
			}
			else {
				[result appendFormat:@"/namespace::%@", [self name]];
			}
		}
		else if ([self isXmlAttrPtr])   {
			node = (xmlStdPtr)(((xmlAttrPtr)genericPtr)->parent);
			
			if (node == NULL) {
				[result appendFormat:@"@%@", [self name]];
			}
			else {
				[result appendFormat:@"/@%@", [self name]];
			}
		}
		else {
			node = (xmlStdPtr)genericPtr;
		}
		
		// Note: rootNode.parent == docNode
		
		while ((node != NULL) && (node->type != XML_DOCUMENT_NODE)) {
			if ((node->parent == NULL) && (node->doc == NULL)) {
				// We're at the top of the heirarchy, and there is no xml document.
				// Thus we don't use a leading '/', and we don't need an index.
				
				[result insertString:[NSString stringWithFormat:@"%s", node->name] atIndex:0];
			}
			else {
				// Find out what index this node is.
				// If it's the first node with this name, the index is 1.
				// If there are previous siblings with the same name, the index is greater than 1.
				
				int index			= 1;
				xmlStdPtr prevNode	= node->prev;
				while (prevNode != NULL) {
					if (xmlStrEqual(node->name, prevNode->name)) {
						index++;
					}
					prevNode = prevNode->prev;
				}
				[result insertString:[NSString stringWithFormat:@"/%s[%i]", node->name, index] atIndex:0];
			}
			node = (xmlStdPtr)node->parent;
		}
		return [[result copy] autorelease];
	}


	#pragma mark QNames

	-(NSString *) localName {
		if ([self isXmlNsPtr]) {
			// Strangely enough, the localName of a namespace is the prefix, and the prefix is an empty string
			xmlNsPtr ns = (xmlNsPtr)genericPtr;
			if (ns->prefix != NULL) {
				return [NSString stringWithUTF8String:((const char *)ns->prefix)];
			}
			else {
				return @"";
			}
		}
		return [[self class] localNameForName:[self name]];
	}

	-(NSString *) prefix {
		if ([self isXmlNsPtr]) {
			// Strangely enough, the localName of a namespace is the prefix, and the prefix is an empty string
			return @"";
		}
		return [[self class] prefixForName:[self name]];
	}

	-(NSString *) URI {
		if ([self isXmlAttrPtr]) {
			xmlAttrPtr attr = (xmlAttrPtr)genericPtr;
			if (attr->ns != NULL) {
				return [NSString stringWithUTF8String:((const char *)attr->ns->href)];
			}
		}
		else if ([self isXmlNodePtr])   {
			xmlNodePtr node = (xmlNodePtr)genericPtr;
			if (node->ns != NULL) {
				return [NSString stringWithUTF8String:((const char *)node->ns->href)];
			}
		}
		return nil;
	}

	-(void) setURI:(NSString *)URI {
		if ([self isXmlNodePtr]) {
			xmlNodePtr node = (xmlNodePtr)genericPtr;
			if (node->ns != NULL) {
				[[self class] removeNamespace:node->ns fromNode:node];
			}
			
			if (URI) {
				// Create a new xmlNsPtr, add it to the nsDef list, and make ns point to it
				xmlNsPtr ns = xmlNewNs(NULL, [URI xmlChar], NULL);
				ns->next = node->nsDef;
				node->nsDef = ns;
				node->ns = ns;
			}
		}
		else if ([self isXmlAttrPtr])   {
			xmlAttrPtr attr = (xmlAttrPtr)genericPtr;
			if (attr->ns != NULL) {
				// An attribute can only have a single namespace attached to it.
				// In addition, this namespace can only be accessed via the URI method.
				// There is no way, within the API, to get a KTXMLNode wrapper for the attribute's namespace.
				xmlFreeNs(attr->ns);
				attr->ns = NULL;
			}
			
			if (URI) {
				// Create a new xmlNsPtr, and make ns point to it
				xmlNsPtr ns = xmlNewNs(NULL, [URI xmlChar], NULL);
				attr->ns = ns;
			}
		}
	}

	+(NSString *) localNameForName:(NSString *)name {
		if (name) {
			NSRange range = [name rangeOfString:@":"];
			
			if (range.length != 0) {
				return [name substringFromIndex:(range.location + range.length)];
			}
			else{
				return name;
			}
		}
		return nil;
	}

	+(NSString *) prefixForName:(NSString *)name {
		if (name) {
			NSRange range = [name rangeOfString:@":"];
			
			if (range.length != 0) {
				return [name substringToIndex:range.location];
			}
		}
		return @"";
	}


	#pragma mark Output

	-(NSString *) description {
		return [self XMLStringWithOptions:0];
	}

	-(NSString *) XMLString {
		// Todo: Test XMLString for namespace node
		return [self XMLStringWithOptions:0];
	}

	-(NSString *) XMLStringWithOptions:(NSUInteger)options {
		// xmlSaveNoEmptyTags:
		// Global setting, asking the serializer to not output empty tags
		// as <empty/> but <empty></empty>. those two forms are undistinguishable
		// once parsed.
		// Disabled by default
		
		if (options & KTXMLNodeCompactEmptyElement) {
			xmlSaveNoEmptyTags = 0;
		}
		else{
			xmlSaveNoEmptyTags = 1;
		}
		
		int format = 0;
		if (options & KTXMLNodePrettyPrint) {
			format = 1;
			xmlIndentTreeOutput = 1;
		}
		
		xmlBufferPtr bufferPtr = xmlBufferCreate();
		if ([self isXmlNsPtr]) {
			xmlNodeDump(bufferPtr, NULL, (xmlNodePtr)genericPtr, 0, format);
		}
		else{
			xmlNodeDump(bufferPtr, ((xmlStdPtr)genericPtr)->doc, (xmlNodePtr)genericPtr, 0, format);
		}
		
		if ([self kind] == KTXMLTextKind) {
			NSString *result = [NSString stringWithUTF8String:(const char *)bufferPtr->content];
			
			xmlBufferFree(bufferPtr);
			
			return result;
		}
		else {
			NSMutableString *result = [NSMutableString stringWithUTF8String:(const char *)bufferPtr->content];
			CFStringTrimWhitespace((CFMutableStringRef)result);
			
			xmlBufferFree(bufferPtr);
			
			return result;
		}
	}


	#pragma mark XPath/XQuery

/*	-(NSArray *) nodesForXPath:(NSString *)xpath error:(NSError **)error {
		xmlXPathContextPtr xpathCtx;
		xmlXPathObjectPtr xpathObj;
		
		BOOL isTempDoc = NO;
		xmlDocPtr doc;
		
		if ([KTXMLNode isXmlDocPtr:genericPtr]) {
			doc = (xmlDocPtr)genericPtr;
		}
		else if ([KTXMLNode isXmlNodePtr:genericPtr])   {
			doc = ((xmlNodePtr)genericPtr)->doc;
			if (doc == NULL) {
				isTempDoc	= YES;
				doc			= xmlNewDoc(NULL);
				xmlDocSetRootElement(doc, (xmlNodePtr)genericPtr);
			}
		}
		else {
			return nil;
		}
		
		xpathCtx		= xmlXPathNewContext(doc);
		xpathCtx->node	= (xmlNodePtr)genericPtr;
		
		xmlNodePtr rootNode = (doc)->children;
		if (rootNode != NULL) {
			xmlNsPtr ns = rootNode->nsDef;
			while (ns != NULL) {
				xmlXPathRegisterNs(xpathCtx, ns->prefix, ns->href);
				ns = ns->next;
			}
		}
		
		xpathObj = xmlXPathEvalExpression([xpath xmlChar], xpathCtx);
		
		NSArray *result;
		
		if (xpathObj == NULL) {
			if (error) {
				*error = [[self class] lastError];
			}
			result = nil;
		}
		else {
			if (error) {
				*error = nil;
			}
			
			int count = xmlXPathNodeSetGetLength(xpathObj->nodesetval);
			
			if (count == 0) {
				result = [NSArray array];
			}
			else {
				NSMutableArray *mResult = [NSMutableArray arrayWithCapacity:count];
				int i;
				for (i = 0; i < count; i++) {
					xmlNodePtr node = xpathObj->nodesetval->nodeTab[i];
					[mResult addObject:[KTXMLNode nodeWithPrimitive:(xmlKindPtr)node]];
				}
				result = mResult;
			}
		}
		
		if (xpathObj) {
			xmlXPathFreeObject(xpathObj);
		}
		if (xpathCtx) {
			xmlXPathFreeContext(xpathCtx);
		}
		
		if (isTempDoc) {
			xmlUnlinkNode((xmlNodePtr)genericPtr);
			xmlFreeDoc(doc);
			
			// xmlUnlinkNode doesn't remove the doc ptr
			[[self class] recursiveStripDocPointersFromNode:(xmlNodePtr)genericPtr];
		}
		return result;
	}
*/

-(NSArray *) nodesForXPath:(NSString *)xpath error:(NSError **)error {
	xmlXPathContextPtr xpathCtx;
	xmlXPathObjectPtr xpathObj;
	
	BOOL isTempDoc = NO;
	xmlDocPtr doc;
	
	if ([KTXMLNode isXmlDocPtr:genericPtr]) {
		doc = (xmlDocPtr)genericPtr;
	}
	else if ([KTXMLNode isXmlNodePtr:genericPtr])  {
		doc = ((xmlNodePtr)genericPtr)->doc;
		if (doc == NULL) {
			isTempDoc	= YES;
			doc			= xmlNewDoc(NULL);
			xmlDocSetRootElement(doc, (xmlNodePtr)genericPtr);
		}
	}
	else {
		return nil;
	}
	
	xpathCtx		= xmlXPathNewContext(doc);
	xpathCtx->node	= (xmlNodePtr)genericPtr;
	
	xmlNodePtr rootNode = (doc)->children;
	if (rootNode != NULL) {
		xmlNsPtr ns = rootNode->nsDef;
		while (ns != NULL) {
			xmlXPathRegisterNs(xpathCtx, ns->prefix, ns->href);
			ns = ns->next;
		}
	}
	
	xpathObj = xmlXPathEvalExpression([xpath xmlChar], xpathCtx);
	
	NSArray *result;
	if (xpathObj == NULL) {
		if (error) {
			*error = [[self class] lastError];
		}
		result = nil;
	}
	else {
		if (error) {
			*error = nil;
		}
		
		int count = xmlXPathNodeSetGetLength(xpathObj->nodesetval);
		if (count == 0) {
			result = [NSArray array];
		}
		else {
			NSMutableArray *mResult = [NSMutableArray arrayWithCapacity:count];
			for (NSUInteger i = 0; i < count; i++) {
				xmlNodePtr node = xpathObj->nodesetval->nodeTab[i];
				[mResult addObject:[KTXMLNode nodeWithPrimitive:(xmlKindPtr)node]];
			}
			result = mResult;
		}
	}
	
	if (xpathObj) {
		xmlXPathFreeObject(xpathObj);
	}
	
	if (xpathCtx) {
		xmlXPathFreeContext(xpathCtx);
	}
	
	if (isTempDoc) {
		xmlUnlinkNode((xmlNodePtr)genericPtr);
		xmlFreeDoc(doc);
		// xmlUnlinkNode doesn't remove the doc ptr
		[[self class] recursiveStripDocPointersFromNode:(xmlNodePtr)genericPtr];
	}
	return result;
}


	#pragma mark Private

	+(BOOL) isXmlAttrPtr:(xmlKindPtr)kindPtr {
		return kindPtr->type == XML_ATTRIBUTE_NODE;
	}

	-(BOOL) isXmlAttrPtr {
		return [[self class] isXmlAttrPtr:genericPtr];
	}

	+(BOOL) isXmlNodePtr:(xmlKindPtr)kindPtr {
		xmlElementType type = kindPtr->type;
		switch (type) {
			case XML_ELEMENT_NODE:
			case XML_PI_NODE:
			case XML_COMMENT_NODE:
			case XML_TEXT_NODE:
			case XML_CDATA_SECTION_NODE: 
				return YES;
			default: 
				return NO;
		}
	}

	-(BOOL) isXmlNodePtr {
		return [[self class] isXmlNodePtr:genericPtr];
	}

	/*
	+(BOOL) isXmlDocPtr:(xmlKindPtr)kindPtr {
		return kindPtr->type == XML_DOCUMENT_NODE;
	}
	*/

	+(BOOL) isXmlDocPtr:(xmlKindPtr)kindPtr {
		return kindPtr->type == XML_DOCUMENT_NODE || kindPtr->type == XML_HTML_DOCUMENT_NODE;
	}


	-(BOOL) isXmlDocPtr {
		return [[self class] isXmlDocPtr:genericPtr];
	}

	+(BOOL) isXmlDtdPtr:(xmlKindPtr)kindPtr {
		return kindPtr->type == XML_DTD_NODE;
	}

	-(BOOL) isXmlDtdPtr {
		return [[self class] isXmlDtdPtr:genericPtr];
	}

	+(BOOL) isXmlNsPtr:(xmlKindPtr)kindPtr {
		return kindPtr->type == XML_NAMESPACE_DECL;
	}

	-(BOOL) isXmlNsPtr {
		return [[self class] isXmlNsPtr:genericPtr];
	}

	-(BOOL) hasParent {
		if ([self isXmlNsPtr]) {
			return (nsParentPtr != NULL);
		}
		xmlStdPtr node = (xmlStdPtr)genericPtr;
		return (node->parent != NULL);
	}


	#pragma mark -

	/*!
	@abstract R E A D   M E
	The memory management of these wrapper classes is straight-forward, but requires explanation.
	To understand the problem, consider the following situation:
	<root>
		<level1>
			<level2/>
		</level1>
	</root>
	Imagine the user has retained two KTXMLElements - one for root, and one for level2.
	Then they release the root element, but they want to hold onto the level2 element.
	We need to release root, and level1, but keep level2 intact until the user is done with it.
	Note that this is also how the NSXML classes work.
	The user will no longer be able to traverse up the tree from level2, but will be able to access all the normal
	information in level2, as well as any children, if there was any.
	
	So the first question is, how do we know if a libxml node is being referenced by a cocoa wrapper?
	In order to accomplish this, we take advantage of the node's _private variable.
	If the private variable is NULL, then the node isn't being directly referenced by any cocoa wrapper objects.
	If the private variable is NON-NULL, then the private variable points to the cocoa wrapper object.
	When a cocoa wrapper object is created, it points the private variable to itself (via nodeRetain),
	and when it's dealloced it sets the private variable back to NULL (via nodeRelease).

	With this simple technique, then given any libxml node, we can easily determine if it's still needed,
	or if we can free it:
	Is there a cocoa wrapper objects still directly referring to the node?
	If so, we can't free the node.
	Otherwise, does the node still have a parent?
	If so, then the node is still part of a heirarchy, and we can't free the node.

	To fully understand the parent restriction, consider the following scenario:
	Imagine the user extracts the level1 KTXMLElement from the root.
	The user reads the data, and the level1 KTXMLElement is autoreleased. The root is still retained.
	When the level1 KTXMLElement is dealloced, nodeRelease will be called, and the private variable will be set to NULL.
	Can we free the level1 node at this point?
	Of course not, because it's still within the root heirarchy, and the user is still using the root element.
	The following should be spelled out:
	If you call libxml's xmlFreeNode(), this method will free all linked attributes and children.
	So you can't blindly call this method, because you can't free nodes that are still being referenced.
	*/
	+(void) stripDocPointersFromAttr:(xmlAttrPtr)attr {
		xmlNodePtr child = attr->children;
		while (child != NULL) {
			child->doc	= NULL;
			child		= child->next;
		}
		attr->doc = NULL;
	}

	+(void) recursiveStripDocPointersFromNode:(xmlNodePtr)node {
		xmlAttrPtr attr = node->properties;
		while (attr != NULL) {
			[self stripDocPointersFromAttr:attr];
			attr = attr->next;
		}
		
		xmlNodePtr child = node->children;
		while (child != NULL) {
			[self recursiveStripDocPointersFromNode:child];
			child = child->next;
		}
		node->doc = NULL;
	}

	/*!
	@abstract This method will recursively free the given node, as long as the node is no longer being referenced.
	If the node is still being referenced, then it's parent, prev, next and doc pointers are destroyed.
	*/
	+(void) nodeFree:(xmlNodePtr)node {
		NSAssert1([self isXmlNodePtr:(xmlKindPtr)node], @"Wrong kind of node passed to nodeFree: %i", node->type);
		
		if (node->_private == NULL) {
			[self removeAllAttributesFromNode:node];
			[self removeAllNamespacesFromNode:node];
			[self removeAllChildrenFromNode:node];
			
			xmlFreeNode(node);
		}
		else {
			node->parent = NULL;
			node->prev   = NULL;
			node->next   = NULL;
			if (node->doc != NULL) {
				[self recursiveStripDocPointersFromNode:node];
			}
		}
	}
	

	#pragma mark -
	
	+(void) detachAttribute:(xmlAttrPtr)attr fromNode:(xmlNodePtr)node {
		// Update the surrounding prev/next pointers
		if (attr->prev == NULL) {
			if (attr->next == NULL) {
				node->properties = NULL;
			}
			else {
				node->properties = attr->next;
				attr->next->prev = NULL;
			}
		}
		else {
			if (attr->next == NULL) {
				attr->prev->next = NULL;
			}
			else {
				attr->prev->next = attr->next;
				attr->next->prev = attr->prev;
			}
		}
		
		// Nullify pointers
		attr->parent = NULL;
		attr->prev   = NULL;
		attr->next   = NULL;
		if (attr->doc != NULL) {
			[self stripDocPointersFromAttr:attr];
		}
	}

	+(void) removeAttribute:(xmlAttrPtr)attr fromNode:(xmlNodePtr)node {
		[self detachAttribute:attr fromNode:node];
		// Free the attr if it's no longer in use
		if (attr->_private == NULL) {
			xmlFreeProp(attr);
		}
	}

	+(void) removeAllAttributesFromNode:(xmlNodePtr)node {
		xmlAttrPtr attr = node->properties;
		
		while (attr != NULL) {
			xmlAttrPtr nextAttr = attr->next;
			
			// Free the attr if it's no longer in use
			if (attr->_private == NULL) {
				xmlFreeProp(attr);
			}
			else {
				attr->parent = NULL;
				attr->prev   = NULL;
				attr->next   = NULL;
				if (attr->doc != NULL) {
					[self stripDocPointersFromAttr:attr];
				}
			}
			attr = nextAttr;
		}
		node->properties = NULL;
	}

	+(void) detachNamespace:(xmlNsPtr)ns fromNode:(xmlNodePtr)node {
		// Namespace nodes have no previous pointer, so we have to search for the node
		xmlNsPtr previousNs = NULL;
		xmlNsPtr currentNs	= node->nsDef;
		while (currentNs != NULL) {
			if (currentNs == ns) {
				if (previousNs == NULL) {
					node->nsDef = currentNs->next;
				}
				else{
					previousNs->next = currentNs->next;
				}
				
				break;
			}
			
			previousNs	= currentNs;
			currentNs	= currentNs->next;
		}
		
		// Nullify pointers
		ns->next = NULL;
		if (node->ns == ns) {
			node->ns = NULL;
		}
		
		// We also have to nullify the nsParentPtr, which is in the cocoa wrapper object (if one exists)
		if (ns->_private != NULL) {
			KTXMLNode *node = (KTXMLNode *)ns->_private;
			node->nsParentPtr = NULL;
		}
	}

	+(void) removeNamespace:(xmlNsPtr)ns fromNode:(xmlNodePtr)node {
		[self detachNamespace:ns fromNode:node];
		// Free the ns if it's no longer in use
		if (ns->_private == NULL) {
			xmlFreeNs(ns);
		}
	}

	+(void) removeAllNamespacesFromNode:(xmlNodePtr)node {
		xmlNsPtr ns = node->nsDef;
		while (ns != NULL) {
			xmlNsPtr nextNs = ns->next;
			// We manage the nsParent pointer, which is in the cocoa wrapper object, so we have to nullify it ourself
			if (ns->_private != NULL) {
				KTXMLNode *node = (KTXMLNode *)ns->_private;
				node->nsParentPtr = NULL;
			}
			
			// Free the ns if it's no longer in use
			if (ns->_private == NULL) {
				xmlFreeNs(ns);
			}
			else {
				ns->next = NULL;
			}
			ns = nextNs;
		}
		
		node->nsDef = NULL;
		node->ns	= NULL;
	}
	

	#pragma mark -

	/*!
	@abstract Detaches the given child from the given node.
	The child's surrounding prev/next pointers are properly updated to remove the child from the node's children list.
	Then, if flag is YES, the child's parent, prev, next and doc pointers are destroyed.
	*/
	+(void) detachChild:(xmlNodePtr)child fromNode:(xmlNodePtr)node andNullifyPointers:(BOOL)flag {
		// Update the surrounding prev/next pointers
		if (child->prev == NULL) {
			if (child->next == NULL) {
				node->children	= NULL;
				node->last		= NULL;
			}
			else {
				node->children		= child->next;
				child->next->prev	= NULL;
			}
		}
		else {
			if (child->next == NULL) {
				node->last			= child->prev;
				child->prev->next	= NULL;
			}
			else {
				child->prev->next = child->next;
				child->next->prev = child->prev;
			}
		}
		
		if (flag) {
			// Nullify pointers
			child->parent = NULL;
			child->prev   = NULL;
			child->next   = NULL;
			if (child->doc != NULL) {
				[self recursiveStripDocPointersFromNode:child];
			}
		}
	}

	+(void) detachChild:(xmlNodePtr)child fromNode:(xmlNodePtr)node {
		[self detachChild:child fromNode:node andNullifyPointers:YES];
	}

	+(void) removeChild:(xmlNodePtr)child fromNode:(xmlNodePtr)node {
		// We perform a wee bit of optimization here.
		// Imagine that we're removing the root element of a big tree, and none of the elements are retained.
		// If we simply call detachChild:fromNode:, this will traverse the entire tree, nullifying doc pointers.
		// Then, when we call nodeFree:, it will again traverse the entire tree, freeing all the nodes.
		// To avoid this double traversal, we skip the nullification step in the detach method, and let nodeFree do it.
		[self detachChild:child fromNode:node andNullifyPointers:NO];
		
		// Free the child recursively if it's no longer in use
		[self nodeFree:child];
	}

	+(void) removeAllChildrenFromNode:(xmlNodePtr)node {
		xmlNodePtr child = node->children;
		while (child != NULL) {
			xmlNodePtr nextChild = child->next;
			// Free the child recursively if it's no longer in use
			[self nodeFree:child];
			child = nextChild;
		}
		node->children	= NULL;
		node->last		= NULL;
	}

	+(void) removeAllChildrenFromDoc:(xmlDocPtr)doc {
		xmlNodePtr child = doc->children;
		
		while (child != NULL) {
			xmlNodePtr nextChild = child->next;
			
			if (child->type == XML_ELEMENT_NODE) {
				// Remove child from list of children
				if (child->prev != NULL) {
					child->prev->next = child->next;
				}
				if (child->next != NULL) {
					child->next->prev = child->prev;
				}
				if (doc->children == child) {
					doc->children = child->next;
				}
				if (doc->last == child) {
					doc->last = child->prev;
				}
				
				// Free the child recursively if it's no longer in use
				[self nodeFree:child];
			}
			else {
				// Leave comments and DTD's embedded in the doc's child list.
				// They will get freed in xmlFreeDoc.
			}
			child = nextChild;
		}
	}


	#pragma mark -

	-(void) nodeRetain {
		// Warning: The _private variable is in a different location in the xmlNsPtr
		if ([self isXmlNsPtr]) {
			((xmlNsPtr)genericPtr)->_private = self;
		}
		else{
			((xmlStdPtr)genericPtr)->_private = self;
		}
	}

	-(void) nodeRelease {
		// Check to see if the node can be released.
		// Did you read the giant readme comment section above?
		// Warning: The _private variable is in a different location in the xmlNsPtr
		
		if ([self isXmlNsPtr]) {
			xmlNsPtr ns		= (xmlNsPtr)genericPtr;
			ns->_private	= NULL;
			if (nsParentPtr == NULL) {
				xmlFreeNs(ns);
			}
			else {
				// The node still has a parent, so it's still in use
			}
		}
		else {
			xmlStdPtr node = (xmlStdPtr)genericPtr;
			node->_private = NULL;
			
			if (node->parent == NULL) {
				if ([self isXmlAttrPtr]) {
					xmlFreeProp((xmlAttrPtr)genericPtr);
				}
				else if ([self isXmlDtdPtr])   {
					xmlFreeDtd((xmlDtdPtr)genericPtr);
				}
				else if ([self isXmlDocPtr])   {
					[[self class] removeAllChildrenFromDoc:(xmlDocPtr)genericPtr];
					xmlFreeDoc((xmlDocPtr)genericPtr);
				}
				else {
					[[self class] nodeFree:(xmlNodePtr)genericPtr];
				}
			}
			else {
				// The node still has a parent, so it's still in use
			}
		}
	}

	+(NSError *) lastError {
		NSValue *lastErrorValue = [[[NSThread currentThread] threadDictionary] objectForKey:KTLastErrorKey];
		if (lastErrorValue) {
			xmlError lastError;
			[lastErrorValue getValue:&lastError];
			
			int errCode			= lastError.code;
			NSString *errMsg	= [[NSString stringWithFormat:@"%s", lastError.message] trimWhitespace];
			NSDictionary *info	= [NSDictionary dictionaryWithObject:errMsg forKey:NSLocalizedDescriptionKey];
			
			return [NSError errorWithDomain:@"KTXMLErrorDomain" code:errCode userInfo:info];
		}
		else
		{
			return nil;
		}
	}

	#pragma mark -

	static void
	MyErrorHandler(void *userData, xmlErrorPtr error) {
		// This method is called by libxml when an error occurs.
		// We register for this error in the initialize method below.
		
		// Extract error message and store in the current thread's dictionary.
		// This ensure's thread safey, and easy access for all other KTXML classes.
		if (error == NULL) {
			[[[NSThread currentThread] threadDictionary] removeObjectForKey:KTLastErrorKey];
		}
		else {
			NSValue *errorValue = [NSValue valueWithBytes:error objCType:@encode(xmlError)];
			[[[NSThread currentThread] threadDictionary] setObject:errorValue forKey:KTLastErrorKey];
		}
	}

@end
