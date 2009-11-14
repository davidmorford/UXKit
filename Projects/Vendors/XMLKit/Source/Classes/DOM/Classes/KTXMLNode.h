
/*!
@project    XMLKit
@header     KTXMLNode.h
@copyright  (c) 2008 Robbie Hanson / Deusty Designs LLC. All rights reserved.
@changes    (c) 2009 Semantap
*/

#import <libxml/tree.h>
#import <libxml/xpath.h>
#import <libxml/xpathInternals.h>
#import <Foundation/Foundation.h>

@class KTXMLDocument;

typedef NSUInteger KTXMLNodeKind;
enum {
	KTXMLInvalidKind                = 0,
	KTXMLDocumentKind               = XML_DOCUMENT_NODE,
	KTXMLElementKind                = XML_ELEMENT_NODE,
	KTXMLAttributeKind              = XML_ATTRIBUTE_NODE,
	KTXMLNamespaceKind              = XML_NAMESPACE_DECL,
	KTXMLProcessingInstructionKind  = XML_PI_NODE,
	KTXMLCommentKind                = XML_COMMENT_NODE,
	KTXMLTextKind                   = XML_TEXT_NODE,
	KTXMLDTDKind                    = XML_DTD_NODE,
	KTXMLEntityDeclarationKind      = XML_ENTITY_DECL,
	KTXMLAttributeDeclarationKind   = XML_ATTRIBUTE_DECL,
	KTXMLElementDeclarationKind     = XML_ELEMENT_DECL,
	KTXMLNotationDeclarationKind    = XML_NOTATION_NODE
};

enum {
	KTXMLNodeOptionsNone			= 0,
	KTXMLNodeExpandEmptyElement     = 1 << 1,
	KTXMLNodeCompactEmptyElement    = 1 << 2,
	KTXMLNodePrettyPrint            = 1 << 17,
};

/*!
@abstract KTXMLNode can represent several underlying types, such as xmlNodePtr, xmlDocPtr, xmlAttrPtr, xmlNsPtr, etc.
All of these are pointers to structures, and all of those structures start with a pointer, and a type.
The xmlKind struct is used as a generic structure, and a stepping stone.
We use it to check the type of a structure, and then perform the appropriate cast.
For example:
if (genericPtr->type == XML_ATTRIBUTE_NODE) {
	xmlAttrPtr attr = (xmlAttrPtr)genericPtr;
	// Do something with attr
}
*/
struct _xmlKind {
	void * ignore;
	xmlElementType type;
};
typedef struct _xmlKind *xmlKindPtr;

/*!
@abstract Most xml types all start with this standard structure. In fact, all do except the xmlNsPtr.
We will occasionally take advantage of this to simplify code when the code wouldn't vary from type to type.
Obviously, you cannnot cast a xmlNsPtr to a xmlStdPtr.
*/
struct _xmlStd {
	void *_private;
	xmlElementType type;
	const xmlChar *name;
	struct _xmlNode *children;
	struct _xmlNode *last;
	struct _xmlNode *parent;
	struct _xmlStd *next;
	struct _xmlStd *prev;
	struct _xmlDoc *doc;
};
typedef struct _xmlStd *xmlStdPtr;

#pragma mark -

/*!
@class KTXMLNode
@superclass NSObject <NSCopying>
@abstract
@var genericPtr		Every KTXML object is simply a wrapper around an underlying libxml node
@var  nsParentPtr	The xmlNsPtr type doesn't store a reference to it's parent. This is here 
					to fix that problem, and make this class more compatible with the NSXML classes
*/
@interface KTXMLNode : NSObject <NSCopying> {
	xmlKindPtr genericPtr;
	xmlNodePtr nsParentPtr;
}

	@property (nonatomic, assign) NSString *name;
	@property (nonatomic, readonly) KTXMLNodeKind kind;

	/*!
	@abstract Returns the content of the receiver as a string value.
	@discussion If the receiver is a node object of element kind, the content is that of any text-node children.
	This method recursively visits elements nodes and concatenates their text nodes in document order with
	no intervening spaces.
	*/
	@property (nonatomic, assign) NSString *stringValue;


	#pragma mark Tree Navigation

	/*!
	@abstract Returns the index of the receiver identifying its position relative to its sibling nodes.
	@discussion The first child node of a parent has an index of zero.
	*/
	@property (nonatomic, readonly) NSUInteger index;

	/*!
	@abstract Returns the nesting level of the receiver within the tree hierarchy.
	@discussion The root element of a document has a nesting level of one.
	*/
	@property (nonatomic, readonly) NSUInteger level;

	/*!
	@abstract Returns the KTXMLDocument object containing the root element and representing the XML document as a whole.
	@discussion If the receiver is a standalone node (that is, a node at the head of a detached branch of the tree), this
	method returns nil.
	*/
	@property (nonatomic, readonly) KTXMLDocument * rootDocument;

	/*!
	@abstract Returns the parent node of the receiver.
	@discussion Document nodes and standalone nodes (that is, the root of a detached branch of a tree) have no parent, and
	sending this message to them returns nil. A one-to-one relationship does not always exists between a parent and
	its children; although a namespace or attribute node cannot be a child, it still has a parent element.
	*/
	@property (nonatomic, readonly) KTXMLNode *parent;

	/*!
	@abstract Returns the number of child nodes the receiver has.
	@discussion For performance reasons, use this method instead of getting the count from the array returned by children.
	*/
	@property (nonatomic, readonly) NSUInteger childCount;

	/*!
	@abstract Returns an immutable array containing the child nodes of the receiver (as KTXMLNode objects).
	*/
	@property (nonatomic, readonly) NSArray *children;

	/*!
	@abstract Returns the previous KTXMLNode object that is a sibling node to the receiver.
	@discussion This object will have an index value that is one less than the receiver’s.
	If there are no more previous siblings (that is, other child nodes of the receiver’s parent) the method returns nil.
	*/
	@property (nonatomic, readonly) KTXMLNode *previousSibling;

	/*!
	@abstract Returns the next KTXMLNode object that is a sibling node to the receiver.
	@discusssion This object will have an index value that is one more than the receiver’s.
	If there are no more subsequent siblings (that is, other child nodes of the receiver’s parent) the
	method returns nil.
	*/
	@property (nonatomic, readonly) KTXMLNode *nextSibling;

	/*!
	@abstract Returns the previous KTXMLNode object in document order.
	@discussion You use this method to “walk” backward through the tree structure representing an XML document or document section.
	(Use nextNode to traverse the tree in the opposite direction.) Document order is the natural order that XML
	constructs appear in markup text. If you send this message to the first node in the tree (that is, the root element),
	nil is returned. KTXMLNode bypasses namespace and attribute nodes when it traverses a tree in document order.
	*/
	@property (nonatomic, readonly) KTXMLNode *previousNode;

	/*!
	@abstract Returns the next KTXMLNode object in document order.
	You use this method to “walk” forward through the tree structure representing an XML document or document section.
	(Use previousNode to traverse the tree in the opposite direction.) Document order is the natural order that XML
	constructs appear in markup text. If you send this message to the last node in the tree, nil is returned.
	KTXMLNode bypasses namespace and attribute nodes when it traverses a tree in document order.
	*/
	@property (nonatomic, readonly) KTXMLNode *nextNode;


	#pragma mark QNames

	/*!
	@abstract Returns the local name of the receiver.
	The local name is the part of a node name that follows a namespace-qualifying colon or the full name if
	there is no colon. For example, “chapter” is the local name in the qualified name “acme:chapter”.
	*/
	@property (nonatomic, readonly) NSString *localName;

	/*!
	@abstract Returns the prefix of the receiver’s name.
	@discussion The prefix is the part of a namespace-qualified name that precedes the colon.
	For example, “acme” is the local name in the qualified name “acme:chapter”.
	This method returns an empty string if the receiver’s name is not qualified by a namespace.
	*/
	@property (nonatomic, readonly) NSString *prefix;

	/*!
	@abstract Returns the URI associated with the receiver or set the URI identifying the source of this document.
	@discussion Pass nil to remove the current URI. A node’s URI is derived from its namespace or a document’s 
	URI; for documents, the URI comes either from the parsed XML or is explicitly set. You cannot change the URI 
	for a particular node other for than a namespace or document node.
	*/
	@property (nonatomic, assign) NSString *URI;
	

	#pragma mark Element Constructors

	+(id) elementWithName:(NSString *)aName;
	+(id) elementWithName:(NSString *)aName URI:(NSString *)aURI;
	+(id) elementWithName:(NSString *)aName stringValue:(NSString *)string;
	+(id) elementWithName:(NSString *)aName children:(NSArray *)aChildList attributes:(NSArray *)attributes;

	+(id) attributeWithName:(NSString *)aName stringValue:(NSString *)aStringValue;
	+(id) attributeWithName:(NSString *)aName URI:(NSString *)aURI stringValue:(NSString *)aStringValue;

	+(id) namespaceWithName:(NSString *)aName stringValue:(NSString *)aStringValue;

	+(id) processingInstructionWithName:(NSString *)aName stringValue:(NSString *)aStringValue;

	+(id) commentWithStringValue:(NSString *)aStringValue;

	+(id) textWithStringValue:(NSString *)aStringValue;


	#pragma mark -

	/*!
	@abstract Returns the child node of the receiver at the specified location.
	@discussion Returns a KTXMLNode object or nil if the receiver has no children.
	If the receive has children and index is out of bounds, an exception is raised.
	The receiver should be a KTXMLNode object representing a document, element, or document type declaration.
	The returned node object can represent an element, comment, text, or processing instruction.
	*/
	-(KTXMLNode *) childAtIndex:(NSUInteger)anIndex;

	/*!
	@abstract Detaches the receiver from its parent node.
	@discussion This method is applicable to KTXMLNode objects representing elements, text, comments, processing instructions,
	attributes, and namespaces. Once the node object is detached, you can add it as a child node of another parent.
	*/
	-(void) detach;

	-(NSString *) XPath;

	/*!
	@abstract Returns the local name from the specified qualified name.
	@discussion 
	"a:node"	-> "node"
	"a:a:node"	-> "a:node"
	"node"		-> "node"
	nil			-> nil
	*/
	+(NSString *) localNameForName:(NSString *)aName;

	/*!
	@abstract Extracts the prefix from the given name. If name is nil, or has no prefix, an empty string is returned.
	@discussion
	"a:atigeo.com"		-> "a"
	"a:a:atigeo.com"	-> "a"
	"node"				-> ""
	nil					-> ""
	*/
	+(NSString *) prefixForName:(NSString *)aName;


	#pragma mark Output

	-(NSString *) description;
	-(NSString *) XMLString;
	-(NSString *) XMLStringWithOptions:(NSUInteger)options;

	#pragma mark XPath/XQuery

	-(NSArray *) nodesForXPath:(NSString *)anXPath error:(NSError **)anError;

@end

#pragma mark -

/*!
@class KTXMLNode (Private)
@abstract ￼
@discussion ￼
*/
@interface KTXMLNode (Private)

	/*!
	@abstract Returns whether or not the node has a parent.
	Use this method instead of parent when you only need to ensure parent is nil.
	This prevents the unnecessary creation of a parent node wrapper.
	*/
	@property (readonly, nonatomic) BOOL hasParent;
	
	#pragma mark -

	/*!
	@abstract Returns a KTXML wrapper object for the given primitive node.
	If the wrapper object already exists, it is retained/autoreleased and returned.
	Otherwise a new object is alloc/init/autoreleased and returned.
	*/
	+(id) nodeWithPrimitive:(xmlKindPtr)aNodeRef;
	+(id) nodeWithPrimitive:(xmlKindPtr)aNodeRef nsParent:(xmlNodePtr)aParentPtr;
	

	#pragma mark -
	
	-(id) initWithCheckedPrimitive:(xmlKindPtr)aNodeRef;
	-(id) initWithUncheckedPrimitive:(xmlKindPtr)aNodeRef;

	
	-(id) initWithCheckedPrimitive:(xmlKindPtr)aNodeRef nsParent:(xmlNodePtr)aParentPtr;
	-(id) initWithUncheckedPrimitive:(xmlKindPtr)aNodeRef nsParent:(xmlNodePtr)aParentPtr;

	#pragma mark -

	/*!
	@abstract Returns whether or not the given node is of type xmlAttrPtr.
	*/
	+(BOOL) isXmlAttrPtr:(xmlKindPtr)aKindPtr;

	/*!
	@abstract Returns whether or not the genericPtr is of type xmlAttrPtr.
	*/
	-(BOOL) isXmlAttrPtr;

	/*!
	@abstract Returns whether or not the given node is of type xmlNodePtr.
	*/
	+(BOOL) isXmlNodePtr:(xmlKindPtr)aKindPtr;

	/*!
	@abstract Returns whether or not the genericPtr is of type xmlNodePtr.
	*/
	-(BOOL) isXmlNodePtr;

	/*!
	@abstract Returns whether or not the given node is of type xmlDocPtr.
	*/
	+(BOOL) isXmlDocPtr:(xmlKindPtr)aKindPtr;

	/*!
	@abstract Returns whether or not the genericPtr is of type xmlDocPtr.
	*/
	-(BOOL) isXmlDocPtr;

	/*!
	@abstract Returns whether or not the given node is of type xmlDtdPtr.
	*/
	+(BOOL) isXmlDtdPtr:(xmlKindPtr)aKindPtr;

	/*!
	@abstract Returns whether or not the genericPtr is of type xmlDtdPtr.
	*/
	-(BOOL) isXmlDtdPtr;

	/*!
	@abstract Returns whether or not the given node is of type xmlNsPtr.
	*/
	+(BOOL) isXmlNsPtr:(xmlKindPtr)aKindPtr;

	/*!
	@abstract Returns whether or not the genericPtr is of type xmlNsPtr.
	*/
	-(BOOL) isXmlNsPtr;
	

	#pragma mark -

	+(void) recursiveStripDocPointersFromNode:(xmlNodePtr)aNodeRef;

	/*!
	@abstract Detaches the given attribute from the given node.
	The attribute's surrounding prev/next pointers are properly updated to remove the attribute from the attr list.
	Then the attribute's parent, prev, next and doc pointers are destroyed.
	*/
	+(void) detachAttribute:(xmlAttrPtr)attr fromNode:(xmlNodePtr)aNodeRef;

	/*!
	@abstract Removes the given attribute from the given node.
	The attribute's surrounding prev/next pointers are properly updated to remove the attribute from the attr list.
	Then the attribute is freed if it's no longer being referenced.
	Otherwise, it's parent, prev, next and doc pointers are destroyed.
	*/
	+(void) removeAttribute:(xmlAttrPtr)attr fromNode:(xmlNodePtr)aNodeRef;

	/*!
	@abstract Removes all attributes from the given node.
	All attributes are either freed, or their parent, prev, next and doc pointers are properly destroyed.
	Upon return, the given node's properties pointer is NULL.
	*/
	+(void) removeAllAttributesFromNode:(xmlNodePtr)aNodeRef;

	/*!
	@abstract Detaches the given namespace from the given node.
	The namespace's surrounding next pointers are properly updated to remove the namespace from the node's nsDef list.
	Then the namespace's parent and next pointers are destroyed.
	*/
	+(void) detachNamespace:(xmlNsPtr)ns fromNode:(xmlNodePtr)aNodeRef;

	/*!
	@abstract Removes the given namespace from the given node.
	The namespace's surrounding next pointers are properly updated to remove the namespace from the nsDef list.
	Then the namespace is freed if it's no longer being referenced.
	Otherwise, it's nsParent and next pointers are destroyed.
	*/
	+(void) removeNamespace:(xmlNsPtr)ns fromNode:(xmlNodePtr)aNodeRef;

	/*!
	@abstract Removes all namespaces from the given node.
	All namespaces are either freed, or their nsParent and next pointers are properly destroyed.
	Upon return, the given node's nsDef pointer is NULL.
	*/
	+(void) removeAllNamespacesFromNode:(xmlNodePtr)aNodeRef;

	/*!
	@abstract Detaches the given child from the given node.
	The child's surrounding prev/next pointers are properly updated to remove the child from the node's children list.
	Then the child's parent, prev, next and doc pointers are destroyed.
	*/
	+(void) detachChild:(xmlNodePtr)child fromNode:(xmlNodePtr)aNodeRef;

	/*!
	@abstract Removes the given child from the given node.
	The child's surrounding prev/next pointers are properly updated to remove the child from the node's children list.
	Then the child is recursively freed if it's no longer being referenced.
	Otherwise, it's parent, prev, next and doc pointers are destroyed.
	During the recursive free, subnodes still being referenced are properly handled.
	*/
	+(void) removeChild:(xmlNodePtr)child fromNode:(xmlNodePtr)aNodeRef;

	/*!
	@abstract Removes all children from the given node.
	All children are either recursively freed, or their parent, prev, next and doc pointers are properly destroyed.
	Upon return, the given node's children pointer is NULL.
	During the recursive free, subnodes still being referenced are properly handled.
	*/
	+(void) removeAllChildrenFromNode:(xmlNodePtr)aNodeRef;

	/*!
	@abstract Removes the root element from the given document.
	*/
	+(void) removeAllChildrenFromDoc:(xmlDocPtr)aDocRef;


	#pragma mark -

	+(void) nodeFree:(xmlNodePtr)node;

	/*!
	@abstract Adds self to the node's retain list.
	This way we know the node is still being referenced, and it won't be improperly freed.
	*/
	-(void) nodeRetain;

	/*!
	@abstract Removes self from the node's retain list.
	If the node is no longer being referenced, and it's not still embedded within a heirarchy above, then
	the node is properly freed. This includes element nodes, which are recursively freed, detaching any subnodes
	that are still being referenced.
	*/
	-(void) nodeRelease;

	/*!
	@abstract Returns the last error encountered by libxml.
	@discussion Errors are caught in the MyErrorHandler method within KTXMLDocument.
	*/
	+(NSError *) lastError;

@end
