
/*!
@library JSONKit
@abstract A strict JSON parser and generator for Objective-C
@discussion JSON (JavaScript Object Notation) is a lightweight data-interchange
format. This framework provides two apis for parsing and generating JSON. One 
standard object-based and a higher level api consisting of categories added to 
existing Objective-C classes. This framework does its best to be as strict as 
possible, both in what it accepts and what it generates. For example, it does 
not support trailing commas in arrays or objects. Nor does it support embedded 
comments, or anything else not in the JSON specification. This is considered 
a feature.
@license    New BSD (See License.txt in project)
Copyright   (C) 2009 Stig Brautaset. All rights reserved.
@copyright  (c) 2009 Semantap
@version    2.2.2 (GitHub commit 2716506ab14077c27737152bc228deae58cbb9af)
*/

#import <JSONKit/JKJSON.h>
#import <JSONKit/JKNSObject+JSON.h>
#import <JSONKit/JKNSString+JSON.h>
