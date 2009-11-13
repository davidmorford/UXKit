
/*!
@project	UXCatalog
@header     MockDataSource.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

/*!
@class MockAddressBook
@superclass NSObject <UXModel>
@abstract
@discussion
*/
@interface MockAddressBook : NSObject <UXModel> {
	NSMutableArray *_delegates;
	NSMutableArray *_names;
	NSArray *_allNames;
	NSTimer *_fakeSearchTimer;
	NSTimeInterval _fakeSearchDuration;
}

	@property (nonatomic, retain) NSArray *names;
	@property (nonatomic) NSTimeInterval fakeSearchDuration;

	+(NSMutableArray *) fakeNames;

	-(id) initWithNames:(NSArray *)names;

	-(void) loadNames;
	-(void) search:(NSString *)text;

@end

@interface MockDataSource : UXSectionedDataSource {
	MockAddressBook *_addressBook;
}

	@property (nonatomic, readonly) MockAddressBook *addressBook;

@end

@interface MockSearchDataSource : UXSectionedDataSource {
	MockAddressBook *_addressBook;
}

	@property (nonatomic, readonly) MockAddressBook *addressBook;

	-(id) initWithDuration:(NSTimeInterval)duration;

@end
