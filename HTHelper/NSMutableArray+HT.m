//
//  NSMutableArray+HT.m
//  
//
//  Created by 任健生 on 13-8-1.
//  Copyright (c) 2013年 HT. All rights reserved.
//

#import "NSMutableArray+HT.h"

@implementation NSMutableArray (HT)

static void (*origin_insertObject_atIndex)(id self, SEL _cmd, id anObject, NSInteger index);
static id (*origin_mutable_objectAtIndex)(id self, SEL _cmd, NSInteger index);
static id (*origin_objectAtIndex)(id self, SEL _cmd, NSInteger index);

void custom_insertObject_atIndex(id self, SEL _cmd, id anObject, NSInteger index) {
    
    if (!self || !_cmd) {
        return;
    }
    
    NSArray *array = (NSArray *)self;
    
    if (index > array.count || index < 0) {
        NSLog(@"%@",[NSThread callStackSymbols]);
        NSLog(@"数组越界,试图插入对象:%@ 到数组:%@ 索引:%i", anObject, self, index);
        return;
    }
    
    if (anObject) {
        origin_insertObject_atIndex(self, _cmd, anObject, index);
    } else {
        NSLog(@"%@",[NSThread callStackSymbols]);
        NSLog(@"试图插入空对象到数组,%@,索引:%i",self,index);
    }
}

id custom_mutable_objectAtIndex(id self, SEL _cmd, NSInteger index) {
    
    if (!self || !_cmd) {
        return nil;
    }
    
    NSArray *array = (NSArray *)self;
    
    if (index >=0 && array.count >= index + 1) {
        return origin_mutable_objectAtIndex(self, _cmd, index);
    } else {
        NSLog(@"%@",[NSThread callStackSymbols]);
        NSLog(@"数组越界:%@,index:%i",array,index);
    }
    return nil;
}


id custom_objectAtIndex(id self, SEL _cmd, NSInteger index) {
    
    if (!self || !_cmd) {
        return nil;
    }
    
    NSArray *array = (NSArray *)self;
    
    if (index >=0 && array.count >= index + 1) {
        return origin_objectAtIndex(self, _cmd, index);
    } else {
        NSLog(@"%@",[NSThread callStackSymbols]);
        NSLog(@"数组越界:%@,index:%i",array,index);
    }
    return nil;
}

+ (void)load {
  
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // NSMutalbeArray
        Class clazz = NSClassFromString([NSString stringWithFormat:@"%@%@",@"__",@"NSArrayM"]);
        
        Method origMethod = class_getInstanceMethod(clazz, @selector(insertObject:atIndex:));
        origin_insertObject_atIndex = (void *)method_getImplementation(origMethod);
        
        [NSObject swizzle:clazz
                     from:@selector(insertObject:atIndex:)
                       to:@selector(custom_insertObject_atIndex)
                      imp:(IMP)custom_insertObject_atIndex];
        
        origMethod = class_getInstanceMethod(clazz, @selector(objectAtIndex:));
        origin_mutable_objectAtIndex = (void *)method_getImplementation(origMethod);
        
        [NSObject swizzle:clazz
                     from:@selector(objectAtIndex:)
                       to:@selector(custom_mutable_objectAtIndex)
                      imp:(IMP)custom_mutable_objectAtIndex];
        
        // NSArray
        Class clazz2 = NSClassFromString([NSString stringWithFormat:@"%@%@",@"__",@"NSArrayI"]);
        
        origMethod = class_getInstanceMethod(clazz2, @selector(objectAtIndex:));
        origin_objectAtIndex = (void *)method_getImplementation(origMethod);
        
        [NSObject swizzle:clazz2
                     from:@selector(objectAtIndex:)
                       to:@selector(custom_objectAtIndex)
                      imp:(IMP)custom_objectAtIndex];
        
    });

    
}


@end
