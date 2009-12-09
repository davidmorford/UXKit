
/*!
@project    UXKit
@header     UXNSIndexPath.h
*/

#import <UIKit/UIKit.h>

/*!
@category NSIndexPath (UXNSIndexPath)
@abstract
@discussion
*/
@interface NSIndexPath (UXNSIndexPath)

	@property (nonatomic, readonly) NSString *stringValue;
	@property (nonatomic, readonly) NSString *keyPath;
	@property (nonatomic, readonly) NSUInteger firstIndex;
	@property (nonatomic, readonly) NSUInteger lastIndex;

	#pragma mark -

	+(id) indexPathWithString:(NSString *)aString;

	#pragma mark -

	-(NSIndexPath *) indexPathByRemovingFirstIndex;
	-(NSString *) stringByJoiningIndexPathWithSeparator:(NSString *)aSeparator;

@end
