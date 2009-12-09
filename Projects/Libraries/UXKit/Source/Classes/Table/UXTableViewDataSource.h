
/*!
@project	UXKit    
@header     UXTableViewDataSource.h
@copyright  (c) 2009 Joe Hewitt/Three20
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXModel.h>

/*!
@protocol UXTableViewDataSource <UITableViewDataSource>
@abstract
*/
@protocol UXTableViewDataSource <UITableViewDataSource, UXModel, UISearchDisplayDelegate>

	/*!
	@abstract Optional method to return a model object to delegate the UXModel protocol to.
	*/
	@property (nonatomic, retain) id <UXModel> model;

	+(NSArray *) lettersForSectionsWithSearch:(BOOL)search summary:(BOOL)summary;

	#pragma mark -

	-(id) tableView:(UITableView *)aTableView objectForRowAtIndexPath:(NSIndexPath *)anIndexPath;
	-(Class) tableView:(UITableView *)aTableView cellClassForObject:(id)object;
	-(NSString *) tableView:(UITableView *)aTableView labelForObject:(id)object;
	-(NSIndexPath *) tableView:(UITableView *)aTableView indexPathForObject:(id)object;
	-(void) tableView:(UITableView *)aTableView cell:(UITableViewCell *)cell willAppearAtIndexPath:(NSIndexPath *)anIndexPath;

	#pragma mark -

	/*!
	@abstract Informs the data source that its model loaded.
	@discussion Prepare newly loaded data for use in the table view.
	*/
	-(void) tableViewDidLoadModel:(UITableView *)aTableView;

	-(NSString *) titleForLoading:(BOOL)reloading;
	-(NSString *) titleForEmpty;
	-(NSString *) titleForError:(NSError *)error;

	-(NSString *) subtitleForEmpty;
	-(NSString *) subtitleForError:(NSError *)error;

	-(UIImage *) imageForEmpty;
	-(UIImage *) imageForError:(NSError *)error;

@optional
	-(NSIndexPath *) tableView:(UITableView *)aTableView willUpdateObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath;
	-(NSIndexPath *) tableView:(UITableView *)aTableView willInsertObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath;
	-(NSIndexPath *) tableView:(UITableView *)aTableView willRemoveObject:(id)anObject atIndexPath:(NSIndexPath *)anIndexPath;

	-(void) search:(NSString *)aTextString;

@end

#pragma mark -

/*!
@class UXTableViewDataSource
@superclass NSObject <UXTableViewDataSource>
@abstract
@discussion
*/
@interface UXTableViewDataSource : NSObject <UXTableViewDataSource> {
	id <UXModel> _model;
}

@end

#pragma mark -

/*!
@class UXTableViewInterstialDataSource
@superclass UXTableViewDataSource <UXModel>
@abstract A datasource that is eternally loading.
@discussion Useful when you are in between data sources and want to show 
the impression of loading until your actual data source is available.
*/
@interface UXTableViewInterstialDataSource : UXTableViewDataSource <UXModel> {

}

@end
