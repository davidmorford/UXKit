
/*!
@project	UXWebService
@header     SearchResultsModel.h
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <UXKit/UXKit.h>

/*!
This is where you can switch the web service between Flickr and Yahoo 
and between using the JSON and XML response processors. All you need 
to do is set SearchServiceDefault and  SearchResponseFormatDefault 
to the appropriate value.
*/
typedef enum {
	SearchServiceYahoo,
	SearchServiceFlickr,
	SearchServiceDefault = SearchServiceYahoo
} SearchService;

extern SearchService CurrentSearchService;

typedef enum {
	SearchResponseFormatJSON,
	SearchResponseFormatXML,
	SearchResponseFormatDefault = SearchResponseFormatXML
} SearchResponseFormat;

extern SearchResponseFormat CurrentSearchResponseFormat;

#pragma mark -

/*!
@protocol SearchResultsModel <UXModel>
@abstract This protocol is intended for UXModels that represent a remote search service.
@discussion
*/
@protocol SearchResultsModel <UXModel>

	// A list of domain objects constructed by the model after parsing the web service's HTTP response. In this case, it is a list of SearchResult objects.
	@property (nonatomic, readonly) NSArray *results;

	// The total number of results available on the server (but not necessarily downloaded) for the current model configuration's search query.
	@property (nonatomic, readonly) NSUInteger totalResultsAvailableOnServer;

	// The keywords that will be submitted to the web service in order to do the actual image search (e.g. "green apple")
	@property (nonatomic, retain) NSString *searchTerms;

	-(id)initWithResponseFormat:(SearchResponseFormat)responseFormat;

@end

#pragma mark -

/*!
Factory methods for instantiating a functioning SearchResultsModel.
*/
id <SearchResultsModel>
CreateSearchModelWithCurrentSettings(void);

id <SearchResultsModel>
CreateSearchModel(SearchService service, SearchResponseFormat responseFormat);
