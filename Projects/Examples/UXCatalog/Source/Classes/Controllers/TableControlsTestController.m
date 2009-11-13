
#import "TableControlsTestController.h"

@implementation TableControlsTestController

	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			self.tableViewStyle					= UITableViewStyleGrouped;
			self.autoresizesForKeyboard			= YES;
			self.variableHeightRows				= YES;
			
			UITextField *textField				= [[[UITextField alloc] init] autorelease];
			textField.placeholder				= @"UITextField";
			textField.font						= UXSTYLEVAR(font);
			
			UITextField *textField2				= [[[UITextField alloc] init] autorelease];
			textField2.font						= UXSTYLEVAR(font);
			textField2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			UXTableControlItem *textFieldItem	= [UXTableControlItem itemWithCaption:@"UXTableControlItem" control:textField2];
			
			UITextView *textView				= [[[UITextView alloc] init] autorelease];
			textView.text						= @"UITextView";
			textView.font						= UXSTYLEVAR(font);
			
			UXTextEditor *editor				= [[[UXTextEditor alloc] init] autorelease];
			editor.font							= UXSTYLEVAR(font);
			editor.backgroundColor				= UXSTYLEVAR(backgroundColor);
			editor.autoresizesToText			= NO;
			editor.minNumberOfLines				= 3;
			editor.placeholder					= @"UXTextEditor";
			
			UISwitch *switchy					= [[[UISwitch alloc] init] autorelease];
			UXTableControlItem *switchItem		= [UXTableControlItem itemWithCaption:@"UISwitch" control:switchy];
			
			UISlider *slider					= [[[UISlider alloc] init] autorelease];
			UXTableControlItem *sliderItem		= [UXTableControlItem itemWithCaption:@"UISlider" control:slider];
			
			self.dataSource = [UXListDataSource dataSourceWithObjects:
							   textField,
							   editor,
							   textView,
							   textFieldItem,
							   switchItem,
							   sliderItem,
							   nil];
		}
		return self;
	}

@end
