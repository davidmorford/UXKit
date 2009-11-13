
/*!
@project	UXWebService
@header     SearchResult.h
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

/*!
A domain-specific object that represents a single result from a search 
query. When the user performs a search, the UXModel will be loaded with 
a list of these 'SearchResult' objects.
*/
@interface SearchResult : NSObject {
    NSString *title;
    NSString *bigImageURL;
    NSString *thumbnailURL;
    CGSize bigImageSize;
}

	@property (nonatomic, retain) NSString *title;
	@property (nonatomic, retain) NSString *bigImageURL;
	@property (nonatomic, retain) NSString *thumbnailURL;
	@property (nonatomic, assign) CGSize bigImageSize;

@end
