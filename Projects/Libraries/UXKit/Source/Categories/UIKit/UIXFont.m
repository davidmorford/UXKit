
#import <UXKit/UXGlobal.h>

@implementation UIFont (UIXFont)

	-(CGFloat) lineHeight {
		return (self.ascender - self.descender) + 1;
	}

@end
