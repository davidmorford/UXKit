
/*!
@project	UXKit
@header		UXNSObject.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
@category NSObject (UXNSObject)
@abstract
@discussion
*/
@interface NSObject (UXNSObject)

	/*!
	@abstract Additional performSelector signatures that support up to 7 arguments.
	*/
	-(id) performSelector:(SEL)aSelector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3;
	-(id) performSelector:(SEL)aSelector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4;
	-(id) performSelector:(SEL)aSelector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4 withObject:(id)p5;
	-(id) performSelector:(SEL)aSelector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4 withObject:(id)p5 withObject:(id)p6;
	-(id) performSelector:(SEL)aSelector withObject:(id)p1 withObject:(id)p2 withObject:(id)p3 withObject:(id)p4 withObject:(id)p5 withObject:(id)p6 withObject:(id)p7;
	-(id) performSelector:(SEL)aSelector withObjects:(NSArray *)anArgumentList;

	/*!
	@abstract Converts the object to a URL using UXURLMap.
	*/
	@property (nonatomic, readonly) NSString *URLValue;

	/*!
	@abstract Converts the object to a specially-named URL using UXURLMap.
	*/
	-(NSString *) URLValueWithName:(NSString *)aName;

@end
