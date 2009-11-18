
/*!
@project    UXKit
@header     UXManagedTableItem.h
@copyright	(c) 2009 Semantap
*/

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <UXKit/UXGlobal.h>

@protocol UXManagedTableItem <NSObject>
	@property (nonatomic, retain) NSManagedObject *object;
@end


/*!
@class UXTableItem
@superclass NSObject <NSCoding>
@abstract
@discussion
*/
@interface UXManagedTableItem : NSObject <UXManagedTableItem> {
	NSManagedObject *object;
}

	@property (nonatomic, retain) NSManagedObject *object;
	
	-(id) initWithManagedObject:(id)anObject;

@end

#pragma mark -

@interface UXManagedTableLinkedItem : UXManagedTableItem {
	NSString *URL;
	NSString *accessoryURL;
	NSDictionary *query;
}

	@property (nonatomic, copy) NSString *URL;
	@property (nonatomic, copy) NSString *accessoryURL;
	@property (nonatomic, copy) NSDictionary *query;

@end

#pragma mark -

@interface UXManagedTableTextItem : UXManagedTableLinkedItem {
	NSString *text;
}

	@property (nonatomic, copy) NSString *text;

	+(id) itemWithText:(NSString *)aTextString;
	+(id) itemWithText:(NSString *)aTextString URL:(NSString *)aURL;
	+(id) itemWithText:(NSString *)aTextString URL:(NSString *)aURL query:(NSDictionary *)aQuery;
	+(id) itemWithText:(NSString *)aTextString URL:(NSString *)aURL accessoryURL:(NSString *)anAccessoryURL;

@end
