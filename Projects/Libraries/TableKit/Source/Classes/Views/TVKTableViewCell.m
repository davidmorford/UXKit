
#import <TableKit/TVKTableViewCell.h>
#import <TableKit/TVKTableItem.h>
#import <QuartzCore/QuartzCore.h>

@implementation TVKTableViewCell

@end

#pragma mark -

@interface TVKEditingTableViewCell ()
	-(void) setDefaultAttributes:(UITextField *)aTextField from:(UILabel *)aLabel;
@end

#pragma mark -

@implementation TVKEditingTableViewCell

	@synthesize textField;
	@synthesize detailTextField;
	@synthesize textColor;
	@synthesize highlightedTextColor;


	#pragma mark Initializer

	-(id) initWithStyle:(TVKTableViewCellStyle)editingStyle reuseIdentifier:(NSString *)identifier {
		if (editingStyle < TVKTableViewCellEditingStyleDefault) {
			return [super initWithStyle:editingStyle reuseIdentifier:identifier];
		}
		else {
			if (self = [super initWithStyle:(editingStyle - TVKTableViewCellEditingStyleDefault) reuseIdentifier:identifier]) {
				style = editingStyle;
				if (style == TVKTableViewCellEditingStyleDefault) {
					textField				= [[UITextField alloc] initWithFrame:CGRectZero];
					//textField.delegate		= self;
					//textField.returnKeyType = UIReturnKeyDone;
					[self setDefaultAttributes:textField from:self.textLabel];
					[self.contentView addSubview:textField];
					self.textLabel.hidden	= YES;
				}
				else {
					detailTextField					= [[UITextField alloc] initWithFrame:CGRectZero];
					//detailTextField.delegate		= self;
					//detailTextField.returnKeyType	= UIReturnKeyDone;
					[self setDefaultAttributes:detailTextField from:self.detailTextLabel];
					[self.contentView addSubview:detailTextField];
					self.detailTextLabel.hidden = YES;
					if (style == TVKTableViewCellEditingStyleValue1) {
						detailTextField.textAlignment = UITextAlignmentRight;
					}
				}
				self.selectionStyle = UITableViewCellSelectionStyleNone;
			}
			return self;
		}
	}


	#pragma mark UITableViewCell

	-(void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
		[super setHighlighted:highlighted animated:animated];
		if (textField) {
			textField.textColor = highlighted ? self.highlightedTextColor : self.textColor;
		}
		if (detailTextField) {
			detailTextField.textColor = highlighted ? self.highlightedTextColor : self.textColor;
		}
	}

	-(void) setSelected:(BOOL)selected animated:(BOOL)animated {
		[super setSelected:selected animated:animated];
	}

	//-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
//		[super setEditing:editing animated:animated];
//		if (textField) {
//			textField.enabled = editing;
//		}
//		if (detailTextField) {
//			detailTextField.enabled = editing;
//		}
//	}


	#pragma mark -

	-(void) setDefaultAttributes:(UITextField *)field from:(UILabel *)label {
		field.autoresizingMask		= label.autoresizingMask;
		field.font					= [UIFont boldSystemFontOfSize:0];
		field.borderStyle			= UITextBorderStyleNone;
		field.clearButtonMode		= UITextFieldViewModeWhileEditing;
		self.textColor				= label.textColor;
		self.highlightedTextColor	= label.highlightedTextColor;
	}

	-(void) setEditingStyleFontSizeIfNeeds {
		UITableView *tableView = (UITableView *)[self superview];
		UITableViewStyle editingStyle = tableView ? tableView.style : UITableViewStyleGrouped;
		CGFloat height	= self.contentView.frame.size.height;
		CGFloat delta	= height - (editingStyle == UITableViewStylePlain ? 43 : 44);
		
		if (textField && (textField.font.pointSize == 0)) {
			CGFloat size = 20;
			switch (style) {
				case TVKTableViewCellEditingStyleDefault:
					size = height - (43 - (style == UITableViewStylePlain ? 20 : 17));
					break;
			}
			textField.font = [UIFont boldSystemFontOfSize:size];
		}
		if (detailTextField && (detailTextField.font.pointSize == 0)) {
			BOOL bold		= NO;
			CGFloat size	= 20;
			switch (style) {
				case TVKTableViewCellEditingStyleValue1:
					size = height - (43 - (style == UITableViewStylePlain ? 20 : 17));
					break;
				case TVKTableViewCellEditingStyleValue2:
				{
					bold					= YES;
					size					= delta + (style == UITableViewStylePlain ? 15 : 16);
					UIFont *font			= self.textLabel.font;
					CGFloat labelFontSize	= delta + font.pointSize + (style == UITableViewStylePlain ? 0 : 1);
					self.textLabel.font		= [UIFont fontWithName:font.fontName size:labelFontSize];
				}
					break;
				case TVKTableViewCellEditingStyleSubtitle:
					size = delta + (style == UITableViewStylePlain ? 14 : 14);
					break;
			}
			if (bold) {
				detailTextField.font = [UIFont boldSystemFontOfSize:size];
			}
			else {
				detailTextField.font = [UIFont systemFontOfSize:size];
			}
			detailTextField.font = [UIFont fontWithName:detailTextField.font.fontName size:size];
		}
	}

	-(void) setFontSizeIfNeeds {
		if (style >= TVKTableViewCellEditingStyleDefault) {
			[self setEditingStyleFontSizeIfNeeds];
		}
	}


	#pragma mark Layout

	-(void) layoutSubviewsWhenStyleDefault {
		CGRect contentRect	= self.contentView.bounds;
		CGRect rect			= CGRectInset(contentRect, 10, 0);
		CGFloat height		= contentRect.size.height;
		CGFloat textHeight	= textField.font.pointSize + 4;
		CGFloat y			= (NSInteger)((height - textHeight) / 2);
		textField.frame		= CGRectMake(rect.origin.x, y, rect.size.width, textHeight);
	}

	-(void) layoutSubviewsWhenStyleValue1 {
		UITableView *tableView	= (UITableView *)[self superview];
		CGRect contentRect		= self.contentView.bounds;
		CGFloat height			= contentRect.size.height;
		
		CGFloat textWidth		= contentRect.size.width - 20 - (tableView.style == UITableViewStylePlain ? 101 : 85) - 5;
		CGFloat textHeight		= detailTextField.font.pointSize + 4;
		CGFloat y				= (NSInteger)((height - textHeight) / 2);
		detailTextField.frame	= CGRectMake(contentRect.size.width - 10 - textWidth, y, textWidth, textHeight);
	}

	-(void) layoutSubviewsWhenStyleValue2 {
		CGRect contentRect		= self.contentView.bounds;
		CGFloat width			= contentRect.size.width;
		
		CGFloat textHeight		= detailTextField.font.pointSize + 4;
		CGFloat x				= CGRectGetMaxX(self.textLabel.frame) + 5;
		detailTextField.frame	= CGRectMake(x, 12, width - 20 - 68 - 5, textHeight);
	}

	-(void) layoutSubviewsWhenStyleSubtitle {
		CGRect contentRect		= self.contentView.bounds;
		CGFloat width			= contentRect.size.width;
		
		CGFloat textHeight		= detailTextField.font.pointSize + 4;
		CGFloat y				= self.textLabel.font.pointSize + 4 + 2;
		detailTextField.frame	= CGRectMake(11, y, width - 21, textHeight);
	}

	-(void) layoutSubviews {
		[super layoutSubviews];
		[self setFontSizeIfNeeds];
		switch (style) {
			case TVKTableViewCellEditingStyleDefault:
				[self layoutSubviewsWhenStyleDefault];
				break;
			case TVKTableViewCellEditingStyleValue1:
				[self layoutSubviewsWhenStyleValue1];
				break;
			case TVKTableViewCellEditingStyleValue2:
				[self layoutSubviewsWhenStyleValue2];
				break;
			case TVKTableViewCellEditingStyleSubtitle:
				[self layoutSubviewsWhenStyleSubtitle];
				break;
		}
	}


	#pragma mark <UITextFieldDelegate>

	-(void) textFieldDidEndEditing:(UITextField *)field {
		[self resignFirstResponder];
	}

	-(BOOL) textFieldShouldReturn:(UITextField *)field {
		[field resignFirstResponder];
		return TRUE;
	}


	#pragma mark -

	-(void) dealloc {
		[textColor release];
		[highlightedTextColor release];
		[textField release];
		[detailTextField release];
		[super dealloc];
	}

@end

#pragma mark -

@implementation TVKTableViewContentCell

	-(id) initWithContentViewClass:(Class)contentViewClass {
		if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TVKTableViewContentCellID"]) {
			cellContentView						= [[contentViewClass alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 0.0) cell:self];
			cellContentView.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			cellContentView.contentMode			= UIViewContentModeRedraw;
			self.backgroundView = cellContentView;
		}
		return self;
	}

	-(id) initWithContentViewClass:(Class)contentViewClass text:(NSString *)textString subtitle:(NSString *)subtitleString image:(UIImage *)image {
		if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TVKTableViewContentCellSubtitleID"]) {
			cellContentView						= [[contentViewClass alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 0.0) cell:self];
			cellContentView.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			cellContentView.contentMode			= UIViewContentModeRedraw;
			//[self.contentView addSubview:cellContentView];
			self.backgroundView = cellContentView;
			
			self.textLabel.text					= textString;
			self.textLabel.backgroundColor		= [UIColor clearColor];
			self.textLabel.textColor			= [UIColor colorWithWhite:0.05 alpha:1.0];
			self.textLabel.shadowColor			= [UIColor colorWithWhite:0.9 alpha:1.0];
			self.textLabel.highlightedTextColor = [UIColor colorWithWhite:0.0 alpha:1.0];
			self.textLabel.shadowOffset			= CGSizeMake(0.0, 1.0);
			
			self.detailTextLabel.text					= subtitleString;
			self.detailTextLabel.backgroundColor		= [UIColor clearColor];
			self.detailTextLabel.textColor				= [UIColor colorWithWhite:0.05 alpha:1.0];
			self.detailTextLabel.shadowColor			= [UIColor colorWithWhite:0.9 alpha:1.0];
			self.detailTextLabel.highlightedTextColor	= [UIColor colorWithWhite:0.0 alpha:1.0];
			self.detailTextLabel.shadowOffset			= CGSizeMake(0.0, 1.0);
			self.detailTextLabel.numberOfLines			= 3;
			self.imageView.image = image;
		}
		return self;
	}

//	-(UIView *) contentView {
//		return cellContentView;
//	}


	/*-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
			cellContentView						= [[TVKTableViewCellContentView alloc] initWithFrame:CGRectInset(self.contentView.bounds, 0.0, 1.0) cell:self];
			cellContentView.autoresizingMask	= UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
			cellContentView.contentMode			= UIViewContentModeRedraw;
			[self.contentView addSubview:cellContentView];
		}
		return self;
	}*/

	-(void) setFrame:(CGRect)frame {
		[super setFrame:frame];
		[UIView setAnimationsEnabled:NO];
		CGSize contentSize				= cellContentView.bounds.size;
		cellContentView.contentStretch	= CGRectMake(225.0 / contentSize.width, 0.0, (contentSize.width - 260.0) / contentSize.width, 1.0);
		[UIView setAnimationsEnabled:YES];
	}

	/*-(void) setBackgroundColor:(UIColor *)backgroundColor {
		[super setBackgroundColor:backgroundColor];
	}*/

	-(void) setEditing:(BOOL)editing animated:(BOOL)animated {
		[super setEditing:editing animated:animated];
		/*
		for (UIControl *control in fields) {
			control.enabled = editing;
		}
		*/
	}

	/*!
	When the table view becomes editable, the cell should:
		* Hide the location label (so that the Delete button does not overlap it)
		* Enable the name field (to make it editable)
		* Display the tags button
		* Set a placeholder for the tags field (so the user knows to tap to edit tags)
	The inverse applies when the table view has finished editing.
	*/
	-(void) willTransitionToState:(UITableViewCellStateMask)state {
		[super willTransitionToState:state];
		if (state & UITableViewCellStateEditingMask) {
			self.detailTextLabel.hidden	= TRUE;
			self.imageView.hidden		= TRUE;
			//textField.enabled	= YES;
			//button.hidden		= NO;
			//field.placeholder	= @"Tap to edit";
		}
	}

	-(void) didTransitionToState:(UITableViewCellStateMask)state {
		[super didTransitionToState:state];
		if (!(state & UITableViewCellStateEditingMask)) {
			self.detailTextLabel.hidden	= FALSE;
			self.imageView.hidden		= FALSE;
			//label.hidden		= NO;
			//textField.enabled	= NO;
			//button.hidden		= YES;
			//field.placeholder	= @"";
		}
	}

	/*!
	The default setSelected:animated: method sets the textLabel and
	detailTextLabel background to white when invoked (which is
	on every construction). This override undoes that and sets their background
	to clearColor.
	*/
	-(void) setSelected:(BOOL)selected animated:(BOOL)animated {
		[super setSelected:selected animated:animated];
		// This is prolly silly... Why not just use the background color of the cell or contentView?
		/*if (clearSelectedLabel) {
			self.textLabel.backgroundColor = [UIColor clearColor];
			self.detailTextLabel.backgroundColor = [UIColor clearColor];
		}*/
	}
	

	#pragma mark -

	-(void) layoutSubviews {
		[super layoutSubviews];
	}

	#pragma mark -

	-(void) dealloc {
		[cellContentView release]; cellContentView = nil;
		[super dealloc];
	}

@end

#pragma mark -

@implementation TVKTableViewCellContentView

	-(id) initWithFrame:(CGRect)frame cell:(TVKTableViewContentCell *)tableViewCell {
		if (self = [super initWithFrame:frame]) {
			cell					= tableViewCell;
			self.opaque				= YES;
			self.backgroundColor	= cell.backgroundColor;
		}
		return self;
	}

	-(void) setHighlighted:(BOOL)flag {
		highlighted = flag;
		[self setNeedsDisplay];
	}

	-(BOOL) isHighlighted {
		return highlighted;
	}

@end

#pragma mark -

@interface TVKTableViewCellGradientContentView ()
	-(void) setupGradientLayer;
@end

#pragma mark -

@implementation TVKTableViewCellGradientContentView

	/*!
	@abstract Returns a CAGradientLayer class as the default layer class for this view
	*/
	+(Class) layerClass {
		return [CAGradientLayer class];
	}

	-(id) initWithFrame:(CGRect)frame cell:(TVKTableViewContentCell *)tableViewCell {
		if (self = [super initWithFrame:frame cell:tableViewCell]) {
			[self setupGradientLayer];
		}
		return self;
	}

	-(id) initWithFrame:(CGRect)frame {
		self = [super initWithFrame:frame];
		if (self) {
			CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
			gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor,
															 (id)[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0].CGColor, nil];
			self.backgroundColor = [UIColor clearColor];
		}
		return self;
	}

	-(void) setupGradientLayer {
		CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
		gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0].CGColor,
														 (id)[UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0].CGColor, nil];
		self.backgroundColor = [UIColor clearColor];
	}

@end
