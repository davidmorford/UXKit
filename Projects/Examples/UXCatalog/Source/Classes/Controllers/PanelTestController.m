
#import "PanelTestController.h"
#import <UXKit/UXInputPanel.h>
#import <UXKit/UXInputPanelController.h>

@implementation PanelTestController

	#pragma mark UIViewController

	-(id) init {
		if (self = [super init]) {
			self.title = @"Panel Test";
		}
		return self;
	}

	-(void) loadView {
		[super loadView];
		self.view.backgroundColor = [UIColor darkGrayColor];
		self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Panel" 
																				  style:UIBarButtonItemStyleBordered 
																				 target:self
																				 action:@selector(togglePanel)];
	}

	#pragma mark -
	
	-(void) togglePanel {
		if (controller) {
			[controller dismissPopupViewControllerAnimated:TRUE];
			[controller release]; controller = nil;
		}
		else {
			controller = (UXInputPanelController *)[[UXNavigator navigator] openURL:@"uxcatalog://panel" animated:TRUE];
		}
	}


	#pragma mark <UXInputPanelControllerDelegate>
	
	-(BOOL) panelController:(UXInputPanelController *)controller shouldCompleteWithResult:(id)result  {
		return TRUE;
	}

	-(void) panelController:(UXInputPanelController *)controller didCompleteWithResult:(id)result  {
	
	}

	-(void) panelControllerDidCancel:(UXInputPanelController *)controller {
	
	}
	

	#pragma mark Destructor

	-(void) dealloc {
		[controller release]; controller = nil;
		[super dealloc];
	}

@end
