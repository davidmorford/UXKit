
#import <UXKit/UXTextEditor.h>
#import <UXKit/UXDefaultStyleSheet.h>

static CGFloat kPaddingX = 8;
static CGFloat kPaddingY = 9;

/*!
This number is very sensitive - it is specifically calculated for precise word wrapping
with 15pt normal helvetica.  If you change this number at all, UITextView may wrap the text
before or after the UXTextEditor expands or contracts its height to match.  Obviously,
hard-coding this value here sucks, and I need to implement a solution that works for any font.
*/
static CGFloat kTextViewInset = 31;

#pragma mark -

@implementation UXTextView

	@synthesize autoresizesToText = _autoresizesToText;
	@synthesize overflowed = _overflowed;

	-(void) setContentOffset:(CGPoint)offset animated:(BOOL)animated {
	if (_autoresizesToText && !_overflowed) {
		// In autosizing mode, we don't ever allow the text view to scroll past zero
		// unless it has past its maximum number of lines
		[super setContentOffset:CGPointZero animated:animated];
	}
	else {
		[super setContentOffset:offset animated:animated];
	}
}

@end

#pragma mark -

@interface UXTextEditorInternal : NSObject <UITextViewDelegate, UITextFieldDelegate> {
	UXTextEditor *_textEditor;
	id <UXTextEditorDelegate> _delegate;
	BOOL _ignoreBeginAndEnd;
}

	@property (nonatomic, assign) id <UXTextEditorDelegate> delegate;
	@property (nonatomic) BOOL ignoreBeginAndEnd;

	-(id) initWithTextEditor:(UXTextEditor *)textEditor;

@end

#pragma mark -

@implementation UXTextEditorInternal

	@synthesize delegate = _delegate;
	@synthesize ignoreBeginAndEnd = _ignoreBeginAndEnd;


	#pragma mark NSObject

	-(id) initWithTextEditor:(UXTextEditor *)textEditor {
		if (self = [super init]) {
			_textEditor = textEditor;
			_delegate = nil;
			_ignoreBeginAndEnd = NO;
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}


	#pragma mark UITextViewDelegate

	-(BOOL) textViewShouldBeginEditing:(UITextView *)textView {
		if (!_ignoreBeginAndEnd
			&& [_delegate respondsToSelector:@selector(textEditorShouldBeginEditing:)]) {
			return [_delegate textEditorShouldBeginEditing:_textEditor];
		}
		else {
			return YES;
		}
	}

	-(BOOL) textViewShouldEndEditing:(UITextView *)textView {
		if (!_ignoreBeginAndEnd
			&& [_delegate respondsToSelector:@selector(textEditorShouldEndEditing:)]) {
			return [_delegate textEditorShouldEndEditing:_textEditor];
		}
		else {
			return YES;
		}
	}

	-(void) textViewDidBeginEditing:(UITextView *)textView {
		if (!_ignoreBeginAndEnd) {
			[_textEditor performSelector:@selector(didBeginEditing)];
			
			if ([_delegate respondsToSelector:@selector(textEditorDidBeginEditing:)]) {
				[_delegate textEditorDidBeginEditing:_textEditor];
			}
		}
	}

	-(void) textViewDidEndEditing:(UITextView *)textView {
		if (!_ignoreBeginAndEnd) {
			[_textEditor performSelector:@selector(didEndEditing)];
			
			if ([_delegate respondsToSelector:@selector(textEditorDidEndEditing:)]) {
				[_delegate textEditorDidEndEditing:_textEditor];
			}
		}
	}

	-(BOOL) textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
		if ([text isEqualToString:@"\n"]) {
			if ([_delegate respondsToSelector:@selector(textEditorShouldReturn:)]) {
				if (![_delegate performSelector:@selector(textEditorShouldReturn:) withObject:_textEditor]) {
					return NO;
				}
			}
		}
		
		if ([_delegate respondsToSelector:@selector(textEditor:shouldChangeTextInRange:replacementText:)]) {
			return [_delegate textEditor:_textEditor shouldChangeTextInRange:range replacementText:text];
		}
		else {
			return YES;
		}
	}

	-(void) textViewDidChange:(UITextView *)textView {
		[_textEditor performSelector:@selector(didChangeText:) withObject:NO];
		
		if ([_delegate respondsToSelector:@selector(textEditorDidChange:)]) {
			[_delegate textEditorDidChange:_textEditor];
		}
	}

	-(void) textViewDidChangeSelection:(UITextView *)textView {
	}


	#pragma mark UITextFieldDelegate

	-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
		if (!_ignoreBeginAndEnd && [_delegate respondsToSelector:@selector(textEditorShouldBeginEditing:)]) {
			return [_delegate textEditorShouldBeginEditing:_textEditor];
		}
		else {
			return YES;
		}
	}

	-(BOOL) textFieldShouldEndEditing:(UITextField *)textField {
		if (!_ignoreBeginAndEnd && [_delegate respondsToSelector:@selector(textEditorShouldEndEditing:)]) {
			return [_delegate textEditorShouldEndEditing:_textEditor];
		}
		else {
			return YES;
		}
	}

	-(void) textFieldDidBeginEditing:(UITextField *)textField {
		if (!_ignoreBeginAndEnd) {
			[_textEditor performSelector:@selector(didBeginEditing)];
			
			if ([_delegate respondsToSelector:@selector(textEditorDidBeginEditing:)]) {
				[_delegate textEditorDidBeginEditing:_textEditor];
			}
		}
	}

	-(void) textFieldDidEndEditing:(UITextField *)textField {
		if (!_ignoreBeginAndEnd) {
			[_textEditor performSelector:@selector(didEndEditing)];
			
			if ([_delegate respondsToSelector:@selector(textEditorDidEndEditing:)]) {
				[_delegate textEditorDidEndEditing:_textEditor];
			}
		}
	}

	-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
		BOOL shouldChange = YES;
		if ([_delegate respondsToSelector:@selector(textEditor:shouldChangeTextInRange:replacementText:)]) {
			shouldChange = [_delegate textEditor:_textEditor shouldChangeTextInRange:range
								 replacementText:string];
		}
		if (shouldChange) {
			[self performSelector:@selector(textViewDidChange:) withObject:nil afterDelay:0];
		}
		return shouldChange;
	}

	-(BOOL) textFieldShouldReturn:(UITextField *)textField {
		if ([_delegate respondsToSelector:@selector(textEditorShouldReturn:)]) {
			if (![_delegate performSelector:@selector(textEditorShouldReturn:) withObject:_textEditor]) {
				return NO;
			}
		}
		
		[_textEditor performSelector:@selector(didChangeText:) withObject:(id)YES];
		
		if ([_delegate respondsToSelector:@selector(textEditorDidChange:)]) {
			[_delegate textEditorDidChange:_textEditor];
		}
		return YES;
	}

@end

#pragma mark -

@implementation UXTextEditor

	@synthesize delegate			= _delegate;
	@synthesize minNumberOfLines	= _minNumberOfLines;
	@synthesize maxNumberOfLines	= _maxNumberOfLines;
	@synthesize editing				= _editing;
	@synthesize autoresizesToText	= _autoresizesToText;
	@synthesize showsExtraLine		= _showsExtraLine;


	#pragma mark SPI

	-(UIResponder *) activeTextField {
		if (_textView && !_textView.hidden) {
			return _textView;
		}
		else {
			return _textField;
		}
	}

	-(void) createTextView {
		if (!_textView) {
			_textView = [[UXTextView alloc] init];
			_textView.delegate = _internal;
			_textView.editable = YES;
			_textView.backgroundColor = [UIColor clearColor];
			_textView.scrollsToTop = NO;
			_textView.showsHorizontalScrollIndicator = NO;
			_textView.font = _textField.font;
			_textView.autoresizesToText = _autoresizesToText;
			_textView.textColor = _textField.textColor;
			_textView.autocapitalizationType = _textField.autocapitalizationType;
			_textView.autocorrectionType = _textField.autocorrectionType;
			_textView.enablesReturnKeyAutomatically = _textField.enablesReturnKeyAutomatically;
			_textView.keyboardAppearance = _textField.keyboardAppearance;
			_textView.keyboardType = _textField.keyboardType;
			_textView.returnKeyType = _textField.returnKeyType;
			_textView.secureTextEntry = _textField.secureTextEntry;
			[self addSubview:_textView];
		}
	}

	-(CGFloat) heightThatFits:(BOOL *)overflowed numberOfLines:(NSInteger *)numberOfLines {
		CGFloat lineHeight = self.font.lineHeight;
		CGFloat minHeight = _minNumberOfLines * lineHeight;
		CGFloat maxHeight = _maxNumberOfLines * lineHeight;
		CGFloat maxWidth = self.width - kTextViewInset;
		
		NSString *text = _textField.hidden ? _textView.text : _textField.text;
		if (!text.length) {
			text = @"M";
		}
		
		CGSize textSize = [text sizeWithFont:self.font
						   constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX)
							   lineBreakMode:UILineBreakModeWordWrap];
		
		CGFloat newHeight = textSize.height;
		if ([text characterAtIndex:text.length - 1] == 10) {
			newHeight += lineHeight;
		}
		if (_showsExtraLine) {
			newHeight += lineHeight;
		}
		
		if (overflowed) {
			*overflowed = maxHeight && newHeight > maxHeight;
		}
		
		if (numberOfLines) {
			*numberOfLines = floor(textSize.height / lineHeight);
		}
		
		if (newHeight < minHeight) {
			newHeight = minHeight;
		}
		if (maxHeight && (newHeight > maxHeight) ) {
			newHeight = maxHeight;
		}
		
		return newHeight + kPaddingY * 2;
	}

	-(void) stopIgnoringBeginAndEnd {
		_internal.ignoreBeginAndEnd = NO;
	}

	-(void) constrainToText {
		NSInteger numberOfLines = 0;
		CGFloat oldHeight		= self.height;
		CGFloat newHeight		= [self heightThatFits:&_overflowed numberOfLines:&numberOfLines];
		CGFloat diff			= newHeight - oldHeight;
		
		if ((numberOfLines > 1) && !_textField.hidden) {
			[self createTextView];
			_textField.hidden			= YES;
			_textView.hidden			= NO;
			_textView.text				= _textField.text;
			_internal.ignoreBeginAndEnd	= YES;
			[_textView becomeFirstResponder];
			[self performSelector:@selector(stopIgnoringBeginAndEnd) withObject:nil afterDelay:0];
			
		}
		else if ((numberOfLines == 1) && _textField.hidden) {
			_textField.hidden			= NO;
			_textView.hidden			= YES;
			_textField.text				= _textView.text;
			_internal.ignoreBeginAndEnd	= YES;
			[_textField becomeFirstResponder];
			[self performSelector:@selector(stopIgnoringBeginAndEnd) withObject:nil afterDelay:0];
		}
		
		_textView.overflowed	= _overflowed;
		_textView.scrollEnabled = _overflowed;
		
		if (oldHeight && diff) {
			if ([_delegate respondsToSelector:@selector(textEditor:shouldResizeBy:)]) {
				if (![_delegate textEditor:self shouldResizeBy:diff]) {
					return;
				}
			}
			self.frame = UXRectContract(self.frame, 0, -diff);
		}
	}

	-(void) didBeginEditing {
		_editing = YES;
	}

	-(void) didEndEditing {
		_editing = NO;
	}

	-(void) didChangeText:(BOOL)insertReturn {
		if (insertReturn) {
			[self createTextView];
			_textField.hidden	= YES;
			_textView.hidden	= NO;
			_textView.text		= [_textField.text stringByAppendingString:@"\n "];
			_internal.ignoreBeginAndEnd = YES;
			[_textView becomeFirstResponder];
			[self performSelector:@selector(stopIgnoringBeginAndEnd) withObject:nil afterDelay:0];
		}
		if (_autoresizesToText) {
			[self constrainToText];
		}
	}


	#pragma mark NSObject

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			_delegate			= nil;
			_internal			= [[UXTextEditorInternal alloc] initWithTextEditor:self];
			_textView			= nil;
			_autoresizesToText	= YES;
			_showsExtraLine		= NO;
			_minNumberOfLines	= 0;
			_maxNumberOfLines	= 0;
			_editing			= NO;
			_overflowed			= NO;
			
			_textField			= [[UITextField alloc] init];
			_textField.delegate = _internal;
			[self addSubview:_textField];
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_internal);
		UX_SAFE_RELEASE(_textField);
		UX_SAFE_RELEASE(_textView);
		[super dealloc];
	}


	#pragma mark UIResponder

	-(BOOL) becomeFirstResponder {
		return [[self activeTextField] becomeFirstResponder];
	}

	-(BOOL) resignFirstResponder {
		return [[self activeTextField] resignFirstResponder];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		CGRect frame		= CGRectMake(0, 2, self.width - kPaddingX * 2, self.height);
		_textView.frame		= frame;
		_textField.frame	= CGRectOffset(UXRectContract(frame, 7, 8), 7, 8);
	}

	-(CGSize) sizeThatFits:(CGSize)size {
		CGFloat height = [self heightThatFits:nil numberOfLines:nil];
		return CGSizeMake(size.width, height);
	}


	#pragma mark UITextInputTraits

	-(UITextAutocapitalizationType) autocapitalizationType {
		return _textField.autocapitalizationType;
	}

	-(void) setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType {
		_textField.autocapitalizationType = autocapitalizationType;
	}

	-(UITextAutocorrectionType) autocorrectionType {
		return _textField.autocorrectionType;
	}

	-(void) setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType {
		_textField.autocorrectionType = autocorrectionType;
	}

	-(BOOL) enablesReturnKeyAutomatically {
		return _textField.enablesReturnKeyAutomatically;
	}

	-(void) setEnablesReturnKeyAutomatically:(BOOL)enablesReturnKeyAutomatically {
		_textField.enablesReturnKeyAutomatically = enablesReturnKeyAutomatically;
	}

	-(UIKeyboardAppearance) keyboardAppearance {
		return _textField.keyboardAppearance;
	}

	-(void) setKeyboardAppearance:(UIKeyboardAppearance)keyboardAppearance {
		_textField.keyboardAppearance = keyboardAppearance;
	}

	-(UIKeyboardType) keyboardType {
		return _textField.keyboardType;
	}

	-(void) setKeyboardType:(UIKeyboardType)keyboardType {
		_textField.keyboardType = keyboardType;
	}

	-(UIReturnKeyType) returnKeyType {
		return _textField.returnKeyType;
	}

	-(void) setReturnKeyType:(UIReturnKeyType)returnKeyType {
		_textField.returnKeyType = returnKeyType;
	}

	-(BOOL) secureTextEntry {
		return _textField.secureTextEntry;
	}

	-(void) setSecureTextEntry:(BOOL)secureTextEntry {
		_textField.secureTextEntry = secureTextEntry;
	}


	#pragma mark API

	-(void) setDelegate:(id <UXTextEditorDelegate>)delegate {
		_delegate = delegate;
		_internal.delegate = delegate;
	}

	-(NSString *) text {
		if (_textView && !_textView.hidden) {
			return _textView.text;
		}
		else {
			return _textField.text;
		}
	}

	-(void) setText:(NSString *)text {
		_textField.text = _textView.text = text;
		if (_autoresizesToText) {
			[self constrainToText];
		}
	}

	-(NSString *) placeholder {
		return _textField.placeholder;
	}

	-(void) setPlaceholder:(NSString *)placeholder {
		_textField.placeholder = placeholder;
	}

	-(void) setAutoresizesToText:(BOOL)autoresizesToText {
		_autoresizesToText = autoresizesToText;
		_textView.autoresizesToText = _autoresizesToText;
	}

	-(UIFont *) font {
		return _textField.font;
	}

	-(void) setFont:(UIFont *)font {
		_textField.font = font;
	}

	-(UIColor *) textColor {
		return _textField.textColor;
	}

	-(void) setTextColor:(UIColor *)textColor {
		_textField.textColor = textColor;
	}

	-(void) scrollContainerToCursor:(UIScrollView *)scrollView {
		if (_textView.hasText) {
			if (scrollView.contentSize.height > scrollView.height) {
				NSRange range = _textView.selectedRange;
				if (range.location == _textView.text.length) {
					[scrollView scrollRectToVisible:CGRectMake(0, scrollView.contentSize.height - 1, 1, 1)
										   animated:NO];
				}
			}
			else {
				[scrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
			}
		}
	}

@end
