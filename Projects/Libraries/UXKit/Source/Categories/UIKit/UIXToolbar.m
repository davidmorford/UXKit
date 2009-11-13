
#import <UXKit/UIXToolbar.h>

@implementation UIToolbar (UIXToolbar)

	-(UIBarButtonItem *) itemWithTag:(NSInteger)aTag {
		for (UIBarButtonItem *button in self.items) {
			if (button.tag == aTag) {
				return button;
			}
		}
		return nil;
	}

	-(void) replaceItemWithTag:(NSInteger)aTag withItem:(UIBarButtonItem *)anItem {
		NSInteger index = 0;
		for (UIBarButtonItem *button in self.items) {
			if (button.tag == aTag) {
				NSMutableArray *newItems = [NSMutableArray arrayWithArray:self.items];
				[newItems replaceObjectAtIndex:index withObject:anItem];
				self.items = newItems;
				break;
			}
			++index;
		}	
	}

@end
