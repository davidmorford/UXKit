
/*!
@project	UXWebService
@header     SearchResultsPhotoSource.h
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

@protocol SearchResultsModel;

/*!
Responsibilities:
- Load photos from the Internet (this responsibility is delegated to
the YahooSearchResultsModel via Objective-C forwarding).
- Vend UXPhoto instances to the photo browsing system.
- Tell the photo browsing system how many photos in total
are available on the server.
The UXPhotoSource protocol entails that you must also conform to the UXModel protocol.
Since we already have a useful UXModel in this demo app (YahooSearchResultsModel)
we do not want to reinvent the wheel here. Hence, I will just forward the UXModel
interface to the underlying model object.
*/
@interface SearchResultsPhotoSource : NSObject <UXPhotoSource> {
    id <SearchResultsModel> model;
    // Backing storage for UXPhotoSource properties.
    NSString *albumTitle;
    int totalNumberOfPhotos;    
}

	-(id) initWithModel:(id <SearchResultsModel>)aModel;

	/*!
	@abstract The model to which this PhotoSource forwards in order to 
	conform to the UXModel protocol.
	*/
	-(id <SearchResultsModel>) underlyingModel;

@end

#pragma mark -

/*!
@class PhotoItem 
@superclass NSObject <UXPhoto>
@abstract
@discussion
*/
@interface PhotoItem : NSObject <UXPhoto> {
	NSString *caption;
	NSString *imageURL;
	NSString *thumbnailURL;
	id <UXPhotoSource> photoSource;
	CGSize size;
	NSInteger index;
}

	@property (nonatomic, retain) NSString *imageURL;
	@property (nonatomic, retain) NSString *thumbnailURL;

	+(id)itemWithImageURL:(NSString *)imageURL thumbImageURL:(NSString *)thumbImageURL caption:(NSString *)caption size:(CGSize)size;

@end
