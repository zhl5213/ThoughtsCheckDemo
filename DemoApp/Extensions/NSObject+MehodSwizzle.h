//
//  NSObject+MehodSwizzle.h
//  MiniEye
//
//  Created by user_ on 2019/8/12.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject(MehodSwizzle)

+ (void)swizzleClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
