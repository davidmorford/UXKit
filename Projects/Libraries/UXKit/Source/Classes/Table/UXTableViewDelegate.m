
#import <UXKit/UXTableViewDelegate.h>
#import <UXKit/UXTableViewDataSource.h>
#import <UXKit/UXTableViewController.h>
#import <UXKit/UXTableItem.h>
#import <UXKit/UXTableItemCell.h>
#import <UXKit/UXTableHeaderView.h>
#import <UXKit/UXTableView.h>
#import <UXKit/UXStyledTextLabel.h>
#import <UXKit/UXNavigator.h>
#import <UXKit/UXDefaultStyleSheet.h>
#import <UXKit/UXURLRequestQueue.h>

static const CGFloat kEmptyHeaderHeight		= 1;
static const CGFloat kSectionHeaderHeight	= 35;

@implementation UXTableViewDelegate

	@synthesize controller = _controller;

	#pragma mark Initializer

	-(id) initWithController:(UXTableViewController *)aController {
		if (self = [super init]) {
			_controller = aController;
			_headers	= nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_headers);
		[super dealloc];
	}


	#pragma mark UITableViewDelegate

	-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
		//if ((tableView.style == UITableViewStylePlain) && UXSTYLESHEETPROPERTY(tableHeaderTintColor)) {
		if (UXSTYLESHEETPROPERTY(tableHeaderTintColor)) {
			if ([tableView.dataSource respondsToSelector:@selector(tableView:titleForHeaderInSection:)]) {
				NSString *title = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
				if (title.length) {
					UXTableHeaderView *header = [_headers objectForKey:title];
					if (!header) {
						if (!_headers) {
							_headers = [[NSMutableDictionary alloc] init];
						}
						//header = [[[UXTableHeaderView alloc] initWithTitle:title] autorelease];
						if (tableView.style == UITableViewStylePlain) {
							header = [[[UXTableHeaderView alloc] initWithTitle:title] autorelease];
						}
						else {
							header = [[[UXTableGroupedHeaderView alloc] initWithTitle:title] autorelease];
						}
						[_headers setObject:header forKey:title];
					}
					return header;
				}
			}
		}
		return nil;
	}

	-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
		id <UXTableViewDataSource> dataSource	= (id <UXTableViewDataSource>)tableView.dataSource;
		id object								= [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
		if ([object isKindOfClass:[UXTableLinkedItem class]]) {
			UXTableLinkedItem *item = object;
			if (item.URL && [_controller shouldOpenURL:item.URL]) {
				//UXOpenURL(item.URL);
				[[UXNavigator navigator] openURL:item.URL query:item.query animated:TRUE];
			}
			
			if ([object isKindOfClass:[UXTableButton class]]) {
				[tableView deselectRowAtIndexPath:indexPath animated:YES];
			}
			else if ([object isKindOfClass:[UXTableMoreButton class]]) {
				UXTableMoreButton *moreLink		= (UXTableMoreButton *)object;
				moreLink.isLoading				= YES;
				UXTableMoreButtonCell *cell		= (UXTableMoreButtonCell *)[tableView cellForRowAtIndexPath:indexPath];
				cell.animating					= YES;
				[tableView deselectRowAtIndexPath:indexPath animated:YES];
				[_controller.model load:UXURLRequestCachePolicyDefault more:TRUE];
			}
		}
		[_controller didSelectObject:object atIndexPath:indexPath];
	}

	-(void) tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
		id <UXTableViewDataSource> dataSource	= (id <UXTableViewDataSource>)tableView.dataSource;
		id object								= [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
		if ([object isKindOfClass:[UXTableLinkedItem class]]) {
			UXTableLinkedItem *item = object;
			if (item.accessoryURL && [_controller shouldOpenURL:item.accessoryURL]) {
				UXOpenURL(item.accessoryURL);
			}
		}
	}


	#pragma mark UIScrollViewDelegate

	-(BOOL) scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
		[UXURLRequestQueue mainQueue].suspended = YES;
		return YES;
	}

	-(void) scrollViewDidScrollToTop:(UIScrollView *)scrollView {
		[UXURLRequestQueue mainQueue].suspended = NO;
	}

	-(void) scrollViewDidScroll:(UIScrollView *)scrollView {
		if (_controller.menuView) {
			[_controller hideMenu:YES];
		}
	}

	-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
		[UXURLRequestQueue mainQueue].suspended			= YES;
		[_controller didBeginDragging];
		if ([scrollView isKindOfClass:[UXTableView class]]) {
			UXTableView *tableView						= (UXTableView *)scrollView;
			tableView.highlightedLabel.highlightedNode	= nil;
			tableView.highlightedLabel					= nil;
		}
	}

	-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
		if (!decelerate) {
			[UXURLRequestQueue mainQueue].suspended = NO;
		}
		[_controller didEndDragging];
	}

	-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
		[UXURLRequestQueue mainQueue].suspended = NO;
	}


	#pragma mark UXTableViewDelegate

	-(void) tableView:(UITableView *)aTableView touchesBegan:(NSSet *)aTouchSet withEvent:(UIEvent *)anEvent {
		if (_controller.menuView) {
			[_controller hideMenu:YES];
		}
	}

@end

#pragma mark -

@implementation UXTableViewVarHeightDelegate

	#pragma mark UITableViewDelegate

	-(CGFloat) tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)anIndexPath {
		id <UXTableViewDataSource> dataSource = (id <UXTableViewDataSource>)aTableView.dataSource;
		id anObject = [dataSource tableView:aTableView objectForRowAtIndexPath:anIndexPath];
		Class cls	= [dataSource tableView:aTableView cellClassForObject:anObject];
		return [cls tableView:aTableView rowHeightForObject:anObject];
	}

@end

#pragma mark -

@implementation UXTableViewPlainDelegate

//	#pragma mark UITableViewDelegate
//
//	-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//		NSString *title = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
//		if (!title.length) {
//			return nil;
//		}
//		return [[[UXTableHeaderView alloc] initWithTitle:title] autorelease];
//	}

@end

#pragma mark -

@implementation UXTableViewPlainVarHeightDelegate

//	#pragma mark UITableViewDelegate
//
//	-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//		NSString *title = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
//		if (!title.length) {
//			return nil;
//		}
//		return [[[UXTableHeaderView alloc] initWithTitle:title] autorelease];
//	}

@end

#pragma mark -

@implementation UXTableViewGroupedVarHeightDelegate

	#pragma mark UITableViewDelegate

	-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
		NSString *title = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
		if (!title.length) {
			return kEmptyHeaderHeight;
		}
		else {
			return kSectionHeaderHeight;
		}
	}

@end
