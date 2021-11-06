//
//  TestObject.h
//  DemoAppTests
//
//  Created by 朱慧林 on 2021/9/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * staticStr;

@interface TestObject<T:NSObject *>:NSObject<NSCopying>{
@protected NSString * protectString;
@public NSData * publicData;
@private NSArray * privateArray;
NSString * noDomainString;
}

@property(nonatomic,strong)NSMutableArray * container;

+(void)classMethod:(NSString * )strPara;
-(void)instanceMethod:(NSInteger )intPara;
-(void)setNewObject:(T)object;

@end


@interface  SubTestObject : TestObject

+(void)subClassMethod:(NSString * )strPara;
-(void)subInstanceMethod:(NSInteger )intPara;


@end

NS_ASSUME_NONNULL_END
