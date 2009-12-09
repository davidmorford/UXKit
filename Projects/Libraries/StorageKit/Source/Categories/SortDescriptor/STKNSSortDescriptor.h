
/*!
@project	StorageKit
@header     STKNSSortDescriptor.h
*/

#import <Foundation/Foundation.h>

/*!
@category NSSortDescriptor (STKNSSortDescriptor)
@abstract￼
@discussion
*/
@interface NSSortDescriptor (STKNSSortDescriptor)

	/*!
	@discussion [NSSortDescriptor sortDescriptorsWithString:@"name asc, createdDate desc"];
	@result sortDescriptors
	*/
	+(NSArray *) sortDescriptorsWithString:(NSString *)string;

@end
