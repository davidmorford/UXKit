
/*!
@project    UXCatalog
@header     TestModel.h
@copyright  (c) Semantap 2009
*/

#import <UXKit/UXKit.h>


@protocol TestModel <UXModel>

	@property (nonatomic, readonly) NSArray *results;
	@property (nonatomic, readonly) NSUInteger remoteObjectCount;
	@property (nonatomic, retain) NSString *statusType;
	@property (nonatomic, retain) NSString *detailLevel;

@end

#pragma mark -

/*!
@class 
@superclass
@abstract
@discussion
*/
@interface TestModelItem : NSObject {
	NSString *listingID;
	NSString *statusType;
	NSDate *startDateTime;
	NSDate *endDateTime;
	NSString *bidCount;
    NSString *title;
    NSString *bigImageURL;
    NSString *thumbnailURL;
    CGSize bigImageSize;
}

	@property (nonatomic, retain) NSString *title;

	@property (nonatomic, retain) NSString *listingID;
	@property (nonatomic, retain) NSString *statusType;
	@property (nonatomic, retain) NSString *bidCount;
	
	@property (nonatomic, retain) NSDate *startDateTime;
	@property (nonatomic, retain) NSDate *endDateTime;
	
	@property (nonatomic, retain) NSString *bigImageURL;
	@property (nonatomic, retain) NSString *thumbnailURL;
	@property (nonatomic, assign) CGSize bigImageSize;

@end
