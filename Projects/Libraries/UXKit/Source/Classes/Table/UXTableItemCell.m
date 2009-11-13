
#import <UXKit/UXTableItemCell.h>
#import <UXKit/UXTableItem.h>
#import <UXKit/UXImageView.h>
#import <UXKit/UXErrorView.h>
#import <UXKit/UXStyledNode.h>
#import <UXKit/UXStyledText.h>
#import <UXKit/UXStyledTextLabel.h>
#import <UXKit/UXActivityLabel.h>
#import <UXKit/UXTextEditor.h>
#import <UXKit/UXURLMap.h>
#import <UXKit/UXNavigator.h>
#import <UXKit/UXURLCache.h>
#import <UXKit/UXDefaultStyleSheet.h>

static const CGFloat kHPadding					= 10;
static const CGFloat kVPadding					= 10;
static const CGFloat kMargin					= 10;
static const CGFloat kSmallMargin				= 6;
static const CGFloat kSpacing					= 8;
static const CGFloat kControlPadding			= 8;
static const CGFloat kDefaultTextViewLines		= 5;
static const CGFloat kMoreButtonMargin			= 40;

static const CGFloat kKeySpacing				= 12;
static const CGFloat kKeyWidth					= 75;
static const CGFloat kMaxLabelHeight			= 2000;
static const CGFloat kDisclosureIndicatorWidth	= 23;

static const NSInteger kMessageTextLineCount	= 2;

static const CGFloat kDefaultImageSize			= 50;
static const CGFloat kDefaultMessageImageWidth	= 34;
static const CGFloat kDefaultMessageImageHeight = 34;

#pragma mark -

@implementation UXTableLinkedItemCell

	#pragma mark Initializer

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
			_item = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_item);
		[super dealloc];
	}


	#pragma mark UXTableViewCell

	-(id) object {
		return _item;
	}

	-(void) setObject:(id)object {
		if (_item != object) {
			[_item release];
			_item = [object retain];
			
			UXTableLinkedItem *item = object;
			if (item.URL) {
				UXNavigationMode navigationMode = [[UXNavigator navigator].URLMap navigationModeForURL:item.URL];
				if (item.accessoryURL) {
					self.accessoryType	= UITableViewCellAccessoryDetailDisclosureButton;
				}
				else if (navigationMode == UXNavigationModeCreate) {
					self.accessoryType	= UITableViewCellAccessoryDisclosureIndicator;
				}
				else if (navigationMode == UXNavigationModeNone) {
					self.accessoryType	= UITableViewCellAccessoryDisclosureIndicator;
				}
				else {
					self.accessoryType	= UITableViewCellAccessoryNone;
				}
				self.selectionStyle		= UXSTYLEVAR(tableSelectionStyle);
			}
			else {
				self.accessoryType		= UITableViewCellAccessoryNone;
				self.selectionStyle		= UITableViewCellSelectionStyleNone;
			}
		}
	}

@end

#pragma mark -

@implementation UXTableTextItemCell

	+(UIFont *) textFontForItem:(UXTableTextItem *)item {
		if ([item isKindOfClass:[UXTableLongTextItem class]]) {
			return UXSTYLEVAR(font);
		}
		else if ([item isKindOfClass:[UXTableGrayTextItem class]]) {
			return UXSTYLEVAR(font);
		}
		else {
			return UXSTYLEVAR(tableFont);
		}
	}

	
	#pragma mark UXTableViewCell

	+(CGFloat) tableView:(UITableView *)tableView rowHeightForObject:(id)object {
		UXTableTextItem *item = object;
		CGFloat width	= tableView.width - (kHPadding * 2 + [tableView tableCellMargin] * 2);
		UIFont *font	= [self textFontForItem:item];
		CGSize size		= [item.text sizeWithFont:font constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeTailTruncation];
		if (size.height > kMaxLabelHeight) {
			size.height = kMaxLabelHeight;
		}
		return size.height + kVPadding * 2;
	}

	
	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
			self.textLabel.highlightedTextColor = UXSTYLEVAR(highlightedTextColor);
			self.textLabel.lineBreakMode		= UILineBreakModeWordWrap;
			self.textLabel.numberOfLines		= 0;
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		self.textLabel.frame = CGRectInset(self.contentView.bounds, kHPadding, kVPadding);
	}


	#pragma mark UXTableViewCell

	-(void) setObject:(id)object {
		if (_item != object) {
			[super setObject:object];
			
			UXTableTextItem *item = object;
			self.textLabel.text = item.text;
			
			if ([object isKindOfClass:[UXTableButton class]]) {
				self.textLabel.font				= UXSTYLEVAR(tableButtonFont);
				self.textLabel.textColor		= UXSTYLEVAR(linkTextColor);
				self.textLabel.textAlignment	= UITextAlignmentCenter;
				self.accessoryType				= UITableViewCellAccessoryNone;
				self.selectionStyle				= UXSTYLEVAR(tableSelectionStyle);
			}
			else if ([object isKindOfClass:[UXTableLink class]]) {
				self.textLabel.font				= UXSTYLEVAR(tableFont);
				self.textLabel.textColor		= UXSTYLEVAR(linkTextColor);
				self.textLabel.textAlignment	= UITextAlignmentLeft;
			}
			else if ([object isKindOfClass:[UXTableSummaryItem class]]) {
				self.textLabel.font				= UXSTYLEVAR(tableSummaryFont);
				self.textLabel.textColor		= UXSTYLEVAR(tableSubTextColor);
				self.textLabel.textAlignment	= UITextAlignmentCenter;
			}
			else if ([object isKindOfClass:[UXTableLongTextItem class]]) {
				self.textLabel.font				= UXSTYLEVAR(font);
				self.textLabel.textColor		= UXSTYLEVAR(textColor);
				self.textLabel.textAlignment	= UITextAlignmentLeft;
			}
			else if ([object isKindOfClass:[UXTableGrayTextItem class]]) {
				self.textLabel.font				= UXSTYLEVAR(font);
				self.textLabel.textColor		= UXSTYLEVAR(tableSubTextColor);
				self.textLabel.textAlignment	= UITextAlignmentLeft;
			}
			else {
				self.textLabel.font				= UXSTYLEVAR(tableFont);
				self.textLabel.textColor		= UXSTYLEVAR(textColor);
				self.textLabel.textAlignment	= UITextAlignmentLeft;
			}
		}
	}

@end

#pragma mark -

@implementation UXTableCaptionItemCell


	#pragma mark UXTableViewCell

	+(CGFloat) tableView:(UITableView *)tableView rowHeightForObject:(id)object {
		UXTableCaptionItem *item = object;
		
		CGFloat margin			= [tableView tableCellMargin];
		CGFloat width			= tableView.width - (kKeyWidth + kKeySpacing + kHPadding * 2 + margin * 2);
		CGSize detailTextSize	= [item.text sizeWithFont:UXSTYLEVAR(tableSmallFont) constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
		
		return detailTextSize.height + kVPadding * 2;
	}


	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
			self.textLabel.font = UXSTYLEVAR(tableTitleFont);
			self.textLabel.textColor = UXSTYLEVAR(linkTextColor);
			self.textLabel.highlightedTextColor = UXSTYLEVAR(highlightedTextColor);
			self.textLabel.textAlignment = UITextAlignmentRight;
			self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
			self.textLabel.numberOfLines = 1;
			self.textLabel.adjustsFontSizeToFitWidth = YES;
			
			self.detailTextLabel.font = UXSTYLEVAR(tableSmallFont);
			self.detailTextLabel.textColor = UXSTYLEVAR(textColor);
			self.detailTextLabel.highlightedTextColor = UXSTYLEVAR(highlightedTextColor);
			self.detailTextLabel.adjustsFontSizeToFitWidth = YES;
			self.detailTextLabel.minimumFontSize = 8;
			self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
			self.detailTextLabel.numberOfLines = 0;
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		
		self.textLabel.frame = CGRectMake(kHPadding, kVPadding,
										  kKeyWidth, self.textLabel.font.lineHeight);
		
		CGFloat valueWidth = self.contentView.width - (kHPadding * 2 + kKeyWidth + kKeySpacing);
		CGFloat innerHeight = self.contentView.height - kVPadding * 2;
		self.detailTextLabel.frame = CGRectMake(kHPadding + kKeyWidth + kKeySpacing, kVPadding,
												valueWidth, innerHeight);
	}


	#pragma mark UXTableViewCell

	-(void) setObject:(id)object {
		if (_item != object) {
			[super setObject:object];
			
			UXTableCaptionItem *item = object;
			self.textLabel.text = item.caption;
			self.detailTextLabel.text = item.text;
		}
	}


	#pragma mark API

	-(UILabel *) captionLabel {
		return self.textLabel;
	}

@end

#pragma mark -

@implementation UXTableSubtextItemCell

	#pragma mark UXTableViewCell

	+(CGFloat) tableView:(UITableView *)tableView rowHeightForObject:(id)object {
		UXTableCaptionItem *item = object;
		CGFloat width = tableView.width - kHPadding * 2;

		// Take disclosure indicator width into account if URL is present
		if (item.URL) {
			width -= kDisclosureIndicatorWidth;
		}
		
		CGSize detailTextSize = [item.text sizeWithFont:UXSTYLEVAR(tableFont)
									  constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
										  lineBreakMode:UILineBreakModeTailTruncation];
		
		CGSize textSize = [item.caption sizeWithFont:UXSTYLEVAR(font)
								   constrainedToSize:CGSizeMake(width, CGFLOAT_MAX)
									   lineBreakMode:UILineBreakModeWordWrap];
		
		return kVPadding * 2 + detailTextSize.height + textSize.height;
	}


	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
			self.detailTextLabel.font = UXSTYLEVAR(tableFont);
			self.detailTextLabel.textColor = UXSTYLEVAR(textColor);
			self.detailTextLabel.highlightedTextColor = UXSTYLEVAR(highlightedTextColor);
			self.detailTextLabel.adjustsFontSizeToFitWidth = YES;
			
			self.textLabel.font = UXSTYLEVAR(font);
			self.textLabel.textColor = UXSTYLEVAR(tableSubTextColor);
			self.textLabel.highlightedTextColor = UXSTYLEVAR(highlightedTextColor);
			self.textLabel.textAlignment = UITextAlignmentLeft;
			self.textLabel.contentMode = UIViewContentModeTop;
			self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
			self.textLabel.numberOfLines = 0;
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		
		if (!self.textLabel.text.length) {
			CGFloat titleHeight			= self.textLabel.height + self.detailTextLabel.height;
			
			[self.detailTextLabel sizeToFit];
			self.detailTextLabel.top	= floor(self.contentView.height / 2 - titleHeight / 2);
			self.detailTextLabel.left	= self.detailTextLabel.top * 2;
		}
		else {
			[self.detailTextLabel sizeToFit];
			self.detailTextLabel.left	= kHPadding;
			self.detailTextLabel.top	= kVPadding;
			
			CGFloat maxWidth	= self.contentView.width - kHPadding * 2;
			CGSize captionSize	= [self.textLabel.text sizeWithFont:self.textLabel.font constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:self.textLabel.lineBreakMode];
			self.textLabel.frame = CGRectMake(kHPadding, self.detailTextLabel.bottom, captionSize.width, captionSize.height);
		}
	}


	#pragma mark UXTableViewCell

	-(void) setObject:(id)object {
		if (_item != object) {
			[super setObject:object];
			
			UXTableCaptionItem *item = object;
			self.textLabel.text = item.caption;
			self.detailTextLabel.text = item.text;
		}
	}


	#pragma mark API

	-(UILabel *) captionLabel {
		return self.textLabel;
	}

@end

#pragma mark -

@implementation UXTableRightCaptionItemCell

	#pragma mark UXTableViewCell

	// TODO
	+(CGFloat) tableView:(UITableView *)tableView rowHeightForObject:(id)object {
		return UX_ROW_HEIGHT;
	}

	
	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
			self.textLabel.highlightedTextColor = UXSTYLEVAR(highlightedTextColor);
			self.textLabel.lineBreakMode = UILineBreakModeWordWrap;
			self.textLabel.numberOfLines = 0;
			
			self.detailTextLabel.highlightedTextColor = UXSTYLEVAR(highlightedTextColor);
			
			// TODO
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		
		// TODO
	}


	#pragma mark UXTableViewCell

	-(void) setObject:(id)object {
		if (_item != object) {
			[super setObject:object];
			
			UXTableCaptionItem *item = object;
			self.textLabel.text = item.caption;
			self.detailTextLabel.text = item.text;
			// TODO
		}
	}


	#pragma mark API

	-(UILabel *) captionLabel {
		return self.textLabel;
	}

@end

#pragma mark -

@implementation UXTableSubtitleItemCell

	#pragma mark UXTableViewCell

	+(CGFloat) tableView:(UITableView *)tableView rowHeightForObject:(id)object {
		UXTableSubtitleItem *item = object;
		CGFloat height = UXSTYLEVAR(tableFont).lineHeight + kVPadding * 2;
		if (item.subtitle) {
			height += UXSTYLEVAR(font).lineHeight;
		}
		
		return height;
	}


	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
			_imageView2 = nil;
			
			self.textLabel.font = UXSTYLEVAR(tableFont);
			self.textLabel.textColor = UXSTYLEVAR(textColor);
			self.textLabel.highlightedTextColor = UXSTYLEVAR(highlightedTextColor);
			self.textLabel.textAlignment = UITextAlignmentLeft;
			self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
			self.textLabel.adjustsFontSizeToFitWidth = YES;
			
			self.detailTextLabel.font = UXSTYLEVAR(font);
			self.detailTextLabel.textColor = UXSTYLEVAR(tableSubTextColor);
			self.detailTextLabel.highlightedTextColor = UXSTYLEVAR(highlightedTextColor);
			self.detailTextLabel.textAlignment = UITextAlignmentLeft;
			self.detailTextLabel.contentMode = UIViewContentModeTop;
			self.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
			self.detailTextLabel.numberOfLines = kMessageTextLineCount;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_imageView2);
		[super dealloc];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		
		CGFloat height = self.contentView.height;
		CGFloat width = self.contentView.width - (height + kSmallMargin);
		CGFloat left = 0;
		
		if (_imageView2) {
			_imageView2.frame = CGRectMake(0, 0, height, height);
			left = _imageView2.right + kSmallMargin;
		}
		else {
			left = kHPadding;
		}
		
		if (self.detailTextLabel.text.length) {
			CGFloat textHeight = self.textLabel.font.lineHeight;
			CGFloat subtitleHeight = self.detailTextLabel.font.lineHeight;
			CGFloat paddingY = floor((height - (textHeight + subtitleHeight)) / 2);
			
			self.textLabel.frame = CGRectMake(left, paddingY, width, textHeight);
			self.detailTextLabel.frame = CGRectMake(left, self.textLabel.bottom, width, subtitleHeight);
		}
		else {
			self.textLabel.frame = CGRectMake(_imageView2.right + kSmallMargin, 0, width, height);
			self.detailTextLabel.frame = CGRectZero;
		}
	}


	#pragma mark UXTableViewCell

	-(void) setObject:(id)object {
		if (_item != object) {
			[super setObject:object];
			
			UXTableSubtitleItem *item = object;
			if (item.text.length) {
				self.textLabel.text = item.text;
			}
			if (item.subtitle.length) {
				self.detailTextLabel.text = item.subtitle;
			}
			if (item.defaultImage) {
				self.imageView2.defaultImage = item.defaultImage;
			}
			if (item.imageURL) {
				self.imageView2.URL = item.imageURL;
			}
		}
	}

	
	#pragma mark API

	-(UILabel *) subtitleLabel {
		return self.detailTextLabel;
	}

	-(UXImageView *) imageView2 {
		if (!_imageView2) {
			_imageView2 = [[UXImageView alloc] init];
			//_imageView2.defaultImage = UXSTYLEVAR(personImageSmall);
			//imageView2.style = UXSTYLE(threadActorIcon);
			[self.contentView addSubview:_imageView2];
		}
		return _imageView2;
	}

@end

#pragma mark -

@implementation UXTableMessageItemCell

	#pragma mark UXTableViewCell

	/*!
	Compute height based on font sizes
	*/
	+(CGFloat) tableView:(UITableView *)tableView rowHeightForObject:(id)object {
		return 90;
	}

	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
			_titleLabel		= nil;
			_timestampLabel = nil;
			_imageView2		= nil;
			
			self.textLabel.font							= UXSTYLEVAR(font);
			self.textLabel.textColor					= UXSTYLEVAR(textColor);
			self.textLabel.highlightedTextColor			= UXSTYLEVAR(highlightedTextColor);
			self.textLabel.textAlignment				= UITextAlignmentLeft;
			self.textLabel.lineBreakMode				= UILineBreakModeTailTruncation;
			self.textLabel.adjustsFontSizeToFitWidth	= YES;
			self.textLabel.contentMode					= UIViewContentModeLeft;
			
			self.detailTextLabel.font					= UXSTYLEVAR(font);
			self.detailTextLabel.textColor				= UXSTYLEVAR(tableSubTextColor);
			self.detailTextLabel.highlightedTextColor	= UXSTYLEVAR(highlightedTextColor);
			self.detailTextLabel.textAlignment			= UITextAlignmentLeft;
			self.detailTextLabel.contentMode			= UIViewContentModeTop;
			self.detailTextLabel.lineBreakMode			= UILineBreakModeTailTruncation;
			self.detailTextLabel.numberOfLines			= kMessageTextLineCount;
			self.detailTextLabel.contentMode			= UIViewContentModeLeft;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_titleLabel);
		UX_SAFE_RELEASE(_timestampLabel);
		UX_SAFE_RELEASE(_imageView2);
		[super dealloc];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		
		CGFloat left = 0;
		if (_imageView2) {
			_imageView2.frame = CGRectMake(kSmallMargin, 
										   kSmallMargin, 
										   kDefaultMessageImageWidth, 
										   kDefaultMessageImageHeight);
			left += kSmallMargin + kDefaultMessageImageHeight + kSmallMargin;
		}
		else {
			left = kMargin;
		}
		
		CGFloat width					= self.contentView.width - left;
		CGFloat top						= kSmallMargin;
		
		if (_titleLabel.text.length) {
			_titleLabel.frame			= CGRectMake(left, top, width, _titleLabel.font.lineHeight);
			top							+= _titleLabel.height;
		}
		else {
			_titleLabel.frame			= CGRectZero;
		}
		
		if (self.captionLabel.text.length) {
			self.captionLabel.frame		= CGRectMake(left, top, width, self.captionLabel.font.lineHeight);
			top							+= self.captionLabel.height;
		}
		else {
			self.captionLabel.frame		= CGRectZero;
		}
		
		if (self.detailTextLabel.text.length) {
			CGFloat textHeight			= self.detailTextLabel.font.lineHeight * kMessageTextLineCount;
			self.detailTextLabel.frame	= CGRectMake(left, top, width, textHeight);
		}
		else {
			self.detailTextLabel.frame	= CGRectZero;
		}
		
		if (_timestampLabel.text.length) {
			_timestampLabel.alpha	= !self.showingDeleteConfirmation;
			[_timestampLabel sizeToFit];
			_timestampLabel.left	= self.contentView.width - (_timestampLabel.width + kSmallMargin);
			_timestampLabel.top		= _titleLabel.top;
			_titleLabel.width		-= _timestampLabel.width + kSmallMargin * 2;
		}
		else {
			//!!!:was _titleLabel
			_timestampLabel.frame = CGRectZero;
		}
	}

	-(void) didMoveToSuperview {
		[super didMoveToSuperview];
		if (self.superview) {
			_imageView2.backgroundColor = self.backgroundColor;
			_titleLabel.backgroundColor = self.backgroundColor;
			_timestampLabel.backgroundColor = self.backgroundColor;
		}
	}


	#pragma mark UXTableViewCell

	-(void) setObject:(id)object {
		if (_item != object) {
			[super setObject:object];
			
			UXTableMessageItem *item = object;
			if (item.title.length) {
				self.titleLabel.text = item.title;
			}
			if (item.caption.length) {
				self.captionLabel.text = item.caption;
			}
			if (item.text.length) {
				self.detailTextLabel.text = item.text;
			}
			if (item.timestamp) {
				self.timestampLabel.text = [item.timestamp formatShortTime];
			}
			if (item.imageURL) {
				self.imageView2.URL = item.imageURL;
			}
		}
	}


	#pragma mark API

	-(UILabel *) titleLabel {
		if (!_titleLabel) {
			_titleLabel							= [[UILabel alloc] init];
			_titleLabel.textColor				= [UIColor blackColor];
			_titleLabel.highlightedTextColor	= [UIColor whiteColor];
			_titleLabel.font					= UXSTYLEVAR(tableFont);
			_titleLabel.contentMode				= UIViewContentModeLeft;
			[self.contentView addSubview:_titleLabel];
		}
		return _titleLabel;
	}

	-(UILabel *) captionLabel {
		return self.textLabel;
	}

	-(UILabel *) timestampLabel {
		if (!_timestampLabel) {
			_timestampLabel							= [[UILabel alloc] init];
			_timestampLabel.font					= UXSTYLEVAR(tableTimestampFont);
			_timestampLabel.textColor				= UXSTYLEVAR(timestampTextColor);
			_timestampLabel.highlightedTextColor	= [UIColor whiteColor];
			_timestampLabel.contentMode				= UIViewContentModeLeft;
			[self.contentView addSubview:_timestampLabel];
		}
		return _timestampLabel;
	}

	-(UXImageView *) imageView2 {
		if (!_imageView2) {
			_imageView2 = [[UXImageView alloc] init];
			//    _imageView2.defaultImage = UXSTYLEVAR(personImageSmall);
			//    _imageView2.style = UXSTYLE(threadActorIcon);
			[self.contentView addSubview:_imageView2];
		}
		return _imageView2;
	}

@end

#pragma mark -

@implementation UXTableMoreButtonCell

	@synthesize animating = _animating;


	#pragma mark Constructor

	+(CGFloat) tableView:(UITableView *)tableView rowHeightForObject:(id)object {
		CGFloat height		= [super tableView:tableView rowHeightForObject:object];
		CGFloat minHeight	= UX_ROW_HEIGHT * 1.5;
		if (height < minHeight) {
			return minHeight;
		}
		else {
			return height;
		}
	}


	#pragma mark @UITableViewCell

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier]) {
			self.textLabel.font		= UXSTYLEVAR(tableSmallFont);
			_animating				= NO;
			_activityIndicatorView	= nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_activityIndicatorView);
		[super dealloc];
	}


	#pragma mark @UIView


	-(void) layoutSubviews {
		[super layoutSubviews];
		_activityIndicatorView.left = kMoreButtonMargin - (_activityIndicatorView.width + kSmallMargin);
		_activityIndicatorView.top	= floor(self.contentView.height / 2 - _activityIndicatorView.height / 2);
		self.textLabel.frame		= CGRectMake(kMoreButtonMargin, 
												 self.textLabel.top,
												 self.contentView.width - (kMoreButtonMargin + kSmallMargin),
												 self.textLabel.height);
		self.detailTextLabel.frame	= CGRectMake(kMoreButtonMargin, 
												 self.detailTextLabel.top,
												 self.contentView.width - (kMoreButtonMargin + kSmallMargin),
												 self.detailTextLabel.height);
	}


	#pragma mark UXTableViewCell

	-(void) setObject:(id)object {
		if (_item != object) {
			[super setObject:object];
			UXTableMoreButton *item	= object;
			self.animating				= item.isLoading;
			self.textLabel.textColor	= UXSTYLEVAR(moreLinkTextColor);
			self.selectionStyle			= UXSTYLEVAR(tableSelectionStyle);
		}
	}


	#pragma mark API

	-(UIActivityIndicatorView *) activityIndicatorView {
		if (!_activityIndicatorView) {
			_activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
			[self.contentView addSubview:_activityIndicatorView];
		}
		return _activityIndicatorView;
	}

	-(void) setAnimating:(BOOL)animating {
		if (_animating != animating) {
			_animating = animating;
			
			if (_animating) {
				[self.activityIndicatorView startAnimating];
			}
			else {
				[_activityIndicatorView stopAnimating];
			}
			[self setNeedsLayout];
		}
	}

@end

#pragma mark -

@implementation UXTableImageItemCell

	@synthesize imageView2 = _imageView2;

	#pragma mark UXTableViewCell

	+(CGFloat) tableView:(UITableView *)tableView rowHeightForObject:(id)object {
		UXTableImageItem *imageItem	= object;
		UIImage *image					= imageItem.imageURL ? [[UXURLCache sharedCache] imageForURL:imageItem.imageURL] : nil;
		if (!image) {
			image = imageItem.defaultImage;
		}
		
		CGFloat imageHeight;
		CGFloat imageWidth;
		UXImageStyle *style	= [imageItem.imageStyle firstStyleOfClass:[UXImageStyle class]];
		  if (style && !CGSizeEqualToSize(style.size, CGSizeZero)) {
			imageWidth			= style.size.width + kKeySpacing;
			imageHeight			= style.size.height;
		}
		else {
			imageWidth			= image ? image.size.width + kKeySpacing : (imageItem.imageURL ? kDefaultImageSize + kKeySpacing : 0);
			imageHeight			= image ? image.size.height : (imageItem.imageURL ? kDefaultImageSize : 0);
		}
		
		CGFloat maxWidth		= tableView.width - (imageWidth + kHPadding * 2 + kMargin * 2);
		CGSize textSize			= [imageItem.text sizeWithFont:UXSTYLEVAR(tableSmallFont) constrainedToSize:CGSizeMake(maxWidth, CGFLOAT_MAX) lineBreakMode:UILineBreakModeTailTruncation];
		CGFloat contentHeight	= textSize.height > imageHeight ? textSize.height : imageHeight;
		return contentHeight + kVPadding * 2;
	}


	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
			_imageView2 = [[UXImageView alloc] init];
			[self.contentView addSubview:_imageView2];
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_imageView2);
		[super dealloc];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		
		UXTableImageItem *item = self.object;
		UIImage *image = item.imageURL ? [[UXURLCache sharedCache] imageForURL:item.imageURL] : nil;
		if (!image) {
			image = item.defaultImage;
		}
		
		if ([_item isKindOfClass:[UXTableRightImageItem class]]) {
			CGFloat imageWidth	= image ? image.size.width  : (item.imageURL ? kDefaultImageSize : 0);
			CGFloat imageHeight = image ? image.size.height : (item.imageURL ? kDefaultImageSize : 0);
			
			if (_imageView2.URL) {
				CGFloat innerWidth		= self.contentView.width - (kHPadding * 2 + imageWidth + kKeySpacing);
				CGFloat innerHeight		= self.contentView.height - kVPadding * 2;
				self.textLabel.frame	= CGRectMake(kHPadding, kVPadding, innerWidth, innerHeight);
				_imageView2.frame		= CGRectMake(self.textLabel.right + kKeySpacing, floor(self.height / 2 - imageHeight / 2), imageWidth, imageHeight);
			}
			else {
				self.textLabel.frame	= CGRectInset(self.contentView.bounds, kHPadding, kVPadding);
				_imageView2.frame		= CGRectZero;
			}
		}
		else {
			if (_imageView2.URL) {
				CGFloat iconWidth		= image ? image.size.width  : (item.imageURL ? kDefaultImageSize : 0);
				CGFloat iconHeight		= image ? image.size.height : (item.imageURL ? kDefaultImageSize : 0);
				
				UXImageStyle *style = [item.imageStyle firstStyleOfClass:[UXImageStyle class]];
				if (style) {
					_imageView2.contentMode		= style.contentMode;
					_imageView2.clipsToBounds	= YES;
					_imageView2.backgroundColor = [UIColor clearColor];
					if (style.size.width) {
						iconWidth	= style.size.width;
					}
					if (style.size.height) {
						iconHeight	= style.size.height;
					}
				}
				
				_imageView2.frame		= CGRectMake(kHPadding, floor(self.height / 2 - iconHeight / 2), iconWidth, iconHeight);
				CGFloat innerWidth		= self.contentView.width  - (kHPadding * 2 + iconWidth + kKeySpacing);
				CGFloat innerHeight		= self.contentView.height - kVPadding * 2;
				self.textLabel.frame	= CGRectMake(kHPadding + iconWidth + kKeySpacing, kVPadding, innerWidth, innerHeight);
			}
			else {
				self.textLabel.frame	= CGRectInset(self.contentView.bounds, kHPadding, kVPadding);
				_imageView2.frame		= CGRectZero;
			}
		}
	}

	-(void) didMoveToSuperview {
		[super didMoveToSuperview];
		if (self.superview) {
			_imageView2.backgroundColor = self.backgroundColor;
		}
	}


	#pragma mark UXTableViewCell

	-(void) setObject:(id)object {
		if (_item != object) {
			[super setObject:object];
			
			UXTableImageItem *item	= object;
			_imageView2.style			= item.imageStyle;
			_imageView2.defaultImage	= item.defaultImage;
			_imageView2.URL				= item.imageURL;
			
			if ([_item isKindOfClass:[UXTableRightImageItem class]]) {
				self.textLabel.font				= UXSTYLEVAR(tableSmallFont);
				self.textLabel.textAlignment	= UITextAlignmentCenter;
				self.accessoryType				= UITableViewCellAccessoryNone;
			}
			else {
				self.textLabel.font				= UXSTYLEVAR(tableFont);
				self.textLabel.textAlignment	= UITextAlignmentLeft;
			}
		}
	}

@end

#pragma mark -

@implementation UXTableActivityItemCell

	@synthesize activityLabel = _activityLabel;

	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
			_activityLabel		= [[UXActivityLabel alloc] initWithStyle:UXActivityLabelStyleGray];
			[self.contentView addSubview:_activityLabel];
			self.accessoryType	= UITableViewCellAccessoryNone;
			self.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_activityLabel);
		[super dealloc];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		
		UITableView *tableView = (UITableView *)self.superview;
		if (tableView.style == UITableViewStylePlain) {
			_activityLabel.frame = self.contentView.bounds;
		}
		else {
			_activityLabel.frame = CGRectInset(self.contentView.bounds, -1, -1);
		}
	}


	#pragma mark UXTableViewCell

	-(void) setObject:(id)object {
		if (_item != object) {
			[_item release];
			_item						= [object retain];
			UXTableActivityItem *item = object;
			_activityLabel.text			= item.text;
		}
	}

@end

#pragma mark -

@implementation UXStyledTextTableItemCell

	@synthesize label = _label;

	#pragma mark UXTableViewCell

	+(CGFloat) tableView:(UITableView *)tableView rowHeightForObject:(id)object {
		UXTableStyledTextItem *item = object;
		if (!item.text.font) {
			item.text.font = UXSTYLEVAR(font);
		}
		CGFloat padding = [tableView tableCellMargin] * 2 + item.padding.left + item.padding.right;
		if (item.URL) {
			padding += kDisclosureIndicatorWidth;
		}
		item.text.width = tableView.width - padding;
		return item.text.height + item.padding.top + item.padding.bottom;
	}


	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
			_label				= [[UXStyledTextLabel alloc] init];
			_label.contentMode	= UIViewContentModeLeft;
			[self.contentView addSubview:_label];
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_label);
		[super dealloc];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		
		UXTableStyledTextItem *item = self.object;
		_label.frame = CGRectOffset(self.contentView.bounds, item.margin.left, item.margin.top);
	}

	-(void) didMoveToSuperview {
		[super didMoveToSuperview];
		if (self.superview) {
			_label.backgroundColor = self.backgroundColor;
		}
	}


	#pragma mark UXTableViewCell

	-(void) setObject:(id)object {
		if (_item != object) {
			[super setObject:object];
			UXTableStyledTextItem *item	= object;
			_label.text						= item.text;
			_label.contentInset				= item.padding;
			[self setNeedsLayout];
		}
	}

@end

#pragma mark -

@implementation UXStyledTextTableCell

	@synthesize label = _label;

	#pragma mark UXTableViewCell

	+(CGFloat)tableView:(UITableView *)tableView rowHeightForObject:(id)object {
		UXStyledText *text = object;
		if (!text.font) {
			text.font = UXSTYLEVAR(font);
		}
		text.width = tableView.width - [tableView tableCellMargin] * 2;
		return text.height;
	}


	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
			_label				= [[UXStyledTextLabel alloc] init];
			_label.contentMode	= UIViewContentModeLeft;
			[self.contentView addSubview:_label];
			self.selectionStyle	= UITableViewCellSelectionStyleNone;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_label);
		[super dealloc];
	}

	
	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		_label.frame = self.contentView.bounds;
	}

	-(void) didMoveToSuperview {
		[super didMoveToSuperview];
		if (self.superview) {
			_label.backgroundColor = self.backgroundColor;
		}
	}


	#pragma mark UXTableViewCell

	-(id) object {
		return _label.text;
	}

	-(void) setObject:(id)anObject {
		if (self.object != anObject) {
			_label.text = anObject;
		}
	}

@end

#pragma mark -

@implementation UXTableControlCell

	@synthesize item	= _item;
	@synthesize control = _control;

	#pragma mark SPI

	+(BOOL) shouldConsiderControlIntrinsicSize:(UIView *)view {
		return [view isKindOfClass:[UISwitch class]];
	}

	+(BOOL) shouldSizeControlToFit:(UIView *)view {
		return [view isKindOfClass:[UITextView class]] || [view isKindOfClass:[UXTextEditor class]];
	}

	+(BOOL) shouldRespectControlPadding:(UIView *)view {
		return [view isKindOfClass:[UITextField class]];
	}


	#pragma mark UXTableViewCell

	+(CGFloat) tableView:(UITableView *)tableView rowHeightForObject:(id)object {
		UIView *view = nil;
		
		if ([object isKindOfClass:[UIView class]]) {
			view = object;
		}
		else {
			UXTableControlItem *controlItem = object;
			view = controlItem.control;
		}
		
		CGFloat height = view.height;
		if (!height) {
			if ([view isKindOfClass:[UITextView class]]) {
				UITextView *textView		= (UITextView *)view;
				CGFloat lineHeight			= textView.font.lineHeight;
				height						= lineHeight * kDefaultTextViewLines;
			}
			else if ([view isKindOfClass:[UXTextEditor class]]) {
				UXTextEditor* textEditor	= (UXTextEditor*)view;
				CGFloat lineHeight			= textEditor.font.lineHeight;
				height						= lineHeight * kDefaultTextViewLines;
			}
			else if ([view isKindOfClass:[UITextField class]]) {
				UITextField *textField		= (UITextField *)view;
				CGFloat lineHeight			= textField.font.lineHeight;
				height						= lineHeight + kSmallMargin * 2;
			}
			else {
				[view sizeToFit];
				height						= view.height;
			}
		}
		
		if (height < UX_ROW_HEIGHT) {
			return UX_ROW_HEIGHT;
		}
		else {
			return height;
		}
	}


	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
			_item				= nil;
			_control			= nil;
			self.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_item);
		UX_SAFE_RELEASE(_control);
		[super dealloc];
	}

	-(void) layoutSubviews {
		[super layoutSubviews];
		
		if ([UXTableControlCell shouldSizeControlToFit:_control]) {
			_control.frame = CGRectInset(self.contentView.bounds, 2, kSpacing / 2);
		}
		else {
			CGFloat minX			= kControlPadding;
			CGFloat contentWidth	= self.contentView.width - kControlPadding;
			if (![UXTableControlCell shouldRespectControlPadding:_control]) {
				contentWidth -= kControlPadding;
			}
			if (self.textLabel.text.length) {
				CGSize textSize		= [self.textLabel sizeThatFits:self.contentView.bounds.size];
				contentWidth		-= textSize.width + kSpacing;
				minX				+= textSize.width + kSpacing;
			}
			
			if (!_control.height) {
				[_control sizeToFit];
			}
			
			if ([UXTableControlCell shouldConsiderControlIntrinsicSize:_control]) {
				minX += contentWidth - _control.width;
			}
			
			// For some reason I need to re-add the control as a subview or else
			// the re-use of the cell will cause the control to fail to paint itself on occasion
			[self.contentView addSubview:_control];
			_control.frame = CGRectMake(minX, floor(self.contentView.height / 2 - _control.height / 2), contentWidth, _control.height);
		}
	}


	#pragma mark UXTableViewCell

	-(id) object {
		return _item ? _item : (id)_control;
	}

	-(void) setObject:(id)object {
		if (object != _control && object != _item) {
			[_control removeFromSuperview];
			UX_SAFE_RELEASE(_control);
			UX_SAFE_RELEASE(_item);
			
			if ([object isKindOfClass:[UIView class]]) {
				_control = [object retain];
			}
			else if ([object isKindOfClass:[UXTableControlItem class]]) {
				_item		= [object retain];
				_control	= [_item.control retain];
			}
			
			_control.backgroundColor	= [UIColor clearColor];
			self.textLabel.text			= _item.caption;
			
			if (_control) {
				[self.contentView addSubview:_control];
			}
		}
	}

@end

#pragma mark -

@implementation UXTableFlushViewCell

	@synthesize item = _item;
	@synthesize view = _view;


	#pragma mark UXTableViewCell

	+(CGFloat) tableView:(UITableView *)tableView rowHeightForObject:(id)object {
		return UX_ROW_HEIGHT;
	}


	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
			_item				= nil;
			_view				= nil;
			self.selectionStyle = UITableViewCellSelectionStyleNone;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_item);
		UX_SAFE_RELEASE(_view);
		[super dealloc];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		_view.frame = self.contentView.bounds;
	}


	#pragma mark UXTableViewCell

	-(id) object {
		return _item ? _item : (id)_view;
	}

	-(void) setObject:(id)object {
		if (object != _view && object != _item) {
			[_view removeFromSuperview];
			UX_SAFE_RELEASE(_view);
			UX_SAFE_RELEASE(_item);
			
			if ([object isKindOfClass:[UIView class]]) {
				_view = [object retain];
			}
			else if ([object isKindOfClass:[UXTableViewItem class]]) {
				_item = [object retain];
				_view = [_item.view retain];
			}
			
			[self.contentView addSubview:_view];
		}
	}

@end
