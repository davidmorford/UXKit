
/*!
@project    
@header     FlickrXMLResponse.h
@copyright  (c) 2009 Keith Lazuka
@changes	(c) 2009 Semantap
*/

#import <XMLKit/XMLKit.h>
#import <UXKit/UXKit.h>
#import "URLModelResponse.h"

/*!
Parses the HTTP response from a Flickr image search query into a list of SearchResult objects.
SemantapXML to construct a tree from the XML and to perform XPath queries in order to store 
the parts in which we're interested to our domain object, SearchResult.
*/
@interface FlickrXMLResponse : URLModelResponse {
}

@end
