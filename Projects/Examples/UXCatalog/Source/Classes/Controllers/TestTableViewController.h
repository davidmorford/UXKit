
/*!
@project    UXCatalog
@header     TestTableViewController.h
@copyright  (c) 2009 - Semantap
@created    10/23/09
*/

#import <UXKit/UXKit.h>

/*!
@class TestTableViewController
@superclass UIViewController
@abstract
@discussion
*/
@interface TestTableViewController : UXTableViewController {

}

@end

#pragma mark -

/*!
Responsibilities:
- Vend data objects that can be used by UXTableViewController.
The UXTableViewDataSource protocol specifies a few additional responsibilities, 
but since I'm subclassing UXListDataSource, there is no need to discuss them here. 
If you're interested please look at the UXTableViewDataSource protocol definition.
In simple cases, or during early prototyping, you would just vend UXTableItems, but 
as your app becomes more sophisticated you may want to vend your own objects. If you 
do choose to vend your own objects, then you need to implement tableView:cellClassForObject:
to provide your UITableViewCell subclass that knows how to render your data object 
and you need to implement tableView:cell:willAppearAtIndexPath: to configure your 
custom cell to match the state of your data object.
*/
@interface TestTableDataSource : UXSectionedDataSource {

}

@end

#pragma mark -

@interface TestTableItem : UXTableItem {

}

@end

#pragma mark -

@interface TestTableCaptionItem : TestTableItem {
	NSString *text;
	NSString *caption;
	BOOL offset;
}

	@property (nonatomic, copy) NSString *text;
	@property (nonatomic, copy) NSString *caption;
	@property (nonatomic, assign) BOOL offset;

	+(id) itemWithText:(NSString *)aTextString caption:(NSString *)aCaption;
	+(id) itemWithText:(NSString *)aTextString caption:(NSString *)aCaption offset:(BOOL)flag;

@end

#pragma mark -

@interface TestTableViewContainerItem : TestTableItem {
	UIView *view;
}

	@property (nonatomic, retain) UIView *view;

	+(id) itemWithView:(UIView *)aView;

@end

#pragma mark -

@interface TestTableViewCell : UXTableViewCell {

}

@end

#pragma mark -

@interface TestTableCaptionItemCell : TestTableViewCell {
	TestTableItem *item;
}

@end

#pragma mark -

@interface TestTableViewContainerCell : TestTableViewCell {
	TestTableViewContainerItem *item;
	UIView *view;
}

	@property (nonatomic, readonly, retain) TestTableViewContainerItem *item;
	@property (nonatomic, readonly, retain) UIView *view;

@end
