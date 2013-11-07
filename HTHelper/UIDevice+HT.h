//
//  UIDevice+HT.h
//  
//
//  Created by 任健生 on 13-3-2.
//
//

#import <UIKit/UIKit.h>

#define IOS7 [[UIDevice currentDevice] isIOS7]
#define iPad [[UIDevice currentDevice] isPad]

@interface UIDevice (HT)

- (NSInteger)majorVersion;
- (NSString *)platform;
- (BOOL)isPhone;
- (BOOL)isPad;
- (BOOL)isIOS7;
- (void)fixOrientationIfNeed;
- (BOOL)isDebugMode;
- (NSString *)memoryUsage;
- (BOOL)isJailBroken;
- (BOOL)isCracked;

@end
