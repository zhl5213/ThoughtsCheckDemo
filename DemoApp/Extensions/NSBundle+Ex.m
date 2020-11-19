//
//  NSBundle+Ex.m
//  MiniEye
//
//  Created by user_ on 2019/11/4.
//  Copyright © 2019 MINIEYE. All rights reserved.
//

#import "NSBundle+Ex.h"
#import "NSObject+MehodSwizzle.h"
#import "DemoApp-Swift.h"
#import <UIKit/UIKit.h>

@interface MEBundle : NSBundle

@end

@implementation NSBundle (Ex)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        object_setClass([NSBundle mainBundle], [MEBundle class]);
    });
}

@end


@implementation MEBundle

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)tableName
{
    if ([MEBundle uw_mainBundle]) {
        return [[MEBundle uw_mainBundle] localizedStringForKey:key value:value table:tableName];
    } else {
        return [super localizedStringForKey:key value:value table:tableName];
    }
}

+ (NSBundle *)uw_mainBundle
{
    NSBundle *bundle = LocalizedTool.shared.languageBundle;
    return bundle;
}

@end
