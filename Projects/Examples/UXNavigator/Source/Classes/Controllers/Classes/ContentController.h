
/*!
@project    
@header     ContentController.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

typedef enum {
	ContentTypeNone,
	ContentTypeFood,
	ContentTypeNutrition,
	ContentTypeAbout,
	ContentTypeOrder,
} ContentType;

@interface ContentController : UXViewController {
	ContentType _contentType;
	NSString *_content;
	NSString *_text;
}

	@property (nonatomic, copy) NSString *content;
	@property (nonatomic, copy) NSString *text;

@end
