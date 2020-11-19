//
//  NSObject+MehodSwizzle.m
//  MiniEye
//
//  Created by user_ on 2019/8/12.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

#import "NSObject+MehodSwizzle.h"
#import <objc/runtime.h>

@implementation NSObject (MehodSwizzle)

+ (void)swizzleClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Class class = cls;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
