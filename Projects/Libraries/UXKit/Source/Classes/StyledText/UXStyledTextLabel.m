
#import <UXKit/UXStyledTextLabel.h>
#import <UXKit/UXStyledNode.h>
#import <UXKit/UXStyledFrame.h>
#import <UXKit/UXStyledText.h>
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXTableView.h>

static const CGFloat kCancelHighlightThreshold = 4;

@implementation UXStyledTextLabel

	@synthesize text					= _text; 
	@synthesize font					= _font;
	@synthesize textColor				= _textColor;
	@synthesize highlightedTextColor	= _highlightedTextColor;
	@synthesize textAlignment			= _textAlignment;
	@synthesize contentInset			= _contentInset;
	@synthesize highlighted				= _highlighted;
	@synthesize highlightedNode			= _highlightedNode;


	#pragma mark SPI

	/*!
	UITableView looks for this function and crashes if it is not found when you select a cell
	*/
	-(BOOL) isHighlighted {
		return _highlighted;
	}

	-(void) setStyle:(UXStyle *)style forFrame:(UXStyledBoxFrame *)frame {
		if ([frame isKindOfClass:[UXStyledInlineFrame class]]) {
			UXStyledInlineFrame *inlineFrame = (UXStyledInlineFrame *)frame;
			while (inlineFrame.inlinePreviousFrame) {
				inlineFrame			= inlineFrame.inlinePreviousFrame;
			}
			while (inlineFrame) {
				inlineFrame.style	= style;
				inlineFrame			= inlineFrame.inlineNextFrame;
			}
		}
		else {
			frame.style = style;
		}
	}

	-(void) setHighlightedFrame:(UXStyledBoxFrame *)frame {
		if (frame != _highlightedFrame) {
			UXTableView *tableView			= (UXTableView *)[self ancestorOrSelfWithClass:[UXTableView class]];
			UXStyledBoxFrame *affectFrame		= frame ? frame : _highlightedFrame;
			NSString *className					= affectFrame.element.className;
			
			if (!className && [affectFrame.element isKindOfClass:[UXStyledLinkNode class]]) {
				className = @"linkText:";
			}
			
			if (className && [className rangeOfString:@":"].location != NSNotFound) {
				if (frame) {
					UXStyle *style	= [UXSTYLESHEET styleWithSelector:className forState:UIControlStateHighlighted];
					[self setStyle:style forFrame:frame];
					
					[_highlightedFrame release];
					_highlightedFrame	= [frame retain];
					
					[_highlightedNode release];
					_highlightedNode	= [frame.element retain];
					
					tableView.highlightedLabel = self;
				}
				else {
					UXStyle *style = [UXSTYLESHEET styleWithSelector:className forState:UIControlStateNormal];
					[self setStyle:style forFrame:_highlightedFrame];
					
					UX_SAFE_RELEASE(_highlightedFrame);
					UX_SAFE_RELEASE(_highlightedNode);
					tableView.highlightedLabel = nil;
				}
				[self setNeedsDisplay];
			}
		}
	}


	#pragma mark Accessibility

	-(NSString *) combineTextFromFrame:(UXStyledTextFrame *)fromFrame toFrame:(UXStyledTextFrame *)toFrame {
		NSMutableArray *strings = [NSMutableArray array];
		for (UXStyledTextFrame *frame = fromFrame; frame && frame != toFrame;
			 frame = (UXStyledTextFrame *)frame.nextFrame) {
			[strings addObject:frame.text];
		}
		return [strings componentsJoinedByString:@""];
	}

	-(void) addAccessibilityElementFromFrame:(UXStyledTextFrame *)fromFrame toFrame:(UXStyledTextFrame *)toFrame withEdges:(UIEdgeInsets)edges {
		CGRect rect = CGRectMake(edges.left, edges.top, edges.right - edges.left, edges.bottom - edges.top);
		
		UIAccessibilityElement *acc = [[[UIAccessibilityElement alloc] initWithAccessibilityContainer:self] autorelease];
		acc.accessibilityFrame		= CGRectOffset(rect, self.screenViewX, self.screenViewY);
		acc.accessibilityTraits		= UIAccessibilityTraitStaticText;
		if (fromFrame == toFrame) {
			acc.accessibilityLabel = fromFrame.text;
		}
		else {
			acc.accessibilityLabel = [self combineTextFromFrame:fromFrame toFrame:toFrame];
		}
		[_accessibilityElements addObject:acc];
	}

	-(UIEdgeInsets) edgesForRect:(CGRect)rect {
		return UIEdgeInsetsMake(rect.origin.y, rect.origin.x, rect.origin.y + rect.size.height, rect.origin.x + rect.size.width);
	}

	-(void) addAccessibilityElementsForNode:(UXStyledNode *)node {
		if ([node isKindOfClass:[UXStyledLinkNode class ]]) {
			UIAccessibilityElement *acc		= [[[UIAccessibilityElement alloc] initWithAccessibilityContainer:self] autorelease];
			UXStyledFrame *frame			= [_text getFrameForNode:node];
			acc.accessibilityFrame			= CGRectOffset(frame.bounds, self.screenViewX, self.screenViewY);
			acc.accessibilityTraits			= UIAccessibilityTraitLink;
			acc.accessibilityLabel			= [node outerText];
			[_accessibilityElements addObject:acc];
		}
		else if ([node isKindOfClass:[UXStyledTextNode class ]]) {
			UXStyledTextFrame *startFrame	= (UXStyledTextFrame *)[_text getFrameForNode:node];
			UIEdgeInsets edges				= [self edgesForRect:startFrame.bounds];
			
			UXStyledTextFrame *frame		= (UXStyledTextFrame *)startFrame.nextFrame;
			for (; [frame isKindOfClass:[UXStyledTextFrame class ]]; frame = (UXStyledTextFrame *)frame.nextFrame) {
				if (frame.bounds.origin.x < edges.left) {
					[self addAccessibilityElementFromFrame:startFrame toFrame:frame withEdges:edges];
					edges			= [self edgesForRect:frame.bounds];
					startFrame		= frame;
				}
				else {
					if (frame.bounds.origin.x + frame.bounds.size.width > edges.right) {
						edges.right = frame.bounds.origin.x + frame.bounds.size.width;
					}
					if (frame.bounds.origin.y + frame.bounds.size.height > edges.bottom) {
						edges.bottom = frame.bounds.origin.y + frame.bounds.size.height;
					}
				}
			}
			
			if (frame != startFrame) {
				[self addAccessibilityElementFromFrame:startFrame toFrame:frame withEdges:edges];
			}
		}
		else if ([node isKindOfClass:[UXStyledElement class ]]) {
			UXStyledElement *element = (UXStyledElement *)node;
			for (UXStyledNode *child = element.firstChild; child; child = child.nextSibling) {
				[self addAccessibilityElementsForNode:child];
			}
		}
	}

	-(NSMutableArray *) accessibilityElements {
		if (!_accessibilityElements) {
			_accessibilityElements = [[NSMutableArray alloc] init];
			[self addAccessibilityElementsForNode:_text.rootNode];
		}
		return _accessibilityElements;
	}


	#pragma mark Initializer

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_text					= nil;
			_font					= nil;
			_textColor				= nil;
			_highlightedTextColor	= nil;
			_textAlignment			= UITextAlignmentLeft;
			_contentInset			= UIEdgeInsetsZero;
			_highlighted			= NO;
			_highlightedNode		= nil;
			_highlightedFrame		= nil;
			_accessibilityElements	= nil;
			self.font				= UXSTYLEVAR(font);
			self.backgroundColor	= UXSTYLEVAR(backgroundColor);
			self.contentMode		= UIViewContentModeRedraw;
		}
		return self;
	}


	#pragma mark <NSObject>

	-(void) dealloc {
		_text.delegate = nil;
		UX_SAFE_RELEASE(_text);
		UX_SAFE_RELEASE(_font);
		UX_SAFE_RELEASE(_textColor);
		UX_SAFE_RELEASE(_highlightedTextColor);
		UX_SAFE_RELEASE(_highlightedNode);
		UX_SAFE_RELEASE(_highlightedFrame);
		UX_SAFE_RELEASE(_accessibilityElements);
		[super dealloc];
	}


	#pragma mark @UIResponder

	-(BOOL) canBecomeFirstResponder {
		return YES;
	}

	-(BOOL) becomeFirstResponder {
		BOOL became				= [super becomeFirstResponder];
		
		UIMenuController *menu	= [UIMenuController sharedMenuController];
		[menu setTargetRect:self.frame inView:self.superview];
		[menu setMenuVisible:YES animated:YES];
		
		self.highlighted = YES;
		return became;
	}

	-(BOOL) resignFirstResponder {
		self.highlighted	= NO;
		BOOL resigned		= [super resignFirstResponder];
		[[UIMenuController sharedMenuController] setMenuVisible:NO];
		return resigned;
	}

	-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		UITouch *touch	= [touches anyObject];
		CGPoint point	= [touch locationInView:self];
		point.x			-= _contentInset.left;
		point.y			-= _contentInset.top;
		
		UXStyledBoxFrame *frame = [_text hitTest:point];
		if (frame) {
			[self setHighlightedFrame:frame];
		}
		
		//[self performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.5];
		[super touchesBegan:touches withEvent:event];
	}

	-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
		[super touchesMoved:touches withEvent:event];
	}

	-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
		UXTableView *tableView = (UXTableView *)[self ancestorOrSelfWithClass:[UXTableView class ]];
		if (!tableView) {
			if (_highlightedNode) {
				[_highlightedNode performDefaultAction];
				[self setHighlightedFrame:nil];
			}
		}
		
		// We definitely don't want to call this if the label is inside a UXTableView, because
		// it winds up calling touchesEnded on the table twice, triggering the link twice
		[super touchesEnded:touches withEvent:event];
	}

	-(void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
		[super touchesCancelled:touches withEvent:event];
	}


	#pragma mark @UIView

	-(void) drawRect:(CGRect)rect {
		if (_highlighted) {
			[self.highlightedTextColor setFill];
		}
		else {
			[self.textColor setFill];
		}
		
		CGPoint origin = CGPointMake(rect.origin.x + _contentInset.left, rect.origin.y + _contentInset.top);
		[_text drawAtPoint:origin highlighted:_highlighted];
	}

	-(void) layoutSubviews {
		[super layoutSubviews];
		CGFloat newWidth = self.width - (_contentInset.left + _contentInset.right);
		if (newWidth != _text.width) {
			// Remove the highlighted node+frame when resizing the text
			self.highlightedNode = nil;
		}
		_text.width = newWidth;
		
	}

	-(CGSize) sizeThatFits:(CGSize)size {
		[self layoutIfNeeded];
		return CGSizeMake(_text.width + (_contentInset.left + _contentInset.right), _text.height + (_contentInset.top + _contentInset.bottom));
	}

	#pragma mark (UIAccessibilityContainer)

	-(id) accessibilityElementAtIndex:(NSInteger)index {
		return [[self accessibilityElements] objectAtIndex:index];
	}

	-(NSInteger) accessibilityElementCount {
		return [self accessibilityElements].count;
	}

	-(NSInteger) indexOfAccessibilityElement:(id)element {
		return [[self accessibilityElements] indexOfObject:element];
	}


	#pragma mark (UIResponderStandardEditActions)

	-(void) copy:(id)sender {
		NSString *text				= _text.rootNode.outerText;
		UIPasteboard *pasteboard	= [UIPasteboard generalPasteboard];
		[pasteboard setValue:text forPasteboardType:@"public.utf8-plain-text"];
	}


	#pragma mark <UXStyledTextDelegate>

	-(void) styledTextNeedsDisplay:(UXStyledText *)text {
		[self setNeedsDisplay];
	}


	#pragma mark API

	-(void) setText:(UXStyledText *)text {
		if (text != _text) {
			_text.delegate	= nil;
			[_text release];
			UX_SAFE_RELEASE(_accessibilityElements);
			_text			= [text retain];
			_text.delegate	= self;
			_text.font		= _font;
			[self setNeedsLayout];
			[self setNeedsDisplay];
		}
	}

	-(NSString *) html {
		return [_text description];
	}

	-(void) setHtml:(NSString *)html {
		self.text = [UXStyledText textFromXHTML:html];
	}

	-(void) setFont:(UIFont *)font {
		if (font != _font) {
			[_font release];
			_font = [font retain];
			_text.font = _font;
			[self setNeedsLayout];
		}
	}

	-(UIColor *) textColor {
		if (!_textColor) {
			_textColor = [UXSTYLEVAR(textColor) retain];
		}
		return _textColor;
	}

	-(void) setTextColor:(UIColor *)textColor {
		if (textColor != _textColor) {
			[_textColor release];
			_textColor = [textColor retain];
			[self setNeedsDisplay];
		}
	}

	-(UIColor *) highlightedTextColor {
		if (!_highlightedTextColor) {
			_highlightedTextColor = [UXSTYLEVAR(highlightedTextColor) retain];
		}
		return _highlightedTextColor;
	}

	-(void) setHighlightedNode:(UXStyledElement *)node {
		if (node != _highlightedNode) {
			if (!node) {
				[self setHighlightedFrame:nil];
			}
			else {
				[_highlightedNode release];
				_highlightedNode = [node retain];
			}
		}
	}

@end
