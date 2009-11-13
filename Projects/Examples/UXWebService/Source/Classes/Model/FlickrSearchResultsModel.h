
/*!
@project    
@header     FlickrSearchResultsModel.h
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>
#import "SearchResultsModel.h"

@class URLModelResponse;

/*!
@class FlickrSearchResultsModel
@superclass UXURLRequestModel <SearchResultsModel>
@abstract
@discussion
*/
@interface FlickrSearchResultsModel : UXURLRequestModel <SearchResultsModel> {
	URLModelResponse *responseProcessor;
	NSString *searchTerms;
	NSUInteger page;
}

@end
