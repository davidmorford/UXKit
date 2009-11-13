
#import <UXKit/UXTableViewCell.h>

@implementation UXTableViewCell

	+(CGFloat) tableView:(UITableView *)aTableView rowHeightForObject:(id)anObject {
		return UX_ROW_HEIGHT;
	}

	
	#pragma mark UITableViewCell

	-(void) prepareForReuse {
		self.object = nil;
		[super prepareForReuse];
	}

	
	#pragma mark API

	-(id) object {
		return nil;
	}

	-(void) setObject:(id)object {
	
	}

@end
