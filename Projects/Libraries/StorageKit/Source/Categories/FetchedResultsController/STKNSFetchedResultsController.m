
#import <StorageKit/STKNSFetchedResultsController.h>

@implementation NSFetchedResultsController (STKNSFetchedResultsController)

	-(id) arrangedObjects {
		NSArray *sortDescriptors = [self.fetchRequest sortDescriptors];
		if ([sortDescriptors count]) {
			return [self.fetchedObjects sortedArrayUsingDescriptors:sortDescriptors];
		}
		else {
			return self.fetchedObjects;
		}
	}

@end
