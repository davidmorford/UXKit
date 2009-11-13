
/*!
@project	UXWebService
@header     SearchPhotosViewController.h
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

@class SearchResultsPhotoSource;

/*!
@class SearchPhotosViewController 
@superclass  UXViewController
@abstract Displays a text field where the user enters their search terms and a 
search button to perform the search, which will in turn push in Three20's 
thumbnail browsing view controller to show the search results.
@discussion 
*/
@interface SearchPhotosViewController : UXViewController {
	UITextField *queryField;
	SearchResultsPhotoSource *photoSource;
}

@end
