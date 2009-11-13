
#import "MessageTestController.h"
#import "SearchTestController.h"
#import "MockDataSource.h"

@implementation MessageTestController

	#pragma mark Internal

	-(UIViewController *) composeTo:(NSString *)recipient {
		UXTableTextItem *item				= [UXTableTextItem itemWithText:recipient URL:nil];
		UXMessageController *controller		= [[[UXMessageController alloc] initWithRecipients:[NSArray arrayWithObject:item]] autorelease];
		controller.dataSource				= [[[MockSearchDataSource alloc] init] autorelease];
		controller.delegate					= self;
		
		return controller;
	}

	-(UIViewController *) post:(NSDictionary *)query {
		UXPostController *controller	= [[[UXPostController alloc] init] autorelease];
		controller.originView			= [query objectForKey:@"__target__"];
		return controller;
	}

	-(UIViewController *) textBar:(NSDictionary *)query {
		UXTextBarController *controller	= [[[UXTextBarController alloc] init] autorelease];
		return controller;
	}

	-(void) cancelAddressBook {
		[[UXNavigator navigator].visibleViewController dismissModalViewControllerAnimated:YES];
	}

	-(void) sendDelayed:(NSTimer *)timer {
		_sendTimer			= nil;
		
		NSArray *fields		= timer.userInfo;
		UIView *lastView	= [self.view.subviews lastObject];
		CGFloat y			= lastView.bottom + 20;
		
		UXMessageRecipientField *toField = [fields objectAtIndex:0];
		
		for (id recipient in toField.recipients) {
			UILabel *label			= [[[UILabel alloc] init] autorelease];
			label.backgroundColor	= self.view.backgroundColor;
			label.text				= [NSString stringWithFormat:@"Sent to: %@", recipient];
			[label sizeToFit];
			label.frame				= CGRectMake(30, y, label.width, label.height);
			y += label.height;
			[self.view addSubview:label];
		}
		[self.modalViewController dismissModalViewControllerAnimated:YES];
	}


	#pragma mark <NSObject>

	-(id) init {
		if (self = [super init]) {
			_sendTimer = nil;	
			[[UXNavigator navigator].URLMap from:@"uxcatalog://compose?to=(composeTo:)"
						   toModalViewController:self 
										selector:@selector(composeTo:)];
			[[UXNavigator navigator].URLMap from:@"uxcatalog://post"
								toViewController:self 
										selector:@selector(post:)];
			[[UXNavigator navigator].URLMap from:@"uxcatalog://textBar"
								toViewController:self 
										selector:@selector(textBar:)];
		}
		return self;
	}

	-(void) dealloc {
		[[UXNavigator navigator].URLMap removeURL:@"uxcatalog://compose?to=(composeTo:)"];
		[[UXNavigator navigator].URLMap removeURL:@"uxcatalog://post"];
		[[UXNavigator navigator].URLMap removeURL:@"uxcatalog://textBar"];
		[_sendTimer invalidate];
		[super dealloc];
	}


	#pragma mark @UIViewController

	-(void) loadView {
		CGRect appFrame				= [UIScreen mainScreen].applicationFrame;
		self.view					= [[[UIView alloc] initWithFrame:appFrame] autorelease];;
		self.view.backgroundColor	= [UIColor colorWithWhite:0.9 alpha:1];
		
		UIButton *button			= [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button setTitle:@"Show UXMessageController" forState:UIControlStateNormal];
		[button addTarget:@"uxcatalog://compose?to=Alan%20Jones" action:@selector(openURL) forControlEvents:UIControlEventTouchUpInside];
		button.frame				= CGRectMake(20, 20, 280, 50);
		
		[self.view addSubview:button];
		
		UIButton *button2	= [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button2 setTitle:@"Show UXPostController"	forState:UIControlStateNormal];
		[button2 addTarget:@"uxcatalog://post"		action:@selector(openURLFromButton:) forControlEvents:UIControlEventTouchUpInside];
		button2.frame		= CGRectMake(20, button.bottom + 20, 280, 50);
		[self.view addSubview:button2];

		UIButton *button3	= [UIButton buttonWithType:UIButtonTypeRoundedRect];
		[button3 setTitle:@"Show UXTextBarController"	forState:UIControlStateNormal];
		[button3 addTarget:@"uxcatalog://textBar"		action:@selector(openURLFromButton:) forControlEvents:UIControlEventTouchUpInside];
		button3.frame		= CGRectMake(20, button2.bottom + 20, 280, 50);
		[self.view addSubview:button3];
	}

	-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
		return UXIsSupportedOrientation(interfaceOrientation);
	}


	#pragma mark <UXMessageControllerDelegate>

	-(void) composeController:(UXMessageController *)controller didSendFields:(NSArray *)fields {
		_sendTimer = [NSTimer scheduledTimerWithTimeInterval:2
													  target:self
													selector:@selector(sendDelayed:)
													userInfo:fields
													 repeats:NO];
	}


	-(void) composeControllerDidCancel:(UXMessageController *)controller {
		[_sendTimer invalidate];
		_sendTimer = nil;
		[controller dismissModalViewControllerAnimated:YES];
	}

	-(void) composeControllerShowRecipientPicker:(UXMessageController *)controller {
		SearchTestController *searchController	= [[[SearchTestController alloc] init] autorelease];
		searchController.delegate				= self;
		searchController.title					= @"Address Book";
		searchController.navigationItem.prompt	= @"Select a recipient";
		searchController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																											target:self 
																											action:@selector(cancelAddressBook)] autorelease];
		
		UINavigationController *navController				= [[[UINavigationController alloc] init] autorelease];
		[navController pushViewController:searchController animated:NO];
		[controller presentModalViewController:navController animated:YES];
	}


	#pragma mark <SearchTestControllerDelegate>

	-(void) searchTestController:(SearchTestController *)controller didSelectObject:(id)object {
		UXMessageController *composeController = (UXMessageController *)self.modalViewController;
		[composeController addRecipient:object forFieldAtIndex:0];
		[controller dismissModalViewControllerAnimated:YES];
	}

@end
