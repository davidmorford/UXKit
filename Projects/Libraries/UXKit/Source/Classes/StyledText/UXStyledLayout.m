
#import <UXKit/UXStyledLayout.h>
#import <UXKit/UXStyledNode.h>
#import <UXKit/UXStyledFrame.h>
#import <UXKit/UXDefaultStyleSheet.h>

@implementation UXStyledLayout

	@synthesize width		= _width;
	@synthesize height		= _height; 
	@synthesize rootFrame	= _rootFrame;
	@synthesize font		= _font;
	@synthesize invalidImages = _invalidImages;

	#pragma mark SPI

	-(UIFont *) boldVersionOfFont:(UIFont *)font {
		return [UIFont boldSystemFontOfSize:font.pointSize];
	}

	-(UIFont *) italicVersionOfFont:(UIFont *)font {
		return [UIFont italicSystemFontOfSize:font.pointSize];
	}

	-(UIFont *) boldFont {
		if (!_boldFont) {
			_boldFont = [[self boldVersionOfFont:self.font] retain];
		}
		return _boldFont;
	}

	-(UIFont *) italicFont {
		if (!_italicFont) {
			_italicFont = [[self italicVersionOfFont:self.font] retain];
		}
		return _italicFont;
	}

	-(UXStyle *) linkStyle {
		if (!_linkStyle) {
			_linkStyle = [UXSTYLEWITHSELECTOR(linkText:) retain];
		}
		return _linkStyle;
	}

	-(UXStyledNode *) findLastNode:(UXStyledNode *)aNode {
		UXStyledNode *lastNode = nil;
		while (aNode) {
			if ([aNode isKindOfClass:[UXStyledElement class]]) {
				UXStyledElement *element = (UXStyledElement *)aNode;
				lastNode = [self findLastNode:element.firstChild];
			}
			else {
				lastNode = aNode;
			}
			aNode = aNode.nextSibling;
		}
		return lastNode;
	}

	-(UXStyledNode *) lastNode {
		if (!_lastNode) {
			_lastNode = [self findLastNode:_rootNode];
		}
		return _lastNode;
	}

	-(void) offsetFrame:(UXStyledFrame *)frame by:(CGFloat)y {
		frame.y += y;
		
		if ([frame isKindOfClass:[UXStyledInlineFrame class]]) {
			UXStyledInlineFrame *inlineFrame	= (UXStyledInlineFrame *)frame;
			UXStyledFrame *child				= inlineFrame.firstChildFrame;
			while (child) {
				[self offsetFrame:child by:y];
				child = child.nextFrame;
			}
		}
	}

	-(void) expandLineWidth:(CGFloat)width {
		_lineWidth += width;
		UXStyledInlineFrame *inlineFrame = _inlineFrame;
		while (inlineFrame) {
			inlineFrame.width += width;
			inlineFrame = inlineFrame.inlineParentFrame;
		}
	}

	-(void) inflateLineHeight:(CGFloat)height {
		if (height > _lineHeight) {
			_lineHeight = height;
		}
		if (_inlineFrame) {
			UXStyledInlineFrame *inlineFrame = _inlineFrame;
			while (inlineFrame) {
				if (height > inlineFrame.height) {
					inlineFrame.height = height;
				}
				inlineFrame = inlineFrame.inlineParentFrame;
			}
		}
	}

	-(void) addFrame:(UXStyledFrame *)frame {
		if (!_rootFrame) {
			_rootFrame = [frame retain];
		}
		else if (_topFrame) {
			if (!_topFrame.firstChildFrame) {
				_topFrame.firstChildFrame = frame;
			}
			else {
				_lastFrame.nextFrame = frame;
			}
		}
		else {
			_lastFrame.nextFrame = frame;
		}
		_lastFrame = frame;
	}

	-(void) pushFrame:(UXStyledBoxFrame *)frame {
		[self addFrame:frame];
		frame.parentFrame	= _topFrame;
		_topFrame			= frame;
	}

	-(void) popFrame {
		_lastFrame	= _topFrame;
		_topFrame	= _topFrame.parentFrame;
	}

	-(UXStyledFrame *) addContentFrame:(UXStyledFrame *)frame width:(CGFloat)width {
		[self addFrame:frame];
		if (!_lineFirstFrame) {
			_lineFirstFrame = frame;
		}
		_x += width;
		return frame;
	}

	-(void) addContentFrame:(UXStyledFrame *)frame width:(CGFloat)width height:(CGFloat)height {
		frame.bounds = CGRectMake(_x, _height, width, height);
		[self addContentFrame:frame width:width];
	}

	-(void) addAbsoluteFrame:(UXStyledFrame *)frame width:(CGFloat)width height:(CGFloat)height {
		frame.bounds = CGRectMake(_x, _height, width, height);
		[self addFrame:frame];
	}

	-(UXStyledInlineFrame *) addInlineFrame:(UXStyle *)style element:(UXStyledElement *)element width:(CGFloat)width height:(CGFloat)height {
		UXStyledInlineFrame *frame = [[[UXStyledInlineFrame alloc] initWithElement:element] autorelease];
		frame.style = style;
		frame.bounds = CGRectMake(_x, _height, width, height);
		[self pushFrame:frame];
		if (!_lineFirstFrame) {
			_lineFirstFrame = frame;
		}
		return frame;
	}

	-(UXStyledInlineFrame *) cloneInlineFrame:(UXStyledInlineFrame *)frame {
		UXStyledInlineFrame *parent = frame.inlineParentFrame;
		if (parent) {
			[self cloneInlineFrame:parent];
		}
		
		UXStyledInlineFrame *clone	= [self addInlineFrame:frame.style element:frame.element width:0 height:0];
		clone.inlinePreviousFrame		= frame;
		frame.inlineNextFrame			= clone;
		return clone;
	}

	-(UXStyledFrame *) addBlockFrame:(UXStyle *)style element:(UXStyledElement *)element width:(CGFloat)width height:(CGFloat)height {
		UXStyledBoxFrame *frame = [[[UXStyledBoxFrame alloc] initWithElement:element] autorelease];
		frame.style		= style;
		frame.bounds	= CGRectMake(_x, _height, width, height);
		[self pushFrame:frame];
		return frame;
	}

	-(void) checkFloats {
		if (_floatHeight && (_height > _floatHeight) ) {
			_minX	-= _floatLeftWidth;
			_width	+= _floatLeftWidth + _floatRightWidth;
			_floatRightWidth	= 0;
			_floatLeftWidth		= 0;
			_floatHeight		= 0;
		}
	}

	-(void) breakLine {
		if (_inlineFrame) {
			UXStyledInlineFrame *inlineFrame = _inlineFrame;
			while (inlineFrame) {
				if (inlineFrame.style) {
					UXBoxStyle *padding = [inlineFrame.style firstStyleOfClass:[UXBoxStyle class]];
					if (padding) {
						UXStyledInlineFrame *inlineFrame2 = inlineFrame;
						while (inlineFrame2) {
							inlineFrame2.y		-= padding.padding.top;
							inlineFrame2.height += padding.padding.top + padding.padding.bottom;
							inlineFrame2		= inlineFrame2.inlineParentFrame;
						}
					}
				}
				inlineFrame = inlineFrame.inlineParentFrame;
			}
		}
		
		/*
		Vertically align all frames on the current line
		*/
		if (_lineFirstFrame.nextFrame) {
			UXStyledFrame *frame = _lineFirstFrame;
			while (frame) {
				/*
				Align to the text baseline. Support top, bottom, and center alignment also
				*/
				if (frame.height < _lineHeight) {
					UIFont *font = frame.font ? frame.font : _font;
					[self offsetFrame:frame by:(_lineHeight - (frame.height - font.descender))];
					/*
					CGFloat adjustmentOffset = _lineHeight - frame.height;
					// Text frame heights already include the descender
					if (![frame isKindOfClass:[UXStyledTextFrame class ]]) {
						adjustmentOffset += font.descender;
					}
					[self offsetFrame:frame by:adjustmentOffset];
					*/
				}
				frame = frame.nextFrame;
			}
		}
		
		_height += _lineHeight;
		[self checkFloats];
		
		_lineWidth		= 0;
		_lineHeight		= 0;
		_x				= _minX;
		_lineFirstFrame = nil;
		
		if (_inlineFrame) {
			while ([_topFrame isKindOfClass:[UXStyledInlineFrame class]]) {
				[self popFrame];
			}
			_inlineFrame = [self cloneInlineFrame:_inlineFrame];
		}
	}

	-(UXStyledFrame *) addFrameForText:(NSString *)text element:(UXStyledElement *)element node:(UXStyledTextNode *)aNode width:(CGFloat)width height:(CGFloat)height {
		UXStyledTextFrame *frame = [[[UXStyledTextFrame alloc] initWithText:text element:element node:aNode] autorelease];
		frame.font = _font;
		[self addContentFrame:frame width:width height:height];
		return frame;
	}

	-(void) layoutElement:(UXStyledElement *)elt {
		UXStyle *style = nil;
		if (elt.className) {
			UXStyle *eltStyle = [[UXStyleSheet globalStyleSheet] styleWithSelector:elt.className];
			if (eltStyle) {
				style = eltStyle;
			}
		}
		if (!style && [elt isKindOfClass:[UXStyledLinkNode class]]) {
			style = self.linkStyle;
		}
		
		// Figure out which font to use for the node
		UIFont *font				= nil;
		UXTextStyle *textStyle	= nil;
		if (style) {
			textStyle = [style firstStyleOfClass:[UXTextStyle class]];
			if (textStyle) {
				font = textStyle.font;
			}
		}
		if (!font) {
			if ([elt isKindOfClass:[UXStyledLinkNode class]]
				|| [elt isKindOfClass:[UXStyledBoldNode class]]) {
				font = self.boldFont;
			}
			else if ([elt isKindOfClass:[UXStyledItalicNode class]]) {
				font = self.italicFont;
			}
			else {
				font = self.font;
			}
		}
		
		UIFont *lastFont =	_font;
		self.font			= font;
		
		UXBoxStyle *padding = style ? [style firstStyleOfClass:[UXBoxStyle class]] : nil;
		
		if (padding && padding.position) {
			UXStyledFrame *blockFrame = [self addBlockFrame:style element:elt width:_width height:_height];
			
			CGFloat contentWidth	= padding.margin.left + padding.margin.right;
			CGFloat contentHeight	= padding.margin.top + padding.margin.bottom;
			
			if (elt.firstChild) {
				UXStyledNode *child		= elt.firstChild;
				UXStyledLayout *layout	= [[[UXStyledLayout alloc] initWithX:_minX width:0 height:_height] autorelease];
				layout.font					= _font;
				layout.invalidImages		= _invalidImages;
				[layout layout:child];
				if (!_invalidImages && layout.invalidImages) {
					_invalidImages = [layout.invalidImages retain];
				}
				
				UXStyledFrame *frame	= [self addContentFrame:layout.rootFrame width:layout.width];
				
				CGFloat frameHeight		= layout.height - _height;
				contentWidth			+= layout.width;
				contentHeight			+= frameHeight;
				
				if (padding.position == UXPositionFloatLeft) {
					frame.x += _floatLeftWidth;
					_floatLeftWidth += contentWidth;
					if (_height + contentHeight > _floatHeight) {
						_floatHeight = contentHeight + _height;
					}
					_minX += contentWidth;
					_width -= contentWidth;
				}
				else if (padding.position == UXPositionFloatRight) {
					frame.x += _width - (_floatRightWidth + contentWidth);
					_floatRightWidth += contentWidth;
					if (_height + contentHeight > _floatHeight) {
						_floatHeight = contentHeight + _height;
					}
					_x -= contentWidth;
					_width -= contentWidth;
				}
				
				blockFrame.width	= layout.width + padding.padding.left + padding.padding.right;
				blockFrame.height	= frameHeight + padding.padding.top + padding.padding.bottom;
			}
		}
		else {
			CGFloat minX			= _minX;
			CGFloat width			= _width;
			CGFloat floatLeftWidth	= _floatLeftWidth;
			CGFloat floatRightWidth = _floatRightWidth;
			CGFloat floatHeight		= _floatHeight;
			BOOL isBlock			= [elt isKindOfClass:[UXStyledBlock class]];
			UXStyledFrame *blockFrame = nil;
			
			if (isBlock) {
				if (padding) {
					_x			+= padding.margin.left;
					_minX		+= padding.margin.left;
					_width		-= padding.margin.left + padding.margin.right;
					_height		+= padding.margin.top;
				}
				
				if (_lastFrame) {
					if (!_lineHeight && [elt isKindOfClass:[UXStyledLineBreakNode class]]) {
						_lineHeight = [_font lineHeight];
					}
					[self breakLine];
				}
				if (style) {
					blockFrame = [self addBlockFrame:style element:elt width:_width height:_height];
				}
			}
			else {
				if (padding) {
					_x += padding.margin.left;
				}
				if (style) {
					_inlineFrame = [self addInlineFrame:style element:elt width:0 height:0];
				}
			}
			
			if (padding) {
				if (isBlock) {
					_minX += padding.padding.left;
				}
				_width	-= padding.padding.left + padding.padding.right;
				_x		+= padding.padding.left;
				[self expandLineWidth:padding.padding.left];
				
				if (isBlock) {
					_height += padding.padding.top;
				}
			}
			
			if (elt.firstChild) {
				[self layout:elt.firstChild container:elt];
			}
			
			if (isBlock) {
				_minX				= minX;
				_width				= width;
				_floatLeftWidth		= floatLeftWidth;
				_floatRightWidth	= floatRightWidth;
				_floatHeight		= floatHeight;
				[self breakLine];
				
				if (padding) {
					_height += padding.padding.bottom;
				}
				
				blockFrame.height = _height - blockFrame.height;
				
				if (padding) {
					if (blockFrame.height < padding.minSize.height) {
						_height				+= padding.minSize.height - blockFrame.height;
						blockFrame.height	= padding.minSize.height;
					}
					
					_height += padding.margin.bottom;
				}
			}
			else if (!isBlock && style) {
				if (padding) {
					_x			+= padding.padding.right + padding.margin.right;
					_lineWidth	+= padding.padding.right + padding.margin.right;
					
					UXStyledInlineFrame *inlineFrame = _inlineFrame;
					while (inlineFrame) {
						if (inlineFrame != _inlineFrame) {
							inlineFrame.width += padding.margin.right;
						}
						inlineFrame.width	+= padding.padding.right;
						inlineFrame.y		-= padding.padding.top;
						inlineFrame.height	+= padding.padding.top + padding.padding.bottom;
						inlineFrame			= inlineFrame.inlineParentFrame;
					}
				}
				_inlineFrame = _inlineFrame.inlineParentFrame;
			}
		}
		
		self.font = lastFont;
		
		if (style) {
			[self popFrame];
		}
	}

	-(void) layoutImage:(UXStyledImageNode *)imageNode container:(UXStyledElement *)element {
		UIImage *image = imageNode.image;
		if (!image && imageNode.URL) {
			if (!_invalidImages) {
				_invalidImages = UXCreateNonRetainingArray();
			}
			[_invalidImages addObject:imageNode];
		}
		
		UXStyle *style		= imageNode.className ? [[UXStyleSheet globalStyleSheet] styleWithSelector:imageNode.className] : nil;
		UXBoxStyle *padding	= style ? [style firstStyleOfClass:[UXBoxStyle class]] : nil;
		
		CGFloat imageWidth		= imageNode.width  ? imageNode.width  : image.size.width;
		CGFloat imageHeight		= imageNode.height ? imageNode.height : image.size.height;
		CGFloat contentWidth	= imageWidth;
		CGFloat contentHeight	= imageHeight;
		
		if (padding && (padding.position != UXPositionAbsolute) ) {
			_x					+= padding.margin.left;
			contentWidth		+= padding.margin.left + padding.margin.right;
			contentHeight		+= padding.margin.top  + padding.margin.bottom;
		}
		
		if ((!padding || !padding.position) && (_lineWidth + contentWidth > _width)) {
			if (_lineWidth) {
				// The image will be placed on the next line, so create a new frame for
				// the current line and mark it with a line break
				[self breakLine];
			}
			else {
				_width = contentWidth;
			}
		}
		
		UXStyledImageFrame *frame = [[[UXStyledImageFrame alloc] initWithElement:element node:imageNode] autorelease];
		frame.style = style;
		
		if (!padding || !padding.position) {
			[self addContentFrame:frame width:imageWidth height:imageHeight];
			[self expandLineWidth:contentWidth];
			[self inflateLineHeight:contentHeight];
		}
		else if (padding.position == UXPositionAbsolute) {
			[self addAbsoluteFrame:frame width:imageWidth height:imageHeight];
			frame.x += padding.margin.left;
			frame.y += padding.margin.top;
		}
		else if (padding.position == UXPositionFloatLeft) {
			[self addContentFrame:frame width:imageWidth height:imageHeight];
			
			frame.x += _floatLeftWidth;
			_floatLeftWidth += contentWidth;
			if (_height + contentHeight > _floatHeight) {
				_floatHeight = contentHeight + _height;
			}
			_minX += contentWidth;
			_width -= contentWidth;
		}
		else if (padding.position == UXPositionFloatRight) {
			
			[self addContentFrame:frame width:imageWidth height:imageHeight];
			frame.x += _width - (_floatRightWidth + contentWidth);
			_floatRightWidth += contentWidth;
			if (_height + contentHeight > _floatHeight) {
				_floatHeight = contentHeight + _height;
			}
			_x		-= contentWidth;
			_width	-= contentWidth;
		}
		
		if (padding && (padding.position != UXPositionAbsolute) ) {
			frame.y += padding.margin.top;
			_x		+= padding.margin.right;
		}
	}

	-(void) layoutText:(UXStyledTextNode *)textNode container:(UXStyledElement *)element {
		
		NSString *text		= textNode.text;
		NSUInteger length	= text.length;
		
		if (!textNode.nextSibling && (textNode == _rootNode) ) {
			// This is the only node, so measure it all at once and move on
			CGSize textSize = [text sizeWithFont:_font
							   constrainedToSize:CGSizeMake(_width, CGFLOAT_MAX)
								   lineBreakMode:UILineBreakModeWordWrap];
			[self addFrameForText:text element:element node:textNode width:textSize.width height:textSize.height];
			_height += textSize.height;
			return;
		}
		
		NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
		
		NSInteger index				= 0;
		NSInteger lineStartIndex	= 0;
		CGFloat frameWidth			= 0;
		
		while (index < length) {
			// Search for the next whitespace character
			NSRange searchRange = NSMakeRange(index, length - index);
			NSRange spaceRange	= [text rangeOfCharacterFromSet:whitespace options:0 range:searchRange];
			
			// Get the word prior to the whitespace
			NSRange wordRange = spaceRange.location != NSNotFound
							    ? NSMakeRange(searchRange.location, (spaceRange.location + 1) - searchRange.location) 
								: NSMakeRange(searchRange.location, length - searchRange.location);
			
			NSString *word = [text substringWithRange:wordRange];
			
			// If there is no width to constrain to, then just use an infinite width, which will prevent any word wrapping
			CGFloat availWidth = _width ? _width : CGFLOAT_MAX;
			
			// Measure the word and check to see if it fits on the current line
			CGSize wordSize = [word sizeWithFont:_font];
			if (wordSize.width > _width) {
			
				for (NSInteger i = 0; i < word.length; ++i) {
					
					NSString *c			= [word substringWithRange:NSMakeRange(i, 1)];
					CGSize letterSize	= [c sizeWithFont:_font];
					
					if (_lineWidth + letterSize.width > _width) {
						NSRange lineRange = NSMakeRange(lineStartIndex, index - lineStartIndex);
						if (lineRange.length) {
							NSString *line = [text substringWithRange:lineRange];
							[self addFrameForText:line element:element node:textNode width:frameWidth height:_lineHeight ? _lineHeight: [_font lineHeight]];
						}
						
						if (_lineWidth) {
							[self breakLine];
						}
						
						lineStartIndex = lineRange.location + lineRange.length;
						frameWidth = 0;
					}
					
					frameWidth += letterSize.width;
					[self expandLineWidth:letterSize.width];
					[self inflateLineHeight:wordSize.height];
					++index;
				}
				
				NSRange lineRange = NSMakeRange(lineStartIndex, index - lineStartIndex);
				if (lineRange.length) {
					NSString *line	= [text substringWithRange:lineRange];
					[self addFrameForText:line element:element node:textNode width:frameWidth height:_lineHeight ? _lineHeight: [_font lineHeight]];
					lineStartIndex	= lineRange.location + lineRange.length;
					frameWidth		= 0;
				}
			}
			else {
				
				if (_lineWidth + wordSize.width > _width) {
					
					// The word will be placed on the next line, so create a new frame for the current line and mark it with a line break
					NSRange lineRange = NSMakeRange(lineStartIndex, index - lineStartIndex);
					if (lineRange.length) {
						NSString *line = [text substringWithRange:lineRange];
						[self addFrameForText:line element:element node:textNode width:frameWidth height:_lineHeight ? _lineHeight: [_font lineHeight]];
					}
					
					if (_lineWidth) {
						[self breakLine];
					}
					lineStartIndex	= lineRange.location + lineRange.length;
					frameWidth		= 0;
				}
				
				if (!_lineWidth && (textNode == _lastNode) ) {
					// We are at the start of a new line, and this is the last node, so we don't need to
					// keep measuring every word.  We can just measure all remaining text and create a new
					// frame for all of it.
					NSString *lines		= [text substringWithRange:searchRange];
					CGSize linesSize	= [lines sizeWithFont:_font constrainedToSize:CGSizeMake(availWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
					
					[self addFrameForText:lines element:element node:textNode width:linesSize.width height:linesSize.height];
					_height += linesSize.height;
					break;
				}
				
				frameWidth += wordSize.width;
				[self expandLineWidth:wordSize.width];
				[self inflateLineHeight:wordSize.height];
				
				index = wordRange.location + wordRange.length;
				if (index >= length) {
					// The current word was at the very end of the string
					NSRange lineRange	= NSMakeRange(lineStartIndex, (wordRange.location + wordRange.length) - lineStartIndex);
					NSString *line		= !_lineWidth ? word : [text substringWithRange:lineRange];
					[self addFrameForText:line element:element node:textNode width:frameWidth height:[_font lineHeight]];
					frameWidth = 0;
				}
			}
		}
	}


	#pragma mark NSObject

	-(id) initWithRootNode:(UXStyledNode *)rootNode {
		if (self = [self init]) {
			_rootNode = rootNode;
		}
		return self;
	}

	-(id) initWithX:(CGFloat)x width:(CGFloat)width height:(CGFloat)height {
		if (self = [self init]) {
			_x			= x;
			_minX		= x;
			_width		= width;
			_height		= height;
		}
		return self;
	}

	-(id) init {
		if (self = [super init]) {
			_x			= 0;
			_width		= 0;
			_height		= 0;
			_lineWidth	= 0;
			_lineHeight = 0;
			_minX		= 0;
			_floatLeftWidth		= 0;
			_floatRightWidth	= 0;
			_floatHeight	= 0;
			_rootFrame		= nil;
			_lineFirstFrame	= nil;
			_inlineFrame	= nil;
			_topFrame		= nil;
			_lastFrame		= nil;
			_font			= nil;
			_boldFont		= nil;
			_italicFont		= nil;
			_linkStyle		= nil;
			_rootNode		= nil;
			_lastNode		= nil;
			_invalidImages	= nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_rootFrame);
		UX_SAFE_RELEASE(_font);
		UX_SAFE_RELEASE(_boldFont);
		UX_SAFE_RELEASE(_italicFont);
		UX_SAFE_RELEASE(_linkStyle);
		UX_SAFE_RELEASE(_invalidImages);
		[super dealloc];
	}


	#pragma mark API

	-(UIFont *) font {
		if (!_font) {
			self.font = UXSTYLESHEETPROPERTY(font);
		}
		return _font;
	}

	-(void) setFont:(UIFont *)font {
		if (font != _font) {
			[_font release];
			_font = [font retain];
			UX_SAFE_RELEASE(_boldFont);
			UX_SAFE_RELEASE(_italicFont);
		}
	}

	-(void) layout:(UXStyledNode *)aNode container:(UXStyledElement *)element {
		while (aNode) {
			if ([aNode isKindOfClass:[UXStyledImageNode class]]) {
				UXStyledImageNode *imageNode = (UXStyledImageNode *)aNode;
				[self layoutImage:imageNode container:element];
			}
			else if ([aNode isKindOfClass:[UXStyledElement class]]) {
				UXStyledElement *elt = (UXStyledElement *)aNode;
				[self layoutElement:elt];
			}
			else if ([aNode isKindOfClass:[UXStyledTextNode class]]) {
				UXStyledTextNode *textNode = (UXStyledTextNode *)aNode;
				[self layoutText:textNode container:element];
			}
			
			aNode = aNode.nextSibling;
		}
	}

	-(void) layout:(UXStyledNode *)aNode {
		[self layout:aNode container:nil];
		if (_lineWidth) {
			[self breakLine];
		}
	}

@end
