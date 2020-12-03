//
//  ARCUTTest.m
//  DemoAppTests
//
//  Created by 朱慧林 on 2020/11/21.
//
extern void _objc_autoreleasePoolPrint(void);

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@interface ARCUTTest : XCTestCase
@property(nonatomic,strong)NSString * stringValue;
@property(nonatomic,strong)dispatch_queue_t councurrentQueue;
@end

@implementation ARCUTTest
@synthesize stringValue = _stringValue;


- (void)setUp {
    
}

- (void)setStringValue:(NSString *)stringValue{
    dispatch_barrier_async(self.councurrentQueue, ^{
        self->_stringValue = stringValue;
    });
}

- (NSString *)stringValue {
    __block NSString * newString;
    dispatch_sync(self.councurrentQueue, ^{
        newString = _stringValue;
    });
    return newString;
}

- (dispatch_queue_t)councurrentQueue {
    if (_councurrentQueue == nil) {
        _councurrentQueue = dispatch_queue_create("cc.minieye.www.stringvaluecontrol", DISPATCH_QUEUE_CONCURRENT);
    }
    return  _councurrentQueue;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAutoRealeasePool {
    @autoreleasepool {
        NSObject * __unsafe_unretained unsafeObject = [NSObject new];
        NSObject * __weak cannoutUseWeakObject = [NSObject new];
        NSObject * __autoreleasing autoReleasingObject = [NSObject new];
        id array = [NSMutableArray array];
        NSObject * strongObject = [NSObject new];
        NSLog(@"unsafeObject is %@,autoReleasingObject is %@,cannoutUseWeakObject is %@",unsafeObject,autoReleasingObject,cannoutUseWeakObject);
        NSLog(@"strongObject is %@,array is %p",strongObject,array);
        _objc_autoreleasePoolPrint();
        [self callSomeStrongObject:strongObject];
    }
}

-(void)callSomeStrongObject:(id)objcet {
    id newObject = [NSObject new];
    @autoreleasepool {
        id __weak canUseWeakObject = newObject;
        NSLog(@"canUseWeakObject is %@",canUseWeakObject);
        NSLog(@"canUseWeakObject is %@",canUseWeakObject);
        NSLog(@"canUseWeakObject is %@",canUseWeakObject);
        NSLog(@"canUseWeakObject is %@",canUseWeakObject);
        _objc_autoreleasePoolPrint();
    }
}

- (void)testPropertyThreadSafe {
    
    
    
}

- (void)testGCD {
    XCTestExpectation * pectation = [[XCTestExpectation alloc]initWithDescription:@"asyncDes"];
    dispatch_queue_t queue = dispatch_queue_create("cc.minieye.www.testGCD", DISPATCH_QUEUE_CONCURRENT);
    NSArray<NSNumber*> * afterTimeArray = [NSArray arrayWithObjects:@0.5,@1,@1.5,@2, nil];
    for (int index = 0; index<afterTimeArray.count; index++) {
        int64_t afterTime = [afterTimeArray[index] intValue];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, afterTime * NSEC_PER_SEC), queue, ^{
            NSLog(@"after %lld秒，string vlaue is %@,in thread %@",afterTime,self.stringValue,[NSThread currentThread]);
        });
    }
    
    for (int i = 0; i<100; i++) {
        dispatch_async(queue, ^{
            [NSThread sleepForTimeInterval:0.1];
            NSString * newString = [[NSString alloc]initWithFormat:@"dwaojo%d",i];
            NSLog(@"will set newString %@ at index %d thread is %@",newString,i,[NSThread currentThread]);
                self.stringValue = newString;
        });
    }
    
    NSArray * pectaionArray = [[NSArray alloc]initWithObjects:pectation, nil];
    [self waitForExpectations:pectaionArray timeout:20];
    
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
