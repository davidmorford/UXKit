
#import <UXKit/UXListDataSource.h>
#import <UXKit/UXTableItem.h>

@implementation UXListDataSource

	@synthesize items = _items;


	#pragma mark API

	+(UXListDataSource *) dataSourceWithObjects:(id)object, ... {
		NSMutableArray *items = [NSMutableArray array];
		va_list ap;
		va_start(ap, object);
		while (object) {
			[items addObject:object];
			object = va_arg(ap, id);
		}
		va_end(ap);
		return [[[self alloc] initWithItems:items] autorelease];
	}

	+(UXListDataSource *) dataSourceWithItems:(NSMutableArray *)anItemList {
		return [[[self alloc] initWithItems:anItemList] autorelease];
	}


	#pragma mark Initializer

	-(id) initWithItems:(NSArray *)anItemList {
		if (self = [self init]) {
			_items = [anItemList mutableCopy];
		}
		return self;
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_items = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_items);
		[super dealloc];
	}


	#pragma mark UITableViewDataSource

	-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		return _items.count;
	}


	#pragma mark UXTableViewDataSource

	-(id) tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath {
		if (indexPath.row < _items.count) {
			return [_items objectAtIndex:indexPath.row];
		}
		else {
			return nil;
		}
	}

	-(NSIndexPath *) tableView:(UITableView *)tableView indexPathForObject:(id)object {
		NSUInteger index = [_items indexOfObject:object];
		if (index != NSNotFound) {
			return [NSIndexPath indexPathForRow:index inSection:0];
		}
		return nil;
	}


	#pragma mark API

	-(NSMutableArray *) items {
		if (!_items) {
			_items = [[NSMutableArray alloc] init];
		}
		return _items;
	}
	
	-(NSIndexPath *) indexPathOfItemWithUserInfo:(id)userInfo {
		for (NSInteger currentIndex = 0; currentIndex < _items.count; ++currentIndex) {
			UXTableItem *item = [_items objectAtIndex:currentIndex];
			if (item.userInfo == userInfo) {
				return [NSIndexPath indexPathForRow:currentIndex inSection:0];
			}
		}
		return nil;
	}

@end

#pragma mark -

@implementation UXSectionedDataSource

	@synthesize items		= _items;
	@synthesize sections	= _sections;

	#pragma mark API

	+(UXSectionedDataSource *) dataSourceWithObjects:(id)object, ...{
		NSMutableArray *items		= [NSMutableArray array];
		NSMutableArray *sections	= [NSMutableArray array];
		NSMutableArray *section		= nil;
		va_list ap;
		va_start(ap, object);
		while (object) {
			if ([object isKindOfClass:[NSString class]]) {
				[sections addObject:object];
				section = [NSMutableArray array];
				[items addObject:section];
			}
			else {
				[section addObject:object];
			}
			object = va_arg(ap, id);
		}
		va_end(ap);
		
		return [[[self alloc] initWithItems:items sections:sections] autorelease];
	}

	+(UXSectionedDataSource *) dataSourceWithArrays:(id)object, ...{
		NSMutableArray *items		= [NSMutableArray array];
		NSMutableArray *sections	= [NSMutableArray array];
		va_list ap;
		va_start(ap, object);
		while (object) {
			if ([object isKindOfClass:[NSString class]]) {
				[sections addObject:object];
			}
			else {
				[items addObject:object];
			}
			object = va_arg(ap, id);
		}
		va_end(ap);
		return [[[self alloc] initWithItems:items sections:sections] autorelease];
	}

	+(UXSectionedDataSource *) dataSourceWithItems:(NSArray *)items sections:(NSArray *)sections {
		return [[[self alloc] initWithItems:items sections:sections] autorelease];
	}


	#pragma mark Initializer

	-(id)  initWithItems:(NSArray *)items sections:(NSArray *)sections {
		if (self = [self init]) {
			_items		= [items mutableCopy];
			_sections	= [sections mutableCopy];
		}
		return self;
	}


	#pragma mark NSObject

	-(id) init {
		if (self = [super init]) {
			_items		= nil;
			_sections	= nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_items);
		UX_SAFE_RELEASE(_sections);
		[super dealloc];
	}


	#pragma mark UITableViewDataSource

	-(NSInteger) numberOfSectionsInTableView:(UITableView *)aTableView {
		return _sections ? _sections.count : 1;
	}

	-(NSInteger) tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection {
		if (_sections) {
			NSArray *items = [_items objectAtIndex:aSection];
			return items.count;
		}
		else {
			return _items.count;
		}
	}

	-(NSString *) tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)aSection {
		if (_sections.count) {
			return [_sections objectAtIndex:aSection];
		}
		else {
			return nil;
		}
	}


	#pragma mark UXTableViewDataSource

	-(id) tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath {
		if (_sections) {
			NSArray *section = [_items objectAtIndex:indexPath.section];
			return [section objectAtIndex:indexPath.row];
		}
		else {
			return [_items objectAtIndex:indexPath.row];
		}
	}

	-(NSIndexPath *) tableView:(UITableView *)tableView indexPathForObject:(id)object {
		if (_sections) {
			for (int i = 0; i < _items.count; ++i) {
				NSMutableArray *section = [_items objectAtIndex:i];
				NSUInteger index = [section indexOfObject:object];
				if (index != NSNotFound) {
					return [NSIndexPath indexPathForRow:index inSection:i];
				}
			}
		}
		else {
			NSUInteger index = [_items indexOfObject:object];
			if (index != NSNotFound) {
				return [NSIndexPath indexPathForRow:index inSection:0];
			}
		}
		
		return nil;
	}


	#pragma mark API

	-(NSIndexPath *) indexPathOfItemWithUserInfo:(id)userInfo {
		if (_sections.count) {
			for (NSInteger i = 0; i < _items.count; ++i) {
				NSArray *items = [_items objectAtIndex:i];
				for (NSInteger j = 0; j < items.count; ++j) {
					UXTableItem *item = [items objectAtIndex:j];
					if (item.userInfo == userInfo) {
						return [NSIndexPath indexPathForRow:j inSection:i];
					}
				}
			}
		}
		else {
			for (NSInteger i = 0; i < _items.count; ++i) {
				UXTableItem *item = [_items objectAtIndex:i];
				if (item.userInfo == userInfo) {
					return [NSIndexPath indexPathForRow:i inSection:0];
				}
			}
		}
		return nil;
	}

	-(void) removeItemAtIndexPath:(NSIndexPath *)anIndexPath {
		[self removeItemAtIndexPath:anIndexPath andSectionIfEmpty:NO];
	}

	-(BOOL) removeItemAtIndexPath:(NSIndexPath *)anIndexPath andSectionIfEmpty:(BOOL)andSection {
		if (_sections.count) {
			NSMutableArray *items = [_items objectAtIndex:anIndexPath.section];
			[items removeObjectAtIndex:anIndexPath.row];
			if (!items.count) {
				[_sections removeObjectAtIndex:anIndexPath.section];
				[_items removeObjectAtIndex:anIndexPath.section];
				return YES;
			}
		}
		else if (!anIndexPath.section) {
			[_items removeObjectAtIndex:anIndexPath.row];
		}
		return NO;
	}

@end
