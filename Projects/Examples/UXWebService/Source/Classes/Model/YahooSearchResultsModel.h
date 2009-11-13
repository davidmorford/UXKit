
/*!
@project    
@header     YahooSearchResultsModel.h
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>
#import "SearchResultsModel.h"

@class URLModelResponse;

/*!
Responsibilities: 
- To send an HTTP query to the Yahoo Image Search web service.
- To keep track of where it is in the recordset so that additional results for 
the same query can be retrieved.
- To parse the HTTP response by dispatching on the response format (XML or JSON) 
to the appropriate URLModelResponse object.
- To represent the results of the query in a manner that is not tied 
to how it will be displayed.
As Joe noted on the message board, the motivation behind the separation between 
the UXModel and UXTableViewDataSource is to allow complex apps to separate their 
data model from the way that the data will be displayed (e.g. in a UITableView).
This demo app demonstrates how a single data model can be used in both a table 
view and in Three20's thumbnail/photo browsing system.
I factored out the HTTP response processing  into separate classes (YahooJSONResponse 
and YahooXMLResponse) simply because I'm demonstrating how to handle both data formats
in a single demo app. In a real-world app, you would probably just use a single data 
format, in which case it would be simpler  to just fold that functionality (JSON 
processing, for example) directly into the YahooSearchResultsModel class.
*/
@interface YahooSearchResultsModel : UXURLRequestModel <SearchResultsModel> {
    URLModelResponse *responseProcessor;
    NSString *searchTerms;
    NSUInteger recordOffset;
}

@end
