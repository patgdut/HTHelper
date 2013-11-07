//
//  UIDevice+HT.m
//
//
//  Created by 任健生 on 13-3-2.
//
//

#import "UIDevice+HT.h"
#include <mach/mach.h>
#include <arpa/inet.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <sys/types.h>
#include <ifaddrs.h>
#include <mach/mach_host.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <netdb.h>
#include <netinet/in.h>

@implementation UIDevice (HT)

- (NSString *)platform {
    
    static NSString *platform;
    if (!platform) {
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        platform = [NSString stringWithUTF8String:machine];
        free(machine);
    }
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (GSM+CDMA)";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}

- (BOOL)isPhone {
    return [[self platform] hasPrefix:@"iPhone"];
}

- (BOOL)isPad {
    return [[self platform] hasPrefix:@"iPad"];
}

- (NSInteger)majorVersion {
    static NSInteger result = -1;
    if (result == -1) {
        NSNumber *majorVersion = [[self.systemVersion componentsSeparatedByString:@"."] objectAtIndex:0];
        result = majorVersion.integerValue;
    }
    return result;
}



- (BOOL)isIOS7 {
    
    static int initIsIOS7 = -1;
    static BOOL isIOS7;
    
    if (initIsIOS7 == -1) {
        isIOS7 = ([self majorVersion] >= 7);
        initIsIOS7 = 1;
    }
    
    return isIOS7;
}

- (void)fixOrientationIfNeed {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (!UIInterfaceOrientationIsPortrait(orientation) && [self isPad]) {
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    }
}

- (BOOL)isDebugMode {
	int                 junk;
	int                 mib[4];
	struct kinfo_proc   info;
	size_t              size;
    
	// Initialize the flags so that, if sysctl fails for some bizarre
	// reason, we get a predictable result.
    
	info.kp_proc.p_flag = 0;
    
	// Initialize mib, which tells sysctl the info we want, in this case
	// we're looking for information about a specific process ID.
    
	mib[0] = CTL_KERN;
	mib[1] = KERN_PROC;
	mib[2] = KERN_PROC_PID;
	mib[3] = getpid();
    
	// Call sysctl.
    
	size = sizeof(info);
	junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
	assert(junk == 0);
    
	// We're being debugged if the P_TRACED flag is set.
    
	return ( (info.kp_proc.p_flag & P_TRACED) != 0 );
}

// 内存占用
- (NSString *)memoryUsage {
    
    mach_msg_type_number_t infoCount = TASK_BASIC_INFO_COUNT;
    task_basic_info_data_t taskInfo;
    task_info(mach_task_self(),TASK_BASIC_INFO, (task_info_t)&taskInfo, &infoCount);
    
    double usage = taskInfo.resident_size / 1024.0 / 1024.0;
    
    return [NSString stringWithFormat:@"%0.2f MB",usage];
    
}


// 检测是否被破解
- (BOOL)isCracked {
#if TARGET_IPHONE_SIMULATOR
    return NO;
#endif
	//Check process ID (shouldn't be root)
	int root = getgid();
	if (root <= 10) {
		return YES;
	}
    
	//Check SignerIdentity
	char symCipher[] = { '(', 'H', 'Z', '[', '9', '{', '+', 'k', ',', 'o', 'g', 'U', ':', 'D', 'L', '#', 'S', ')', '!', 'F', '^', 'T', 'u', 'd', 'a', '-', 'A', 'f', 'z', ';', 'b', '\'', 'v', 'm', 'B', '0', 'J', 'c', 'W', 't', '*', '|', 'O', '\\', '7', 'E', '@', 'x', '"', 'X', 'V', 'r', 'n', 'Q', 'y', '>', ']', '$', '%', '_', '/', 'P', 'R', 'K', '}', '?', 'I', '8', 'Y', '=', 'N', '3', '.', 's', '<', 'l', '4', 'w', 'j', 'G', '`', '2', 'i', 'C', '6', 'q', 'M', 'p', '1', '5', '&', 'e', 'h' };
	char csignid[] = "V.NwY2*8YwC.C1";
	for(int i=0;i<strlen(csignid);i++)
	{
		for(int j=0;j<sizeof(symCipher);j++)
		{
			if(csignid[i] == symCipher[j])
			{
				csignid[i] = j+0x21;
				break;
			}
		}
	}
	NSString* signIdentity = [[NSString alloc] initWithCString:csignid encoding:NSUTF8StringEncoding];
	NSBundle *bundle = [NSBundle mainBundle];
	NSDictionary *info = [bundle infoDictionary];
	if ([info objectForKey:signIdentity] != nil)
	{
		return YES;
	}
    
	//Check files
	NSString* bundlePath = [[NSBundle mainBundle] bundlePath];
	NSFileManager *manager = [NSFileManager defaultManager];
	static NSString *str = @"_CodeSignature";
	BOOL fileExists = [manager fileExistsAtPath:([NSString stringWithFormat:@"%@/%@", bundlePath, str])];
	if (!fileExists) {
		return YES;
	}
    
	static NSString *str2 = @"ResourceRules.plist";
	BOOL fileExists3 = [manager fileExistsAtPath:([NSString stringWithFormat:@"%@/%@", bundlePath, str2])];
	if (!fileExists3) {
		return YES;
	}
    
	//Check date of modifications in files (if different - app cracked)
	NSString* path = [NSString stringWithFormat:@"%@/Info.plist", bundlePath];
	NSString* path2 = [NSString stringWithFormat:@"%@/AppName", bundlePath];
	NSDate* infoModifiedDate = [[manager attributesOfFileSystemForPath:path error:nil] fileModificationDate];
	NSDate* infoModifiedDate2 = [[manager attributesOfFileSystemForPath:path2 error:nil]  fileModificationDate];
	NSDate* pkgInfoModifiedDate = [[manager attributesOfFileSystemForPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"PkgInfo"] error:nil] fileModificationDate];
	if([infoModifiedDate timeIntervalSinceReferenceDate] > [pkgInfoModifiedDate timeIntervalSinceReferenceDate]) {
		return YES;
	}
	if([infoModifiedDate2 timeIntervalSinceReferenceDate] > [pkgInfoModifiedDate timeIntervalSinceReferenceDate]) {
		return YES;
	}

	return NO;
}

// 检测设备是否越狱
- (BOOL)isJailBroken {
#if TARGET_IPHONE_SIMULATOR
    return NO;
#endif
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *cydiaPath2 = @"/usr/libexec/cydia";
    NSString *aptPath = @"/private/var/lib/apt/";
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        return YES;
    }
    
    BOOL isDirectory = YES;
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath2 isDirectory:&isDirectory]) {
        return YES;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath isDirectory:&isDirectory]) {
        return YES;
    }
    
    NSError *error;
    
	static NSString *str = @"Jailbreak test string";
    
	[str writeToFile:@"/private/test_jail.txt" atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
	if(error == nil){
        [[NSFileManager defaultManager] removeItemAtPath:@"/private/test_jail.txt" error:nil];
		return YES;
	} else {
        return NO;
	}
    
    FILE *f = fopen("/bin/bash", "r");
    BOOL isbash = (f != NULL);
    fclose(f);
    
    if (isbash) {
        return YES;
    }
    
    return NO;

}


@end
