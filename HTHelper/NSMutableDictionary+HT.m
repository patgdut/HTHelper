//
//  NSMutableDictionary+HT.m
//
//
//  Created by 任健生 on 13-7-23.
//  Copyright (c) 2013年 HT. All rights reserved.
//

#import "NSMutableDictionary+HT.h"

@implementation NSMutableDictionary (HT)

static void (*origin_mutable_setObject_forKey)(id self, SEL _cmd, id anObject, id<NSCopying> aKey);
static void (*origin_setObject_forKey)(id self, SEL _cmd, id anObject, id<NSCopying> aKey);

void custom_mutable_setObject_forKey(id self, SEL _cmd, id anObject, id<NSCopying> aKey) {
    
    if (!self || !_cmd) {
        return;
    }
    
    if (anObject && aKey) {
        origin_mutable_setObject_forKey(self, _cmd, anObject, aKey);
//        [self performSelector:@selector(ORIGsetObject:forKey:) withObject:anObject withObject:aKey];
    } else {
        NSLog(@"%@",[NSThread callStackSymbols]);
        NSLog(@"obejct:%@ 或 key:%@ 为非法对象,试图插入到:%@ ", anObject, aKey, self);
    }
}

void custom_setObject_forKey(id self, SEL _cmd, id anObject, id<NSCopying> aKey) {
    
    if (!self || !_cmd) {
        return;
    }
    
    if (anObject && aKey) {
        origin_setObject_forKey(self, _cmd, anObject, aKey);
//        [self performSelector:@selector(ORIGsetObject:forKey:) withObject:anObject withObject:aKey];
    } else {
        NSLog(@"%@",[NSThread callStackSymbols]);
        NSLog(@"obejct:%@ 或 key:%@ 为非法对象,试图插入到:%@ ", anObject, aKey, self);
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class clazz = NSClassFromString([NSString stringWithFormat:@"%@%@",@"__",@"NSDictionaryM"]);
        Method origMethod = class_getInstanceMethod(clazz, @selector(setObject:forKey:));
        origin_mutable_setObject_forKey = (void *)method_getImplementation(origMethod);
        [NSObject swizzle:clazz
                     from:@selector(setObject:forKey:)
                       to:@selector(custom_mutable_setObject_forKey)
                      imp:(IMP)custom_mutable_setObject_forKey];
        
        
        Class clazz2 = NSClassFromString([NSString stringWithFormat:@"%@%@",@"__",@"NSCFDictionary"]);
        Method origMethod2 = class_getInstanceMethod(clazz2, @selector(setObject:forKey:));
        origin_setObject_forKey = (void *)method_getImplementation(origMethod2);
        [NSObject swizzle:clazz2
                     from:@selector(setObject:forKey:)
                       to:@selector(custom_setObject_forKey)
                      imp:(IMP)custom_setObject_forKey];
        
        
    });
}



@end
