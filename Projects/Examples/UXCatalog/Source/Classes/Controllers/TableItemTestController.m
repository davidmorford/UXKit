
#import "TableItemTestController.h"

static NSString *kLoremIpsum = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do\
eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud\
exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
//Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla\
//  pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt\
//  mollit anim id est laborum.

@implementation TableItemTestController

	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			self.title				= @"Table Items";
			self.variableHeightRows = YES;
			
			// Uncomment this to see how the table looks with the grouped style
			self.tableViewStyle	= UITableViewStylePlain;
			
			// Uncomment this to see how the table cells look against a custom background color
			//self.tableView.backgroundColor = [UIColor lightGrayColor];
			
			NSString *localImage	= @"bundle://tableIcon.png";
			NSString *remoteImage	= @"http://profile.ak.fbcdn.net/v223/35/117/q223792_6978.jpg";
			UIImage *defaultPerson	= UXIMAGE(@"bundle://defaultPerson.png");
			
			// This demonstrates how to create a table with standard table "fields".  Many of these
			// fields with URLs that will be visited when the row is selected
			self.dataSource = [UXSectionedDataSource dataSourceWithObjects:
								@"Links and Buttons",
									[UXTableTextItem itemWithText:@"UXTableTextItem" URL:@"uxcatalog://tableItemTest" accessoryURL:@"http://www.google.com"],
									[UXTableLink itemWithText:@"UXTableLink" URL:@"uxcatalog://tableItemTest"],
									[UXTableButton itemWithText:@"UXTableButton"],
									[UXTableCaptionItem itemWithText:@"UXTableCaptionItem" caption:@"caption" URL:@"uxcatalog://tableItemTest"],
									[UXTableSubtitleItem itemWithText:@"UXTableSubtitleItem" subtitle:kLoremIpsum URL:@"uxcatalog://tableItemTest"],
									[UXTableMessageItem itemWithTitle:@"Bob Jones" caption:@"UXTableMessageItem" text:kLoremIpsum timestamp:[NSDate date] URL:@"uxcatalog://tableItemTest"],
									[UXTableMoreButton itemWithText:@"UXTableMoreButton"],
							   
								@"Images",
									[UXTableImageItem itemWithText:@"UXTableImageItem" imageURL:localImage URL:@"uxcatalog://tableItemTest"],
									[UXTableRightImageItem itemWithText:@"UXTableRightImageItem" imageURL:localImage defaultImage:nil imageStyle:UXSTYLE(rounded) URL:@"uxcatalog://tableItemTest"],
									[UXTableSubtitleItem itemWithText:@"UXTableSubtitleItem" subtitle:kLoremIpsum imageURL:remoteImage defaultImage:defaultPerson URL:@"uxcatalog://tableItemTest" accessoryURL:nil],
									[UXTableMessageItem itemWithTitle:@"Bob Jones" caption:@"UXTableMessageItem" text:kLoremIpsum timestamp:[NSDate date] imageURL:remoteImage URL:@"uxcatalog://tableItemTest"],
							   
								@"Static Text",
									[UXTableTextItem itemWithText:@"UXTableItem"],
									[UXTableCaptionItem itemWithText:@"UXTableCaptionItem which wraps to several lines" caption:@"Text"],
									[UXTableSubtextItem itemWithText:@"UXTableSubtextItem" caption:kLoremIpsum],
									[UXTableLongTextItem itemWithText:[@"UXTableLongTextItem " stringByAppendingString:kLoremIpsum]],
									[UXTableGrayTextItem itemWithText:[@"UXTableGrayTextItem " stringByAppendingString:kLoremIpsum]],
									[UXTableSummaryItem itemWithText:@"UXTableSummaryItem"],
								@"",
									[UXTableActivityItem itemWithText:@"UXTableActivityItem"],
								nil];
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}

@end
