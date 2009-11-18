
#import "UXMessageController.h"
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXPickerTextField.h>
#import <UXKit/UXTextEditor.h>
#import <UXKit/UXActivityLabel.h>

@implementation UXMessageField

	@synthesize title		= _title;
	@synthesize required	= _required;

	#pragma mark Initializer

	-(id) initWithTitle:(NSString *)aTitle required:(BOOL)flag {
		if (self = [self init]) {
			_title		= [aTitle copy];
			_required	= flag;
		}
		return self;
	}

	#pragma mark <NSObject>

	-(NSString *) description {
		return [NSString stringWithFormat:@"%@", _title];
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_title);
		[super dealloc];
	}

	#pragma mark API

	-(UXPickerTextField *) createViewForController:(UXMessageController *)aController {
		return nil;
	}

	-(id) persistField:(UITextField *)aTextField {
		return nil;
	}

	-(void) restoreField:(UITextField *)aTextField withData:(id)data {
	
	}

@end

#pragma mark -

@implementation UXMessageRecipientField

	@synthesize recipients = _recipients;

	#pragma mark <NSObject>

	-(id) init {
		if (self = [super init]) {
			_recipients = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_recipients);
		[super dealloc];
	}

	-(NSString *) description {
		return [NSString stringWithFormat:@"%@ %@", _title, _recipients];
	}

	#pragma mark UXMessageField

	-(UITextField *) createViewForController:(UXMessageController *)controller {
		UXPickerTextField *textField		= [[[UXPickerTextField alloc] init] autorelease];
		textField.dataSource				= controller.dataSource;
		textField.autocorrectionType		= UITextAutocorrectionTypeNo;
		textField.autocapitalizationType	= UITextAutocapitalizationTypeNone;
		textField.rightViewMode				= UITextFieldViewModeAlways;
		
		if (controller.showsRecipientPicker) {
			UIButton *addButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
			[addButton addTarget:controller action:@selector(showRecipientPicker) forControlEvents:UIControlEventTouchUpInside];
			textField.rightView = addButton;
		}
		return textField;
	}

	-(id) persistField:(UITextField *)textField {
		if ([textField isKindOfClass:[UXPickerTextField class]]) {
			UXPickerTextField *picker = (UXPickerTextField *)textField;
			NSMutableArray *cellsData	= [NSMutableArray array];
			for (id cell in picker.cells) {
				if ([cell conformsToProtocol:@protocol(NSCoding)]) {
					NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cell];
					[cellsData addObject:data];
				}
			}
			return [NSDictionary dictionaryWithObjectsAndKeys:cellsData, @"cells",
					textField.text, @"text", nil];
		}
		else {
			return [NSDictionary dictionaryWithObjectsAndKeys:textField.text, @"text", nil];
		}
	}

	-(void) restoreField:(UITextField *)textField withData:(id)data {
		NSDictionary *dict = data;
		if ([textField isKindOfClass:[UXPickerTextField class]]) {
			UXPickerTextField *picker = (UXPickerTextField *)textField;
			NSArray *cellsData			= [dict objectForKey:@"cells"];
			[picker removeAllCells];
			for (id cellData in cellsData) {
				id cell = [NSKeyedUnarchiver unarchiveObjectWithData:cellData];
				[picker addCellWithObject:cell];
			}
		}
		textField.text = [dict objectForKey:@"text"];
	}

@end

#pragma mark -

@implementation UXMessageTextField

	@synthesize text = _text;

	-(id) init {
		if (self = [super init]) {
			_text = nil;
		}
		return self;
	}

	-(NSString *) description {
		return [NSString stringWithFormat:@"%@ %@", _title, _text];
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_text);
		[super dealloc];
	}


	#pragma mark UXMessageField

	-(UITextField *) createViewForController:(UXMessageController *)controller {
		return [[[UXPickerTextField alloc] init] autorelease];
	}

	-(id) persistField:(UITextField *)textField {
		return textField.text;
	}

	-(void) restoreField:(UITextField *)textField withData:(id)data {
		textField.text = data;
	}

@end

#pragma mark -

@implementation UXMessageSubjectField
@end

#pragma mark -

@implementation UXMessageController

	@synthesize delegate		= _delegate;
	@synthesize dataSource		= _dataSource;
	@synthesize fields			= _fields;
	@synthesize isModified		= _isModified;
	@synthesize showsRecipientPicker = _showsRecipientPicker;

	#pragma mark SPI

	-(void) cancel {
		[self cancel:YES];
	}

	-(void) createFieldViews {
		for (UIView *view in _fieldViews) {
			[view removeFromSuperview];
		}
		
		[_textEditor removeFromSuperview];
		
		[_fieldViews release];
		_fieldViews = [[NSMutableArray alloc] init];
		
		for (UXMessageField *field in _fields) {
			UXPickerTextField *textField	= [field createViewForController:self];
			if (textField) {
				textField.delegate			= self;
				textField.backgroundColor	= UXSTYLEVAR(backgroundColor);
				textField.font				= UXSTYLEVAR(messageFont);
				textField.returnKeyType		= UIReturnKeyNext;
				textField.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
				[textField sizeToFit];
				
				UILabel *label				= [[[UILabel alloc] init] autorelease];
				label.text					= field.title;
				label.font					= UXSTYLEVAR(messageFont);
				label.textColor				= UXSTYLEVAR(messageFieldTextColor);
				[label sizeToFit];
				label.frame					= CGRectInset(label.frame, -2, 0);
				textField.leftView			= label;
				textField.leftViewMode		= UITextFieldViewModeAlways;
				
				[_scrollView addSubview:textField];
				[_fieldViews addObject:textField];
				
				UIView *separator			= [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)] autorelease];
				separator.backgroundColor	= UXSTYLEVAR(messageFieldSeparatorColor);
				separator.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
				[_scrollView addSubview:separator];
			}
		}
		[_scrollView addSubview:_textEditor];
	}

	-(void) layoutViews {
		CGFloat y = 0;
		for (UIView *view in _scrollView.subviews) {
			view.frame	= CGRectMake(0, y, self.view.width, view.height);
			y			+= view.height;
		}
		_scrollView.contentSize = CGSizeMake(_scrollView.width, y);
	}

	-(BOOL) hasEnteredText {
		for (NSUInteger i = 0; i < _fields.count; ++i) {
			UXMessageField *field = [_fields objectAtIndex:i];
			if (field.required) {
				if ([field isKindOfClass:[UXMessageRecipientField class ]]) {
					UXPickerTextField *textField = [_fieldViews objectAtIndex:i];
					if (textField.cells.count) {
						return YES;
					}
				}
				else if ([field isKindOfClass:[UXMessageTextField class ]]) {
					UITextField *textField = [_fieldViews objectAtIndex:i];
					if (!textField.text.isEmptyOrWhitespace) {
						return YES;
					}
				}
			}
		}
		return _textEditor.text.length;
	}

	-(BOOL) hasRequiredText {
		BOOL compliant = YES;
		for (NSUInteger i = 0; i < _fields.count; ++i) {
			UXMessageField *field = [_fields objectAtIndex:i];
			if (field.required) {
				if ([field isKindOfClass:[UXMessageRecipientField class ]]) {
					UXPickerTextField *textField = [_fieldViews objectAtIndex:i];
					if (!textField.cells.count) {
						compliant = NO;
					}
				}
				else if ([field isKindOfClass:[UXMessageTextField class ]]) {
					UITextField *textField = [_fieldViews objectAtIndex:i];
					if (textField.text.isEmptyOrWhitespace) {
						compliant = NO;
					}
				}
			}
		}
		return compliant && _textEditor.text.length;
	}

	-(void) updateSendCommand {
		self.navigationItem.rightBarButtonItem.enabled = [self hasRequiredText];
	}

	-(UITextField *) subjectField {
		for (NSUInteger i = 0; i < _fields.count; ++i) {
			UXMessageField *field = [_fields objectAtIndex:i];
			if ([field isKindOfClass:[UXMessageSubjectField class]]) {
				return [_fieldViews objectAtIndex:i];
			}
		}
		return nil;
	}

	-(void) setTitleToSubject {
		UITextField *subjectField		= self.subjectField;
		if (subjectField) {
			self.navigationItem.title	= subjectField.text;
		}
		[self updateSendCommand];
	}

	-(NSInteger) fieldIndexOfFirstResponder {
		NSInteger index = 0;
		for (UIView *view in _fieldViews) {
			if ([view isFirstResponder]) {
				return index;
			}
			++index;
		}
		if (_textEditor.isFirstResponder) {
			return _fieldViews.count;
		}
		return -1;
	}

	-(void) setFieldIndexOfFirstResponder:(NSInteger)index {
		if (index < _fieldViews.count) {
			UIView *view = [_fieldViews objectAtIndex:index];
			[view becomeFirstResponder];
		}
		else {
			[_textEditor becomeFirstResponder];
		}
	}

	-(void) showRecipientPicker {
		[self messageWillShowRecipientPicker];
		if ([_delegate respondsToSelector:@selector(composeControllerShowRecipientPicker:)]) {
			[_delegate composeControllerShowRecipientPicker:self];
		}
	}


	#pragma mark Initializers

	-(id) initWithRecipients:(NSArray *)recipients {
		if (self = [self init]) {
			_initialRecipients = [recipients retain];
		}
		return self;
	}

	-(id) init {
		if (self = [super init]) {
			_delegate				= nil;
			_dataSource				= nil;
			_fields					= [[NSArray alloc] initWithObjects:
										[[[UXMessageRecipientField alloc] initWithTitle:UXLocalizedString(@"To:", @"") required:YES] autorelease],
										[[[UXMessageSubjectField alloc] initWithTitle:UXLocalizedString(@"Subject:", @"") required:NO] autorelease], nil];
			_fieldViews				= nil;
			_initialRecipients		= nil;
			_activityView			= nil;
			_showsRecipientPicker	= NO;
			_isModified				= NO;
			self.title				= UXLocalizedString(@"New Message", @"");
			
			self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:UXLocalizedString(@"Cancel", @"")
																					  style:UIBarButtonItemStyleBordered 
																					  target:self 
																					  action:@selector(cancel)] autorelease];
			self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:UXLocalizedString(@"Send", @"")
																					   style:UIBarButtonItemStyleDone 
																					   target:self 
																					   action:@selector(send)] autorelease];
			self.navigationItem.rightBarButtonItem.enabled = NO;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_scrollView);
		UX_SAFE_RELEASE(_fieldViews);
		UX_SAFE_RELEASE(_textEditor);
		UX_SAFE_RELEASE(_dataSource);
		UX_SAFE_RELEASE(_fields);
		UX_SAFE_RELEASE(_initialRecipients);
		UX_SAFE_RELEASE(_activityView);
		[super dealloc];
	}


	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
		self.view.backgroundColor					= UXSTYLEVAR(backgroundColor);
		
		_scrollView									= [[UIScrollView  alloc] initWithFrame:UXKeyboardNavigationFrame()];
		_scrollView.backgroundColor					= UXSTYLEVAR(backgroundColor);
		_scrollView.autoresizingMask				= (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
		_scrollView.canCancelContentTouches			= NO;
		_scrollView.showsVerticalScrollIndicator	= NO;
		_scrollView.showsHorizontalScrollIndicator	= NO;
		[self.view addSubview:_scrollView];
		
		_textEditor									= [[UXTextEditor alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, 0)];
		_textEditor.delegate						= self;
		_textEditor.backgroundColor					= UXSTYLEVAR(backgroundColor);
		_textEditor.font							= UXSTYLEVAR(messageFont);
		_textEditor.autoresizingMask				= UIViewAutoresizingFlexibleWidth;
		_textEditor.autoresizesToText				= YES;
		_textEditor.showsExtraLine					= YES;
		_textEditor.minNumberOfLines				= 6;
		[_textEditor sizeToFit];
		
		[self createFieldViews];
		[self layoutViews];
	}

	-(void) viewDidUnload {
		[super viewDidUnload];
		UX_SAFE_RELEASE(_scrollView);
		UX_SAFE_RELEASE(_fieldViews);
		UX_SAFE_RELEASE(_textEditor);
		UX_SAFE_RELEASE(_activityView);
	}

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
		if (_initialRecipients) {
			for (id recipient in _initialRecipients) {
				[self addRecipient:recipient forFieldAtIndex:0];
			}
			UX_SAFE_RELEASE(_initialRecipients);
		}
		
		if (!_frozenState) {
			for (NSInteger i = 0; i < _fields.count + 1; ++i) {
				if (![self fieldHasValueAtIndex:i]) {
					UIView *view = [self viewForFieldAtIndex:i];
					[view becomeFirstResponder];
					return;
				}
			}
			[[self viewForFieldAtIndex:0] becomeFirstResponder];
		}
		[self updateSendCommand];
	}

	-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		return UXIsSupportedOrientation(interfaceOrientation);
	}

	-(void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
		[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
		_scrollView.height = self.view.height - UXKeyboardHeight();
		[self layoutViews];
	}


	#pragma mark (UIXViewController)

	-(BOOL) persistView:(NSMutableDictionary *)state {
		NSMutableArray *fields = [NSMutableArray array];
		for (NSInteger i = 0; i < _fields.count; ++i) {
			UXMessageField *field		= [_fields objectAtIndex:i];
			UITextField *view			= [_fieldViews objectAtIndex:i];
			id data						= [field persistField:view];
			if (data) {
				[fields addObject:data];
			}
			else {
				[fields addObject:@""];
			}
		}
		[state setObject:fields forKey:@"fields"];
		
		NSString *body = self.body;
		if (body) {
			[state setObject:body forKey:@"body"];
		}
		
		CGFloat scrollY				= _scrollView.contentOffset.y;
		[state setObject:[NSNumber numberWithFloat:scrollY] forKey:@"scrollOffsetY"];
		
		NSInteger firstResponder	= [self fieldIndexOfFirstResponder];
		[state setObject:[NSNumber numberWithInt:firstResponder] forKey:@"firstResponder"];
		[state setObject:[NSNumber numberWithBool:YES] forKey:@"__important__"];
		return [super persistView:state];
	}

	-(void) restoreView:(NSDictionary *)state {
		self.view;
		UX_SAFE_RELEASE(_initialRecipients);
		NSMutableArray *fields = [state objectForKey:@"fields"];
		for (NSInteger i = 0; i < fields.count; ++i) {
			UXMessageField *field = [_fields objectAtIndex:i];
			UITextField *view		= [_fieldViews objectAtIndex:i];
			id data					= [fields objectAtIndex:i];
			if (data != [NSNull null]) {
				[field restoreField:view withData:data];
			}
		}
		
		NSString *body = [state objectForKey:@"body"];
		if (body) {
			self.body = body;
		}
		
		NSNumber *scrollY			= [state objectForKey:@"scrollOffsetY"];
		_scrollView.contentOffset	= CGPointMake(0, scrollY.floatValue);
		NSInteger firstResponder	= [[state objectForKey:@"firstResponder"] intValue];
		[self setFieldIndexOfFirstResponder:firstResponder];
	}


	#pragma mark <UITextFieldDelegate>

	-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
		if (textField == self.subjectField) {
			_isModified = YES;
			[NSTimer scheduledTimerWithTimeInterval:0 
											 target:self 
										   selector:@selector(setTitleToSubject) 
										   userInfo:nil 
											repeats:NO];
		}
		return YES;
	}

	-(BOOL) textFieldShouldReturn:(UITextField *)textField {
		NSUInteger fieldIndex	= [_fieldViews indexOfObject:textField];
		UIView *nextView		= fieldIndex == _fieldViews.count - 1 ? _textEditor : [_fieldViews objectAtIndex:fieldIndex + 1];
		[nextView becomeFirstResponder];
		return NO;
	}

	-(void) textField:(UXPickerTextField *)textField didAddCellAtIndex:(NSInteger)index {
		[self updateSendCommand];
	}

	-(void) textField:(UXPickerTextField *)textField didRemoveCellAtIndex:(NSInteger)index {
		[self updateSendCommand];
	}

	-(void) textFieldDidResize:(UXPickerTextField *)textField {
		[self layoutViews];
	}


	#pragma mark <UXTextEditorDelegate>

	-(void) textEditorDidChange:(UXTextEditor *)textEditor {
		[self updateSendCommand];
		_isModified = YES;
	}

	-(BOOL) textEditor:(UXTextEditor *)textEditor shouldResizeBy:(CGFloat)height {
		_textEditor.frame = UXRectContract(_textEditor.frame, 0, -height);
		[self layoutViews];
		[_textEditor scrollContainerToCursor:_scrollView];
		return NO;
	}


	#pragma mark <UIAlertViewDelegate>

	-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
		if (buttonIndex == 0) {
			[self cancel:NO];
		}
	}


	#pragma mark API

	-(NSString *) subject {
		self.view;
		for (int i = 0; i < _fields.count; ++i) {
			id field = [_fields objectAtIndex:i];
			if ([field isKindOfClass:[UXMessageSubjectField class]]) {
				UITextField *textField = [_fieldViews objectAtIndex:i];
				return textField.text;
			}
		}
		return nil;
	}

	-(void) setSubject:(NSString *)subject {
		self.view;
		for (int i = 0; i < _fields.count; ++i) {
			id field = [_fields objectAtIndex:i];
			if ([field isKindOfClass:[UXMessageSubjectField class]]) {
				UITextField *textField	= [_fieldViews objectAtIndex:i];
				textField.text			= subject;
				break;
			}
		}
	}

	-(NSString *) body {
		return _textEditor.text;
	}

	-(void) setBody:(NSString *)aBodyString {
		self.view;
		_textEditor.text = aBodyString;
	}

	-(void) setDataSource:(id <UXTableViewDataSource>)dataSource {
		if (dataSource != _dataSource) {
			[_dataSource release];
			_dataSource = [dataSource retain];
			
			for (UITextField *textField in _fieldViews) {
				if ([textField isKindOfClass:[UXPickerTextField class]]) {
					UXPickerTextField *menuTextField	= (UXPickerTextField *)textField;
					menuTextField.dataSource			= dataSource;
				}
			}
		}
	}

	-(void) setFields:(NSArray *)fields {
		if (fields != _fields) {
			[_fields release];
			_fields = [fields retain];
			if (_fieldViews) {
				[self createFieldViews];
			}
		}
	}

	-(void) addRecipient:(id)recipient forFieldAtIndex:(NSUInteger)fieldIndex {
		self.view;
		UXPickerTextField *textField = [_fieldViews objectAtIndex:fieldIndex];
		if ([textField isKindOfClass:[UXPickerTextField class]]) {
			NSString *label = [_dataSource tableView:textField.tableView labelForObject:recipient];
			if (label) {
				[textField addCellWithObject:recipient];
			}
		}
	}

	-(NSString *) textForFieldAtIndex:(NSUInteger)fieldIndex {
		self.view;
		
		NSString *text = nil;
		if (fieldIndex == _fieldViews.count) {
			text = _textEditor.text;
		}
		else {
			UXPickerTextField *textField = [_fieldViews objectAtIndex:fieldIndex];
			if ([textField isKindOfClass:[UXPickerTextField class]]) {
				text = textField.text;
			}
		}
		
		NSCharacterSet *whitespace = [NSCharacterSet whitespaceCharacterSet];
		return [text stringByTrimmingCharactersInSet:whitespace];
	}

	-(void) setText:(NSString *)text forFieldAtIndex:(NSUInteger)fieldIndex {
		self.view;
		if (fieldIndex == _fieldViews.count) {
			_textEditor.text = text;
		}
		else {
			UXPickerTextField *textField = [_fieldViews objectAtIndex:fieldIndex];
			if ([textField isKindOfClass:[UXPickerTextField class]]) {
				textField.text = text;
			}
		}
	}

	-(BOOL) fieldHasValueAtIndex:(NSUInteger)fieldIndex {
		self.view;
		
		if (fieldIndex == _fieldViews.count) {
			return _textEditor.text.length > 0;
		}
		else {
			UXMessageField *field = [_fields objectAtIndex:fieldIndex];
			if ([field isKindOfClass:[UXMessageRecipientField class]]) {
				UXPickerTextField *pickerTextField = [_fieldViews objectAtIndex:fieldIndex];
				return !pickerTextField.text.isEmptyOrWhitespace || pickerTextField.cellViews.count > 0;
			}
			else {
				UITextField *textField = [_fieldViews objectAtIndex:fieldIndex];
				return !textField.text.isEmptyOrWhitespace;
			}
		}
	}

	-(UIView *) viewForFieldAtIndex:(NSUInteger)fieldIndex {
		self.view;
		
		if (fieldIndex == _fieldViews.count) {
			return _textEditor;
		}
		else {
			return [_fieldViews objectAtIndex:fieldIndex];
		}
	}

	-(void) send {
		NSMutableArray *fields = [[_fields mutableCopy] autorelease];
		for (int i = 0; i < fields.count; ++i) {
			id field = [fields objectAtIndex:i];
			if ([field isKindOfClass:[UXMessageRecipientField class]]) {
				UXPickerTextField *textField = [_fieldViews objectAtIndex:i];
				[(UXMessageRecipientField *)field setRecipients:textField.cells];
			}
			else if ([field isKindOfClass:[UXMessageTextField class]]) {
				UITextField *textField = [_fieldViews objectAtIndex:i];
				[(UXMessageTextField *)field setText:textField.text];
			}
		}
		
		UXMessageTextField *bodyField = [[[UXMessageTextField alloc] initWithTitle:nil required:NO] autorelease];
		bodyField.text					= _textEditor.text;
		[fields addObject:bodyField];
		
		[self showActivityView:TRUE];
		[self messageWillSend:fields];
		
		if ([_delegate respondsToSelector:@selector(composeController:didSendFields:)]) {
			[_delegate composeController:self didSendFields:fields];
		}
		
		[self messageDidSend];
	}

	-(void) cancel:(BOOL)confirmIfNecessary {
		if (confirmIfNecessary && ![self messageShouldCancel]) {
			[self confirmCancellation];
		}
		else {
			if ([_delegate respondsToSelector:@selector(composeControllerWillCancel:)]) {
				[_delegate composeControllerWillCancel:self];
			}
			[self dismissModalViewController];
		}
	}

	-(void) confirmCancellation {
		UIAlertView *cancelAlertView = [[[UIAlertView alloc] initWithTitle:UXLocalizedString(@"Cancel?", @"")
																   message:UXLocalizedString(@"Are you sure you want to cancel?", @"")
																  delegate:self
														 cancelButtonTitle:UXLocalizedString(@"Yes", @"")
														 otherButtonTitles:UXLocalizedString(@"No", @""), nil] autorelease];
		[cancelAlertView show];
	}
	
	-(void) showActivityView:(BOOL)show {
		self.navigationItem.rightBarButtonItem.enabled = !show;
		if (show) {
			if (!_activityView) {
				CGRect frame		= CGRectMake(0, 0, self.view.width, _scrollView.height);
				_activityView		= [[UXActivityLabel alloc] initWithFrame:frame style:UXActivityLabelStyleWhiteBox];
				_activityView.text	= [self titleForSending];
				[self.view addSubview:_activityView];
				_activityView.autoresizingMask	= UIViewAutoresizingFlexibleWidth;
			}
		}
		else {
			[_activityView removeFromSuperview];
			UX_SAFE_RELEASE(_activityView);
		}
	}

	-(NSString *) titleForSending {
		return UXLocalizedString(@"Sending...", @"");
	}

	-(BOOL) messageShouldCancel {
		return ![self hasEnteredText] || !_isModified;
	}

	-(void) messageWillShowRecipientPicker {
	
	}

	-(void) messageWillSend:(NSArray *)fieldList {
	
	}

	-(void) messageDidSend {
	
	}

@end
