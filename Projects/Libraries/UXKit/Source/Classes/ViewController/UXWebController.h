
/*!
@project	UXKit
@header     UXWebController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXModelViewController.h>

@protocol UXWebControllerDelegate;

/*!
@class UXWebController
@superclass UXModelViewController <UIWebViewDelegate, UIActionSheetDelegate>
@abstract
@discussion
*/
@interface UXWebController : UXModelViewController <UIWebViewDelegate, UIActionSheetDelegate> {
	id <UXWebControllerDelegate> _delegate;
	UIWebView *_webView;
	UIToolbar *_toolbar;
	UIView *_headerView;
	UIBarButtonItem *_backButton;
	UIBarButtonItem *_forwardButton;
	UIBarButtonItem *_refreshButton;
	UIBarButtonItem *_stopButton;
	UIBarButtonItem *_activityItem;
	NSURL *_loadingURL;
}

	@property (nonatomic, assign) id <UXWebControllerDelegate> delegate;
	@property (nonatomic, readonly) NSURL *URL;
	@property (nonatomic, retain) UIView *headerView;
	@property (nonatomic, readonly) UIWebView *webView;
	@property (nonatomic, readonly) UIToolbar *toolbar;

	-(void) openURL:(NSURL *)aURL;
	-(void) openRequest:(NSURLRequest *)request;

@end

#pragma mark -

/*!
@protocol UXWebControllerDelegate <NSObject>
@abstract
@discussion
*/
@protocol UXWebControllerDelegate <NSObject>

	-(BOOL) webController:(UXWebController *)webController shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
	-(void) webControllerDidStartLoad:(UXWebController *)webController;
	-(void) webControllerDidFinishLoad:(UXWebController *)webController;
	-(void) webController:(UXWebController *)webController didFailLoadWithError:(NSError *)error;

@end