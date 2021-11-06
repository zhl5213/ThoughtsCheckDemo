//
//  TestObject.m
//  DemoAppTests
//
//  Created by 朱慧林 on 2021/9/25.
//

#import "TestObject.h"
#import <mach/mach_time.h>

NSString* testObGlobalStr = @"init global str";

@interface TestObject ()


@property(nonatomic,strong,readonly)NSString * readonlyString;
@property(nonatomic,strong)id storeObject;


@end

@implementation TestObject

@synthesize readonlyString = _readonlyString;
@synthesize container = _container;
static NSString * testString;


-(NSMutableArray *)container {
    if (_container == nil) {
        _container = [NSMutableArray array];
    }
    return  _container;
}

- (NSString *)readonlyString{
    [[NSNotificationCenter defaultCenter]addObserverForName:nil object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        NSLog(@"get all notification");
    }];
    kern_return_t result = mach_wait_until(10000);
    return  [NSString stringWithFormat:@"hehe readonly %@",_readonlyString];
}

+ (void)classMethod:(NSString *)strPara {
    NSLog(@"class method excuted for %@",strPara);
}

- (void)setNewObject:(id)object {
    self.storeObject = object;
    NSLog(@"set new object %@",object);
}


- (void)instanceMethod:(NSInteger)intPara{
    self->privateArray = @[@1];
    self->noDomainString = @"235";
    static NSString * testString2;
    testString = @"test str";
    testString2 = @"test str2";
    NSLog(@"instance method excuted for %ld,read only str is  %@,privateArray is %@",(long)intPara,self.readonlyString,self->privateArray);
    
}



@end


@implementation SubTestObject

+ (void)subClassMethod:(NSString *)strPara {
    NSLog(@"sub class method excuted for %@",strPara);
}

- (void)subInstanceMethod:(NSInteger)intPara{
    self->protectString = @"protect string";
   
    NSLog(@"sub instance method excuted for %ld,protect string is%@",(long)intPara,self->protectString);
}


+ (void)classMethod:(NSString *)strPara {
    [super classMethod:strPara];
    [self subClassMethod:strPara];
    NSLog(@"sub over ride class method");
}

@end


