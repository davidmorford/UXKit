
#import "TestTableViewController.h"
#import "TestModel.h"

@implementation TestTableViewController

	-(id) init {
		if (self = [super init]) {
			self.title				= @"Detail";
			self.tableViewStyle		= UITableViewStyleGrouped;
			self.statusBarStyle		= UIStatusBarStyleBlackOpaque;
			self.navigationBarTintColor = nil;
			self.navigationBarStyle	= UIBarStyleBlack;
			self.view.backgroundColor = [UIColor colorWithHue:0.58 saturation:0.07 brightness:0.08 alpha:1.00];
			self.tableView.backgroundColor = [UIColor clearColor];
		}
		return self;
	}


	#pragma mark UIViewController

	-(void) loadView {
		[super loadView];
	}

	-(void) viewDidLoad {
		[super viewDidLoad];
	}

	-(void) viewWillAppear:(BOOL)animated {
		[super viewWillAppear:animated];
	}

	-(void) viewDidAppear:(BOOL)animated {
		[super viewDidAppear:animated];
	}

	-(void) viewWillDisappear:(BOOL)animated {
		[super viewWillDisappear:animated];
	}

	-(void) viewDidDisappear:(BOOL)animated {
		[super viewDidDisappear:animated];
	}

	-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		return (interfaceOrientation == UIInterfaceOrientationPortrait);
	}

	-(void) didReceiveMemoryWarning {
		//[super didReceiveMemoryWarning];
	}
	
	-(void) createModel {
		//UXButton *acceptButton	= [UXButton buttonWithStyle:@"greenActionButton:" title:@"Accept"];
		//acceptButton.frame		= CGRectMake(0, 0, 280, 44);
		
		self.dataSource = [TestTableDataSource dataSourceWithObjects:
						   @"",
						   [TestTableCaptionItem itemWithText:@"A title about my thing..." caption:@"Description" offset:FALSE],
						   [TestTableCaptionItem itemWithText:@"October 25, 2009" caption:@"Start Date" offset:TRUE],
						   [TestTableCaptionItem itemWithText:@"October 31, 2009" caption:@"End Date" offset:FALSE],
						   @"",
						   [TestTableCaptionItem itemWithText:@"1 Bid" caption:@"Bid Count" offset:FALSE],
						   [TestTableCaptionItem itemWithText:@"42" caption:@"Hit Count" offset:TRUE],
						   /*[TestTableViewContainerItem itemWithView:acceptButton],*/
						   nil];
	}

	#pragma mark -

	-(void) dismissDetail {
		[self dismissModalViewControllerAnimated:YES];
	}

	#pragma mark Destructor

	-(void) dealloc {
		[super dealloc];
	}

@end

#pragma mark -

@implementation TestTableDataSource
	
	-(id <UXModel>) model {
		UXLOGMETHOD;
		return [super model];
	}

	-(id) tableView:(UITableView *)aTableView objectForRowAtIndexPath:(NSIndexPath *)anIndexPath {
		UXLOGMETHOD;
		return [super tableView:aTableView objectForRowAtIndexPath:anIndexPath];
	}

	-(Class) tableView:(UITableView *)aTableView cellClassForObject:(id)object {
		UXLOGMETHOD;
		Class cellClass = [super tableView:aTableView cellClassForObject:object];
		if ([object isKindOfClass:[TestTableItem class]]) {
			if ([object isKindOfClass:[TestTableViewContainerItem class]]) {
				return [TestTableViewContainerCell class];
			}
			else if ([object isKindOfClass:[TestTableCaptionItem class]]) {
				return [TestTableCaptionItemCell class];
			}
		}
		return cellClass;
	}

	-(NSString *) tableView:(UITableView *)aTableView labelForObject:(id)object {
		UXLOGMETHOD;
		return [super tableView:aTableView labelForObject:object];
	}

	-(NSIndexPath *) tableView:(UITableView *)aTableView indexPathForObject:(id)object  {
		UXLOGMETHOD;
		return [super tableView:aTableView indexPathForObject:object];
	}

	-(void) tableView:(UITableView *)aTableView cell:(UITableViewCell *)cell willAppearAtIndexPath:(NSIndexPath *)anIndexPath  {
		UXLOGMETHOD;
		[super tableView:aTableView cell:cell willAppearAtIndexPath:anIndexPath];
	}
	
	#pragma mark -

	-(NSString *) titleForLoading:(BOOL)reloading  {
		return @"";
	}

	-(UIImage *) imageForEmpty  {
		return nil;
	}

	-(NSString *) titleForEmpty  {
		return @"";
	}

	-(NSString *) subtitleForEmpty  {
		return @"";
	}

	-(UIImage *) imageForError:(NSError *)error  {
		return nil;
	}
	
	-(NSString *) titleForError:(NSError *)error  {
		return @"";
	}
	
	-(NSString *) subtitleForError:(NSError *)error  {
		return @"";
	}

	#pragma mark -

	/*!
	@abstract Informs the data source that its model loaded.
	@discussion Prepare newly loaded data for use in the table view.
	*/
	-(void) tableViewDidLoadModel:(UITableView *)aTableView {
		UXLOGMETHOD;
		[super tableViewDidLoadModel:aTableView];
	}

	-(NSIndexPath *) tableView:(UITableView *)aTableView willUpdateObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath {
		UXLOGMETHOD;
		return [super tableView:aTableView willUpdateObject:anObject atIndexPath:anIndexPath];
	}

	-(NSIndexPath *) tableView:(UITableView *)aTableView willInsertObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath {
		UXLOGMETHOD;
		return [super tableView:aTableView willInsertObject:anObject atIndexPath:anIndexPath];
	}

	-(NSIndexPath *) tableView:(UITableView *)aTableView willRemoveObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath {
		UXLOGMETHOD;
		return [super tableView:aTableView willRemoveObject:anObject atIndexPath:anIndexPath];
	}

	-(void) search:(NSString *)aTextString {
		UXLOGMETHOD;
		[super search:aTextString];
	}

@end

#pragma mark -

@implementation TestTableItem

@end

#pragma mark -

@implementation TestTableCaptionItem

	@synthesize text;
	@synthesize caption;
	@synthesize offset;

	#pragma mark Constructor

	+(id) itemWithText:(NSString *)aTextString caption:(NSString *)caption {
		TestTableCaptionItem *item = [[[self alloc] init] autorelease];
		item.text		= aTextString;
		item.caption	= caption;
		return item;
	}
	
	+(id) itemWithText:(NSString *)aTextString caption:(NSString *)aCaption offset:(BOOL)flag {
		TestTableCaptionItem *item = [[[self alloc] init] autorelease];
		item.text		= aTextString;
		item.caption	= aCaption;
		item.offset		= flag;
		return item;	
	}

	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			text = nil;
			caption = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(text);
		UX_SAFE_RELEASE(caption);
		[super dealloc];
	}

	#pragma mark NSCoding

	-(id) initWithCoder:(NSCoder *)decoder {
		if (self = [super initWithCoder:decoder]) {
			self.text = [decoder decodeObjectForKey:@"text"];
			self.caption = [decoder decodeObjectForKey:@"caption"];
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		[super encodeWithCoder:encoder];
		if (self.caption) {
			[encoder encodeObject:self.text forKey:@"text"];
			[encoder encodeObject:self.caption forKey:@"caption"];
		}
	}


@end

#pragma mark -

@implementation TestTableCaptionItemCell

	#pragma mark UXTableViewCell

	+(CGFloat) tableView:(UITableView *)tableView rowHeightForObject:(id)object {
		UXTableCaptionItem *item = object;
		CGFloat margin			= [tableView tableCellMargin];
		CGFloat width			= tableView.width - (75 + 12 + 10 * 2 + margin * 2);
		CGSize detailTextSize	= [item.text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap];
		return detailTextSize.height + 10 * 2;
	}


	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier]) {
			self.selectionStyle = UITableViewCellSelectionStyleNone;

			//super.contentView.backgroundColor = [UIColor redColor];
			UIView *backingView = [[UIView alloc] init];
			backingView.backgroundColor = [UIColor clearColor];
			self.backgroundView = backingView;
			[backingView release];
			
			self.contentView.backgroundColor = [UIColor colorWithHue:0.50 saturation:0.02 brightness:0.13 alpha:1.00];

			self.textLabel.font				= [UIFont systemFontOfSize:14];
			self.textLabel.backgroundColor	= [UIColor clearColor];
			self.textLabel.textColor		= [UIColor colorWithHue:0.28 saturation:0.00 brightness:0.47 alpha:1.00];
			self.textLabel.textAlignment	= UITextAlignmentRight;
			self.textLabel.lineBreakMode	= UILineBreakModeTailTruncation;
			self.textLabel.numberOfLines	= 1;
			self.textLabel.adjustsFontSizeToFitWidth = NO;
			
			self.detailTextLabel.font					= [UIFont systemFontOfSize:14];
			self.detailTextLabel.backgroundColor		= [UIColor clearColor];
			self.detailTextLabel.textColor				= [UIColor whiteColor];
			self.detailTextLabel.adjustsFontSizeToFitWidth = NO;
			//self.detailTextLabel.minimumFontSize = 8;
			self.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
			self.detailTextLabel.numberOfLines = 0;
			
			// Table Background
			// [UIColor colorWithHue:0.58 saturation:0.05 brightness:0.12 alpha:1.00] // Starting Linear Gradient Color
			// [UIColor colorWithHue:0.50 saturation:0.07 brightness:0.04 alpha:1.00] // Ending Linear Gradient Color
			
			// Border
			//[UIColor colorWithHue:0.58 saturation:0.04 brightness:0.19 alpha:1.00]
			
			// Caption Text
			//[UIColor colorWithHue:0.28 saturation:0.00 brightness:0.47 alpha:1.00]
			
			// Green Text
			//[UIColor colorWithHue:0.31 saturation:0.69 brightness:0.57 alpha:1.00]
			
			// Gray Cell
			//[UIColor colorWithHue:0.50 saturation:0.02 brightness:0.13 alpha:1.00]
			
			// Black Cell
			//[UIColor colorWithHue:0.50 saturation:0.04 brightness:0.06 alpha:1.00]
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		self.textLabel.frame		= CGRectMake(10, 10, 75, self.textLabel.font.lineHeight);
		CGFloat valueWidth			= self.contentView.width - (10 * 2 + 75 + 12);
		CGFloat innerHeight			= self.contentView.height - 10 * 2;
		self.detailTextLabel.frame	= CGRectMake(10 + 75 + 12, 10, valueWidth, innerHeight);
	}


	#pragma mark UXTableViewCell

	-(void) setObject:(id)object {
		if (item != object) {
			[super setObject:object];
			TestTableCaptionItem *captionItem = object;
			self.textLabel.text = captionItem.caption;
			self.detailTextLabel.text = captionItem.text;
			if (captionItem.offset) {
				self.contentView.backgroundColor = [UIColor colorWithHue:0.50 saturation:0.04 brightness:0.06 alpha:1.00];
			}
		}
	}


	#pragma mark API

	-(UILabel *) captionLabel {
		return self.textLabel;
	}

@end

#pragma mark -

@implementation TestTableViewCell

@end

#pragma mark -

@implementation TestTableViewContainerItem

	@synthesize view;

	#pragma mark Constructor

	+(id) itemWithView:(UIView *)aView {
		UXTableViewItem *item = [[[self alloc] init] autorelease];
		item.view		= aView;
		return item;
	}

	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			view	= nil;
		}
		return self;
	}

	#pragma mark NSCoding

	-(id) initWithCoder:(NSCoder *)decoder {
		if (self = [super initWithCoder:decoder]) {
			self.view		= [decoder decodeObjectForKey:@"view"];
		}
		return self;
	}

	-(void) encodeWithCoder:(NSCoder *)encoder {
		[super encodeWithCoder:encoder];
		if (self.view) {
			[encoder encodeObject:self.view forKey:@"view"];
		}
	}

	#pragma mark -

	-(void) dealloc {
		UX_SAFE_RELEASE(view);
		[super dealloc];
	}

@end

#pragma mark -

@implementation TestTableViewContainerCell

	@synthesize item;
	@synthesize view;

	#pragma mark UXTableViewCell

	+(CGFloat) tableView:(UITableView *)tableView rowHeightForObject:(id)object {
		return UX_ROW_HEIGHT;
	}

	#pragma mark NSObject

	-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)identifier {
		if (self = [super initWithStyle:style reuseIdentifier:identifier]) {
			item				= nil;
			view				= nil;
			self.selectionStyle = UITableViewCellSelectionStyleNone;
			//super.contentView.backgroundColor = [UIColor redColor];
			UIView *backingView = [[UIView alloc] init];
			backingView.backgroundColor = [UIColor clearColor];
			super.backgroundView = backingView;
			[backingView release];
		}
		return self;
	}


	#pragma mark UIView

	-(void) layoutSubviews {
		[super layoutSubviews];
		view.frame = self.contentView.bounds;
	}


	#pragma mark UXTableViewCell

	-(id) object {
		return item ? item : (id)view;
	}

	-(void) setObject:(id)object {
		if (object != view && object != item) {
			[view removeFromSuperview];
			UX_SAFE_RELEASE(view);
			UX_SAFE_RELEASE(item);
			if ([object isKindOfClass:[UIView class]]) {
				view = [object retain];
			}
			else if ([object isKindOfClass:[TestTableViewContainerItem class]]) {
				item = [object retain];
				view = [item.view retain];
			}
			[self.contentView addSubview:view];
		}
	}

	#pragma mark Destructor

	-(void) dealloc {
		UX_SAFE_RELEASE(item);
		UX_SAFE_RELEASE(view);
		[super dealloc];
	}

@end
