
#import "StyledTextTestController.h"

@interface TextTestStyleSheet : UXDefaultStyleSheet
@end

@implementation TextTestStyleSheet

	-(UXStyle *) blueText {
		return [UXTextStyle styleWithColor:[UIColor blueColor] next:nil];
	}

	-(UXStyle *) largeText {
		return [UXTextStyle styleWithFont:[UIFont systemFontOfSize:32] next:nil];
	}

	-(UXStyle *) smallText {
		return [UXTextStyle styleWithFont:[UIFont systemFontOfSize:12] next:nil];
	}

	-(UXStyle *) floated {
		return [UXBoxStyle styleWithMargin:UIEdgeInsetsMake(0, 0, 5, 5)
								   padding:UIEdgeInsetsMake(0, 0, 0, 0)
								   minSize:CGSizeZero
								  position:UXPositionFloatLeft
									  next:nil];
	}

	-(UXStyle *) blueBox {
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:6] 
									   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(0, -5, -4, -6) 
									   next:[UXShadowStyle styleWithColor:[UIColor grayColor] blur:2 offset:CGSizeMake(1, 1) 
									   next:[UXSolidFillStyle styleWithColor:[UIColor colorWithHue:(210.0f / 360.0f)saturation:(50.0f / 100.0f)brightness:(100.0f / 100.0f)alpha:(100.0f / 100.0f)] 
									   next:[UXSolidBorderStyle styleWithColor:[UIColor grayColor] width:1 
									   next:nil]]]]];
	}
	-(UXStyle *) highlightBox {
		return [UXShapeStyle styleWithShape:[UXRoundedRectangleShape shapeWithRadius:4] 
									   next:[UXInsetStyle styleWithInset:UIEdgeInsetsMake(2, -5, -2, -5) 
									   next:[UXShadowStyle styleWithColor:[UIColor grayColor] blur:2 offset:CGSizeMake(1, 1) 
									   next:[UXSolidFillStyle styleWithColor:[UIColor colorWithHue:(45.0f / 360.0f)saturation:(50.0f / 100.0f)brightness:(100.0f / 100.0f)alpha:(100.0f / 100.0f)] 
									   next:[UXSolidBorderStyle styleWithColor:[UIColor colorWithHue:(45.0f / 360.0f)saturation:(25.0f / 100.0f)brightness:(100.0f / 100.0f)alpha:(100.0f / 100.0f)] width:0.5 
									   next:nil]]]]];
	}

	-(UXStyle *) inlineBox {
		return [UXSolidFillStyle styleWithColor:[UIColor blueColor] 
										   next:[UXBoxStyle styleWithPadding:UIEdgeInsetsMake(5, 13, 5, 13) 
										   next:[UXSolidBorderStyle styleWithColor:[UIColor blackColor] width:1 
										   next:nil]]];
	}

	-(UXStyle *) inlineBox2 {
		return [UXSolidFillStyle styleWithColor:[UIColor cyanColor] 
										   next:[UXBoxStyle styleWithMargin:UIEdgeInsetsMake(5, 50, 0, 50) padding:UIEdgeInsetsMake(0, 13, 0, 13) 
										   next:nil]];
	}

@end

@implementation StyledTextTestController

	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			[UXStyleSheet setGlobalStyleSheet:[[[TextTestStyleSheet alloc] init] autorelease]];
		}
		return self;
	}

	-(void) dealloc {
		[UXStyleSheet setGlobalStyleSheet:nil];
		[super dealloc];
	}


	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		
		NSString *kText = @"\
		This is a test of styled labels.  Styled labels support \
		<b>bold text</b>, <i>italic text</i>, <span class=\"blueText\">colored text</span>, \
		<span class=\"largeText\">font sizes</span>, \
		<span class=\"blueBox\">spans with backgrounds</span>, inline images \
		<img src=\"bundle://smiley.png\"/>, and <a href=\"http://www.google.com\">hyperlinks</a> you can \
		actually touch. URLs are automatically converted into links, like this: http://www.foo.com\
		<div>You can enclose blocks within an HTML div.</div>\
		Both line break characters\n\nand HTML line breaks<br/>are respected."                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      ;
		//  NSString* kText = @"<span class=\"largeText\">bah</span><span class=\"inlineBox\">hyper links</span>";
		//  NSString* kText = @"blah blah blah black sheep blah <span class=\"inlineBox\">\
		// //<img src=\"bundle://smiley.png\"/>hyperlinks</span> blah fun";
		//  NSString* kText = @"\
		// //<div class=\"inlineBox\"><div class=\"inlineBox2\">You can enclose blocks within an HTML div.</div></div>";
		//  NSString* kText = @"\
		// //<span class=\"inlineBox\"><span class=\"inlineBox2\">You can enclose blocks within an HTML div.</span></span>x";
		//  NSString* kText = @"<b>bold text</b> <span class=\"largeText\">font http://foo.com sizes</span>";
		//  NSString* kText = @"<a href=\"x\"><img src=\"bundle://smiley.png\"/></a> This is some text";
		//  NSString* kText = @"\
		// //<img src=\"bundle://smiley.png\" class=\"floated\" width=\"50\" height=\"50\"/>This \
		// //is a test of floats. This is still a test of floats.  This text will wrap itself around \
		// //the image that is being floated on the left.  I repeat, this is a test of floats.";
		//  NSString* kText = @"\
		// //<span class=\"floated\"><img src=\"bundle://smiley.png\" width=\"50\" height=\"50\"/></span>This \
		// //is a test of floats. This is still a test of floats.  This text will wrap itself around \
		// //the image that is being floated on the left.  I repeat, this is a test of floats.";
		//  NSString* kText = @"\
		// //<a>Bob Bobbers</a> <span class=\"smallText\">at 4:30 pm</span><br>Testing";
		
		// XXXjoe This illustrates the need to calculate a line's descender height as well @1079
		// NSString* kText = @"<span class=\"largeText\">bah</span> <span class=\"smallText\">humbug</span>";

		NSString *kMoreText = @"More Inline images for iPhone <img src=\"bundle://iphone.png\"/> and a Camera <img src=\"bundle://camera.png\"/> and <span class=\"highlightBox\">highlighted spans</span>";
		
		UXStyledTextLabel *label1	= [[[UXStyledTextLabel alloc] initWithFrame:self.view.bounds] autorelease];
		label1.font					= [UIFont systemFontOfSize:17];
		label1.text					= [UXStyledText textFromXHTML:kText lineBreaks:YES URLs:YES];
		label1.contentInset			= UIEdgeInsetsMake(10, 10, 10, 10);
		[label1 sizeToFit];
		[self.view addSubview:label1];

		UXStyledTextLabel *label1a = [[[UXStyledTextLabel alloc] initWithFrame:self.view.bounds] autorelease];
		label1a.font                = [UIFont systemFontOfSize:17];
		label1a.text                = [UXStyledText textFromXHTML:kMoreText];
		label1a.contentInset        = UIEdgeInsetsMake(10, 10, 10, 10);
		[label1a sizeToFit];
		label1a.top                 = label1.bottom + 10;
		[self.view addSubview:label1a];
	}

@end
