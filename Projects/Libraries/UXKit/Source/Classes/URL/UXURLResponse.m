
#import <UXKit/UXURLResponse.h>
#import <UXKit/UXURLRequest.h>
#import <UXKit/UXURLCache.h>

@implementation UXURLDataResponse

	@synthesize data = _data;

	-(id) init {
		if (self = [super init]) {
			_data = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_data);
		[super dealloc];
	}

	#pragma mark UXURLResponse

	-(NSError *) request:(UXURLRequest *)aRequest processResponse:(NSURLResponse *)aResponse data:(id)bytes {
		if ([bytes isKindOfClass:[NSData class]]) {
			_data = [bytes retain];
		}
		return nil;
	}

@end

#pragma mark -

@implementation UXURLImageResponse

	@synthesize image = _image;

	-(id) init {
		if (self = [super init]) {
			_image = nil;
		}
		return self;
	}

	-(void) dealloc {
		UX_SAFE_RELEASE(_image);
		[super dealloc];
	}

	#pragma mark UXURLResponse

	-(NSError *) request:(UXURLRequest *)aRequest processResponse:(NSURLResponse *)aResponse data:(id)data {
		if ([data isKindOfClass:[UIImage class]]) {
			_image = [data retain];
		}
		else if ([data isKindOfClass:[NSData class]]) {
			UIImage *image = [[UXURLCache sharedCache] imageForURL:aRequest.URL fromDisk:NO];
			if (!image) {
				image = [UIImage imageWithData:data];
			}
			if (image) {
				if (!aRequest.respondedFromCache) {
					// Working on option to scale down really large images to a smaller size to save memory
					// if (image.size.width * image.size.height > (300*300)) {
					//    image = [image transformWidth:300 height:(image.size.height / image.size.width) * 300.0 rotate:NO];
					//    NSData* data = UIImagePNGRepresentation(image);
					//    [[UXURLCache sharedCache] storeData:data forURL:request.URL];
					//}
					[[UXURLCache sharedCache] storeImage:image forURL:aRequest.URL];
				}
				_image = [image retain];
			}
			else {
				return [NSError errorWithDomain:UXKitErrorDomain 
										   code:UXKitInvalidImageErrorCode
									   userInfo:nil];
			}
		}
		return nil;
	}

@end
