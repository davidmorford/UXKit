
#import <UXKit/UXSegmentedToolbar.h>
#import <UXKit/UXDefaultStyleSheet.h>

@implementation UXSegmentedToolbar
	
	@synthesize segmentedControl;

	#pragma mark UIView

	-(id) initWithFrame:(CGRect)frame {
		if (self = [super initWithFrame:frame]) {
			self.autoresizingMask	= UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
			self.tintColor			= UXSTYLEVAR(toolbarTintColor);
			margin = 8.0f;
		}
		return self;
	}

	// TODO: Do a better job here to manage and support changes inorientation, addition and removal of new items.
	-(void) setSegmentedItems:(NSArray *)itemNames {
		if (itemNames && ([itemNames count] > 0)) {
			if (segmentedControl) {
				UX_SAFE_RELEASE(segmentedControl);
			}
			segmentedControl						= [[UISegmentedControl alloc] initWithItems:itemNames];
			segmentedControl.segmentedControlStyle	= UISegmentedControlStyleBar;
			segmentedControl.tintColor				= UXSTYLEVAR(segmentedControlTintColor);
			segmentedControl.selectedSegmentIndex	= 0;
			
			CGFloat newWidthWithMargins = (self.bounds.size.width - 2 * margin);
			CGFloat segmentWidth		= (newWidthWithMargins / segmentedControl.numberOfSegments);
			for (NSUInteger seg = 0; seg < segmentedControl.numberOfSegments; seg++) {
				[segmentedControl setWidth:segmentWidth forSegmentAtIndex:seg];
			}
			
			UIBarButtonItem *spaceLeftItem			= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
			UIBarButtonItem *spaceRightItem			= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
			UIBarButtonItem *segmentedControlItem	= [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
			NSMutableArray *barButtons				= [[NSMutableArray alloc] initWithObjects:spaceLeftItem, segmentedControlItem, spaceRightItem, nil];
			self.items = barButtons;
			[spaceLeftItem release];
			[spaceRightItem release];
			[segmentedControlItem release];
			[barButtons release];
		}
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(segmentedControl);
		[super dealloc];
	}

@end
