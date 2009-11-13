
/*!
@project	UXKit    
@header     UXYouTubeView.h
@copyright  (c) 2009 Three20, (c) 2009 Semantap
*/

#import <UXKit/UXGlobal.h>

/*!
@class UXYouTubeView
@superclass UIWebView
@abstract
@discussion
*/
@interface UXYouTubeView : UIWebView {
	NSString *_URL;
}

	@property (nonatomic, copy) NSString *URL;

	-(id) initWithURL:(NSString *)URL;

@end
