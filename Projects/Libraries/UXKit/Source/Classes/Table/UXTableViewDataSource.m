
#import <UXKit/UXTableViewDataSource.h>
#import <UXKit/UXTableItem.h>
#import <UXKit/UXTableItemCell.h>
#import <UXKit/UXURLCache.h>
#import <UXKit/UXTextEditor.h>
#import <UXKit/UXStyledText.h>
#import <objc/runtime.h>

@implementation UXTableViewDataSource

	@synthesize model = _model;

	+(NSArray *) lettersForSectionsWithSearch:(BOOL)search summary:(BOOL)summary {
		NSMutableArray *titles = [NSMutableArray array];
		if (search) {
			[titles addObject:UITableViewIndexSearch];
		}
		
		for (unichar c = 'A'; c <= 'Z'; ++c) {
			NSString *letter = [NSString stringWithFormat:@"%c", c];
			[titles addObject:letter];
		}
		
		if (summary) {
			[titles addObject:@"#"];
		}
		return titles;
	}


	#pragma mark Initializer

	-(id) init {
		if (self = [super init]) {
			_model = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_model);
		[super dealloc];
	}


	#pragma mark UITableViewDataSource

	-(NSInteger) tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)aSection {
		return 0;
	}

	-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		id object				= [self tableView:tableView objectForRowAtIndexPath:indexPath];
		Class cellClass			= [self tableView:tableView cellClassForObject:object];
		const char *className	= class_getName(cellClass);
		NSString *identifier = [[NSString alloc] initWithBytesNoCopy:(char *)className
															  length:strlen(className)
															encoding:NSASCIIStringEncoding freeWhenDone:NO];
		
		UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
		if (cell == nil) {
			cell = [[[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
		}
		[identifier release];
		
		if ([cell isKindOfClass:[UXTableViewCell class]]) {
			[(UXTableViewCell *) cell setObject:object];
		}
		
		[self tableView:tableView cell:cell willAppearAtIndexPath:indexPath];
		
		return cell;
	}

	-(NSArray *) sectionIndexTitlesForTableView:(UITableView *)aTableView {
		return nil;
	}

	-(NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
		if (tableView.tableHeaderView) {
			if (index == 0) {
				// This is a hack to get the table header to appear when the user touches the
				// first row in the section index.  By default, it shows the first row, which is
				// not usually what you want.
				[tableView scrollRectToVisible:tableView.tableHeaderView.bounds animated:NO];
				return -1;
			}
		}
		NSString *letter		= [title substringToIndex:1];
		NSInteger sectionCount	= [tableView numberOfSections];
		for (NSInteger i = 0; i < sectionCount; ++i) {
			NSString *section  = [tableView.dataSource tableView:tableView titleForHeaderInSection:i];
			if ([section hasPrefix:letter]) {
				return i;
			}
		}
		if (index >= sectionCount) {
			return sectionCount - 1;
		}
		else {
			return index;
		}
	}

	#pragma mark UXModel

	-(NSMutableArray *) delegates {
		return nil;
	}

	-(BOOL) isLoaded {
		return YES;
	}

	-(BOOL) isLoading {
		return NO;
	}

	-(BOOL) isLoadingMore {
		return NO;
	}

	-(BOOL) isOutdated {
		return NO;
	}

	-(void) load:(UXURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	}

	-(void) cancel {
	}

	-(void) invalidate:(BOOL)erase {
	}

	
	#pragma mark UXTableViewDataSource

	-(id <UXModel>) model {
		return _model ? _model : self;
	}

	-(id) tableView:(UITableView *)aTableView objectForRowAtIndexPath:(NSIndexPath *)anIndexPath {
		return nil;
	}

	-(Class) tableView:(UITableView *)tableView cellClassForObject:(id)object {
		if ([object isKindOfClass:[UXTableItem class]]) {
			if ([object isKindOfClass:[UXTableMoreButton class]]) {
				return [UXTableMoreButtonCell class];
			}
			else if ([object isKindOfClass:[UXTableSubtextItem class]]) {
				return [UXTableSubtextItemCell class];
			}
			else if ([object isKindOfClass:[UXTableRightCaptionItem class]]) {
				return [UXTableRightCaptionItemCell class];
			}
			else if ([object isKindOfClass:[UXTableCaptionItem class]]) {
				return [UXTableCaptionItemCell class];
			}
			else if ([object isKindOfClass:[UXTableSubtitleItem class]]) {
				return [UXTableSubtitleItemCell class];
			}
			else if ([object isKindOfClass:[UXTableMessageItem class]]) {
				return [UXTableMessageItemCell class];
			}
			else if ([object isKindOfClass:[UXTableImageItem class]]) {
				return [UXTableImageItemCell class];
			}
			else if ([object isKindOfClass:[UXTableStyledTextItem class]]) {
				return [UXStyledTextTableItemCell class];
			}
			else if ([object isKindOfClass:[UXTableActivityItem class]]) {
				return [UXTableActivityItemCell class];
			}
			else if ([object isKindOfClass:[UXTableControlItem class]]) {
				return [UXTableControlCell class];
			}
			else {
				return [UXTableTextItemCell class];
			}
		}
		else if ([object isKindOfClass:[UXStyledText class]]) {
			return [UXStyledTextTableCell class];
		}
		else if ([object isKindOfClass:[UIControl class]] || [object isKindOfClass:[UITextView class]] || [object isKindOfClass:[UXTextEditor class]]) {
			return [UXTableControlCell class];
		}
		else if ([object isKindOfClass:[UIView class]]) {
			return [UXTableFlushViewCell class];
		}
		
		/*
		This will display an empty white table cell - probably not what you want, but it
		is better than crashing, which is what happens if you return nil here
		*/
		return [UXTableViewCell class];
	}

	-(NSString *) tableView:(UITableView *)aTableView labelForObject:(id)anObject {
		if ([anObject isKindOfClass:[UXTableTextItem class]]) {
			UXTableTextItem *item = anObject;
			return item.text;
		}
		else {
			return [NSString stringWithFormat:@"%@", anObject];
		}
	}

	-(NSIndexPath *) tableView:(UITableView *)aTableView indexPathForObject:(id)anObject {
		return nil;
	}

	-(void) tableView:(UITableView *)aTableView cell:(UITableViewCell *)aCell willAppearAtIndexPath:(NSIndexPath *)anIndexPath {
	
	}

	-(void) tableViewDidLoadModel:(UITableView *)aTableView {
	
	}

	-(void) search:(NSString *)aTextString {
	
	}

	-(NSString *) titleForLoading:(BOOL)flag {
		if (flag) {
			return UXLocalizedString(@"Updating...", @"");
		}
		else {
			return UXLocalizedString(@"Loading...", @"");
		}
	}

	-(UIImage *) imageForEmpty {
		return [self imageForError:nil];
	}

	-(NSString *) titleForEmpty {
		return nil;
	}

	-(NSString *) subtitleForEmpty {
		return nil;
	}

	-(UIImage *) imageForError:(NSError *)anError {
		return nil;
	}

	-(NSString *) titleForError:(NSError *)anError {
		return UXDescriptionForError(anError);
	}

	-(NSString *) subtitleForError:(NSError *)anError {
		return UXLocalizedString(@"Sorry, there was an error.", @"");
	}

@end

#pragma mark -

@implementation UXTableViewInterstialDataSource

	#pragma mark UXTableViewDataSource

	-(id <UXModel>) model {
		return self;
	}


	#pragma mark UXModel

	-(NSMutableArray *) delegates {
		return nil;
	}

	-(BOOL) isLoaded {
		return NO;
	}

	-(BOOL) isLoading {
		return YES;
	}

	-(BOOL) isLoadingMore {
		return NO;
	}

	-(BOOL) isOutdated {
		return NO;
	}

	-(void) load:(UXURLRequestCachePolicy)cachePolicy more:(BOOL)more {
	}

	-(void) cancel {
	
	}

	-(void) invalidate:(BOOL)erase {
	
	}

@end
