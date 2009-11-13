
#import <UXKit/UXPickerTextField.h>
#import <UXPickerViewCell.h>

#pragma mark -

static NSString *kEmpty = @" ";
static NSString *kSelected = @"`";

static CGFloat kCellPaddingY = 3;
static CGFloat kPaddingX = 8;
static CGFloat kSpacingY = 6;
static CGFloat kPaddingRatio = 1.75;
static CGFloat kClearButtonSize = 38;
static CGFloat kMinCursorWidth = 50;

#pragma mark -

@implementation UXPickerTextField

	@synthesize cellViews		= _cellViews;
	@synthesize selectedCell	= _selectedCell;
	@synthesize lineCount		= _lineCount;

	#pragma mark Initializer

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_cellViews		= [[NSMutableArray alloc] init];
			_selectedCell						= nil;
			_lineCount							= 1;
			_cursorOrigin						= CGPointZero;
			
			self.text							= kEmpty;
			self.contentVerticalAlignment		= UIControlContentVerticalAlignmentTop;
			self.clearButtonMode				= UITextFieldViewModeNever;
			self.returnKeyType					= UIReturnKeyDone;
			self.enablesReturnKeyAutomatically	= NO;
			
			[self addTarget:self action:@selector(textFieldDidEndEditing) forControlEvents:UIControlEventEditingDidEnd];
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_cellViews);
		[super dealloc];
	}


	#pragma mark SPI

	-(CGFloat) layoutCells {
		CGFloat fontHeight		= self.font.lineHeight;
		CGFloat lineIncrement	= fontHeight + kCellPaddingY * 2 + kSpacingY;
		CGFloat marginY			= floor(fontHeight / kPaddingRatio);
		CGFloat marginLeft		= self.leftView ? kPaddingX + self.leftView.width + kPaddingX / 2 : kPaddingX;
		CGFloat marginRight		= kPaddingX + (self.rightView ? kClearButtonSize : 0);
		_cursorOrigin.x			= marginLeft;
		_cursorOrigin.y			= marginY;
		_lineCount				= 1;
		
		if (self.width) {
			for (UXPickerViewCell *cell in _cellViews) {
				[cell sizeToFit];
				
				CGFloat lineWidth = _cursorOrigin.x + cell.frame.size.width + marginRight;
				if (lineWidth >= self.width) {
					_cursorOrigin.x = marginLeft;
					_cursorOrigin.y += lineIncrement;
					++_lineCount;
				}
				
				cell.frame		= CGRectMake(_cursorOrigin.x, _cursorOrigin.y - kCellPaddingY, cell.width, cell.height);
				_cursorOrigin.x += cell.frame.size.width + kPaddingX;
			}
			
			CGFloat remainingWidth = self.width - (_cursorOrigin.x + marginRight);
			if (remainingWidth < kMinCursorWidth) {
				_cursorOrigin.x = marginLeft;
				_cursorOrigin.y += lineIncrement;
				++_lineCount;
			}
		}
		return _cursorOrigin.y + fontHeight + marginY;
	}

	-(void) updateHeight {
		CGFloat previousHeight	= self.height;
		CGFloat newHeight		= [self layoutCells];
		if (previousHeight && newHeight != previousHeight) {
			self.height = newHeight;
			[self setNeedsDisplay];
			SEL sel = @selector(textFieldDidResize :);
			if ([self.delegate respondsToSelector:sel]) {
				[self.delegate performSelector:sel withObject:self];
			}
			[self scrollToVisibleLine:YES];
		}
	}

	-(CGFloat) marginY {
		return floor(self.font.lineHeight / kPaddingRatio);
	}

	-(CGFloat) topOfLine:(int)lineNumber {
		if (lineNumber == 0) {
			return 0;
		}
		else {
			CGFloat lineHeight	= self.font.lineHeight;
			CGFloat lineSpacing = kCellPaddingY * 2 + kSpacingY;
			CGFloat marginY		= floor(lineHeight / kPaddingRatio);
			CGFloat lineTop		= marginY + lineHeight * lineNumber + lineSpacing * lineNumber;
			return lineTop - lineSpacing;
		}
	}

	-(CGFloat) centerOfLine:(int)lineNumber {
		CGFloat lineTop		= [self topOfLine:lineNumber];
		CGFloat lineHeight	= self.font.lineHeight + kCellPaddingY * 2 + kSpacingY;
		return lineTop + floor(lineHeight / 2);
	}

	-(CGFloat) heightWithLines:(int)lines {
		CGFloat lineHeight	= self.font.lineHeight;
		CGFloat lineSpacing = kCellPaddingY * 2 + kSpacingY;
		CGFloat marginY		= floor(lineHeight / kPaddingRatio);
		return marginY + lineHeight * lines + lineSpacing * (lines ? lines - 1 : 0) + marginY;
	}

	-(void) selectLastCell {
		self.selectedCell = [_cellViews objectAtIndex:_cellViews.count - 1];
	}

	-(NSString *) labelForObject:(id)object {
		NSString *label = nil;
		if ([_dataSource respondsToSelector:@selector(tableView:labelForObject:)]) {
			label = [_dataSource tableView:_tableView labelForObject:object];
		}
		return label ? label : [NSString stringWithFormat:@"%@", object];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		if (_dataSource) {
			[self layoutCells];
		}
		else {
			_cursorOrigin.x = kPaddingX;
			_cursorOrigin.y = [self marginY];
			if (self.leftView) {
				_cursorOrigin.x += self.leftView.width + kPaddingX / 2;
			}
		}
		
		[super layoutSubviews];
	}

	-(CGSize) sizeThatFits:(CGSize)size {
		[self layoutIfNeeded];
		CGFloat height = [self heightWithLines:_lineCount];
		return CGSizeMake(size.width, height);
	}

	-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
		[super touchesBegan:touches withEvent:event];
		
		if (_dataSource) {
			UITouch *touch = [touches anyObject];
			if (touch.view == self) {
				self.selectedCell = nil;
			}
			else {
				if ([touch.view isKindOfClass:[UXPickerViewCell class]]) {
					self.selectedCell = (UXPickerViewCell *)touch.view;
					[self becomeFirstResponder];
				}
			}
		}
	}


	#pragma mark UITextField

	-(void) setText:(NSString *)text {
		if (_dataSource) {
			[self updateHeight];
		}
		[super setText:text];
	}

	-(CGRect) textRectForBounds:(CGRect)bounds {
		if (_dataSource && [self.text isEqualToString:kSelected]) {
			// Hide the cursor while a cell is selected
			return CGRectMake(-10, 0, 0, 0);
		}
		else {
			CGRect frame		= CGRectOffset(bounds, _cursorOrigin.x, _cursorOrigin.y);
			frame.size.width	-= (_cursorOrigin.x + kPaddingX + (self.rightView ? kClearButtonSize : 0));
			return frame;
		}
	}

	-(CGRect) editingRectForBounds:(CGRect)bounds {
		return [self textRectForBounds:bounds];
	}

	-(CGRect) placeholderRectForBounds:(CGRect)bounds {
		return [self textRectForBounds:bounds];
	}

	-(CGRect) leftViewRectForBounds:(CGRect)bounds {
		if (self.leftView) {
			return CGRectMake(bounds.origin.x + kPaddingX, self.marginY, self.leftView.frame.size.width, self.leftView.frame.size.height);
		}
		else {
			return bounds;
		}
	}

	-(CGRect) rightViewRectForBounds:(CGRect)bounds {
		if (self.rightView) {
			return CGRectMake(bounds.size.width - kClearButtonSize, bounds.size.height - kClearButtonSize, kClearButtonSize, kClearButtonSize);
		}
		else {
			return bounds;
		}
	}


	#pragma mark UXSearchTextField

	-(BOOL) hasText {
		return self.text.length && ![self.text isEqualToString:kEmpty] && ![self.text isEqualToString:kSelected];
	}

	-(void) showSearchResults:(BOOL)show {
		[super showSearchResults:show];
		if (show) {
			[self scrollToEditingLine:YES];
		}
		else {
			[self scrollToVisibleLine:YES];
		}
	}

	-(CGRect) rectForSearchResults:(BOOL)withKeyboard {
		UIView *superview		= self.superviewForSearchResults;
		CGFloat y				= superview.screenY;
		CGFloat visibleHeight	= [self heightWithLines:1];
		CGFloat keyboardHeight	= withKeyboard ? UXKeyboardHeight() : 0;
		CGFloat tableHeight		= UXScreenBounds().size.height - (y + visibleHeight + keyboardHeight);
		
		return CGRectMake(0, self.bottom - 1, superview.frame.size.width, tableHeight + 1);
	}

	-(BOOL) shouldUpdate:(BOOL)emptyText {
		if (emptyText && !self.hasText && !self.selectedCell && self.cells.count) {
			[self selectLastCell];
			return NO;
		}
		else if (emptyText && self.selectedCell) {
			[self removeSelectedCell];
			[super shouldUpdate:emptyText];
			return NO;
		}
		else if (!emptyText && !self.hasText && self.selectedCell) {
			[self removeSelectedCell];
			[super shouldUpdate:emptyText];
			return YES;
		}
		else {
			return [super shouldUpdate:emptyText];
		}
	}


	#pragma mark UITableViewDelegate

	-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		[_tableView deselectRowAtIndexPath:indexPath animated:NO];
		id object = [_dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
		[self addCellWithObject:object];
	}


	#pragma mark UIControlEvents

	-(void) textFieldDidEndEditing {
		if (_selectedCell) {
			self.selectedCell = nil;
		}
	}


	#pragma mark API

	-(NSArray *) cells {
		NSMutableArray *cells = [NSMutableArray array];
		for (UXPickerViewCell *cellView in _cellViews) {
			[cells addObject:cellView.object ? cellView.object: [NSNull null]];
		}
		return cells;
	}

	-(void) addCellWithObject:(id)object {
		UXPickerViewCell *cell = [[[UXPickerViewCell alloc] init] autorelease];
		NSString *label = [self labelForObject:object];
		
		cell.object = object;
		cell.label = label;
		cell.font = self.font;
		[_cellViews addObject:cell];
		[self addSubview:cell];
		
		// Reset text so the cursor moves to be at the end of the cellViews
		self.text = kEmpty;
		
		SEL sel = @selector(textField : didAddCellAtIndex :);
		if ([self.delegate respondsToSelector:sel]) {
			[self.delegate performSelector:sel withObject:self withObject:(id)_cellViews.count - 1];
		}
	}

	-(void) removeCellWithObject:(id)object {
		for (int i = 0; i < _cellViews.count; ++i) {
			UXPickerViewCell *cell = [_cellViews objectAtIndex:i];
			if (cell.object == object) {
				[_cellViews removeObjectAtIndex:i];
				[cell removeFromSuperview];
				
				SEL sel = @selector(textField : didRemoveCellAtIndex :);
				if ([self.delegate respondsToSelector:sel]) {
					[self.delegate performSelector:sel withObject:self withObject:(id)i];
				}
				break;
			}
		}
		
		// Reset text so the cursor oves to be at the end of the cellViews
		self.text = self.text;
	}

	-(void) removeAllCells {
		while (_cellViews.count) {
			UXPickerViewCell *cell = [_cellViews objectAtIndex:0];
			[cell removeFromSuperview];
			[_cellViews removeObjectAtIndex:0];
		}
		
		_selectedCell = nil;
	}

	-(void) setSelectedCell:(UXPickerViewCell *)cell {
		if (_selectedCell) {
			_selectedCell.selected = NO;
		}
		
		_selectedCell = cell;
		
		if (_selectedCell) {
			_selectedCell.selected = YES;
			self.text = kSelected;
		}
		else if (self.cells.count) {
			self.text = kEmpty;
		}
	}

	-(void) removeSelectedCell {
		if (_selectedCell) {
			[self removeCellWithObject:_selectedCell.object];
			_selectedCell = nil;
			
			if (_cellViews.count) {
				self.text = kEmpty;
			}
			else {
				self.text = @"";
			}
		}
	}

	-(void) scrollToVisibleLine:(BOOL)animated {
		if (self.editing) {
			UIScrollView *scrollView = (UIScrollView *)[self ancestorOrSelfWithClass:[UIScrollView class]];
			if (scrollView) {
				[scrollView setContentOffset:CGPointMake(0, self.top) animated:animated];
			}
		}
	}

	-(void) scrollToEditingLine:(BOOL)animated {
		UIScrollView *scrollView = (UIScrollView *)[self ancestorOrSelfWithClass:[UIScrollView class]];
		if (scrollView) {
			CGFloat offset = _lineCount == 1 ? 0 : [self topOfLine:_lineCount - 1];
			[scrollView setContentOffset:CGPointMake(0, self.top + offset) animated:animated];
		}
	}

@end
