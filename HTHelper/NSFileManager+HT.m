//
//  NSFileManager+HT.m
//  HTHelper
//
//  Created by 任健生 on 13-11-8.
//  Copyright (c) 2013年 test. All rights reserved.
//

#import "NSFileManager+HT.h"

@implementation NSFileManager (HT)

- (BOOL)hacker_fileExistsAtPath:(NSString *)path {
    if ([path isEqualToString:@"/Applications/Cydia.app"]) {
        return NO;
    }
    return [self hacker_fileExistsAtPath:path];
}

@end
