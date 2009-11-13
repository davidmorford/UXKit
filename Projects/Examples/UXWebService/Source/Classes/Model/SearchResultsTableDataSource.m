
#import "SearchResultsTableDataSource.h"
#import "SearchResult.h"
#import "SearchResultsModel.h"

@implementation SearchResultsTableDataSource

	-(void) tableViewDidLoadModel:(UITableView *)tableView {
		[super tableViewDidLoadModel:tableView];
		
		UXLOG(@"Removing all objects in the table view.");
		[self.items removeAllObjects];
		
		// Construct an object that is suitable for the table view system
		// from each SearchResult domain object that we retrieve from the UXModel.
		for (SearchResult *result in [(id <SearchResultsModel>)self.model results]) {
			
			[self.items addObject:[UXTableImageItem itemWithText:result.title
														imageURL:result.thumbnailURL
													defaultImage:nil
															 URL:nil]];
		}
		UXLOG(@"Added %lu search result objects", (unsigned long)[self.items count]);
	}

@end
