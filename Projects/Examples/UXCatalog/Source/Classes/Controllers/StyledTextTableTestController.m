
#import "StyledTextTableTestController.h"

@implementation StyledTextTableTestController

	-(id) init {
		if (self = [super init]) {
			self.autoresizesForKeyboard		= YES;
			self.variableHeightRows			= YES;
			
			// Uncomment this to see how the table cells look against a custom background color 
			//self.tableView.backgroundColor = [UIColor yellowColor];

			NSArray *strings = [NSArray arrayWithObjects:
								[UXStyledText textFromXHTML:@"This is a whole bunch of text made from characters and followed by this URL http://bit.ly/1234"                                                                                                      ],
								[UXStyledText textFromXHTML:@"Here we have a URL http://www.h0tlinkz.com followed by another http://www.internets.com"                                                                                                         ],
								[UXStyledText textFromXHTML:@"http://www.cnn.com is a URL and the words you are now reading are the text that follows"                                                                                                            ],
								[UXStyledText textFromXHTML:@"Here is text that has absolutely no styles. Move along now. Nothing to see here. Goodbye now."                                                                                                          ],
								//@"Let's test out some line breaks.\n\nOh yeah.",
								//@"This is a message with a long URL in it http://www.foo.com/abra/cadabra/abrabra/dabarababa",
								nil];
			
			UXListDataSource *dataSource = [[[UXListDataSource alloc] init] autorelease];
			for (int i = 0; i < 50; ++i) {
				UXStyledText *text = [strings objectAtIndex:i % strings.count];
				[dataSource.items addObject:[UXTableStyledTextItem itemWithText:text URL:nil]];
			}
			self.dataSource = dataSource;
		}
		return self;
	}

	-(void) dealloc {
		[super dealloc];
	}

	#pragma mark UXTableViewController

	-(void) loadView {
		[super loadView];
		self.tableView.allowsSelection = NO;
	}

@end
