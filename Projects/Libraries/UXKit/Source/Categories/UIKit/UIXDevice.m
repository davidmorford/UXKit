
#import <UXKit/UIXDevice.h>
#import <UXKit/UIXApplication.h>
#import <sys/sysctl.h>  
#import <sys/types.h>
#import <mach/mach.h>

@implementation UIDevice (UIXDevice)

	-(double) availableMemory {
		vm_statistics_data_t vmStats;
		mach_msg_type_number_t infoCount	= HOST_VM_INFO_COUNT;
		kern_return_t kernReturn			= host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
		if (kernReturn != KERN_SUCCESS) {
			return NSNotFound;
		}
		return ((vm_page_size * vmStats.free_count) / 1024.0) / 1024.0;
	}

	-(NSString *) modelVersion {
		size_t keySize;
		sysctlbyname("hw.machine", NULL, &keySize, NULL, 0);
		char *key = malloc(keySize);
		sysctlbyname("hw.machine", key, &keySize, NULL, 0);
		NSString *model = [NSString stringWithCString:key encoding:NSUTF8StringEncoding];
		free(key);
		return model;
	}

@end
