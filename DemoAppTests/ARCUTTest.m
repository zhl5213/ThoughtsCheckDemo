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
@property(nonatomic,copy)NSMutableArray * mutableArray;
@property(nonatomic,copy)NSArray * array;
@property(nonatomic,strong)dispatch_semaphore_t semaphore;
@property(nonatomic,assign)NSInteger times;

@end

@implementation ARCUTTest

@synthesize stringValue = _stringValue;

- (NSMutableArray *)mutableArray{
    if (_mutableArray == nil) {
        _mutableArray = [NSMutableArray array];
        for (int index = 0; index<10; index++) {
            [_mutableArray addObject:[NSNumber numberWithInt:index]];
        }
    }
    return _mutableArray;
}

- (NSArray *)array{
    if (_array == nil) {
        _array = [[NSArray alloc]initWithObjects:@1,@2,@3,@4,@5,@6, nil];
    }
    return _array;
}

- (NSInteger)times {
    return  3;
}


//- (dispatch_semaphore_t)semaphore {
//    if (_semaphore == nil) {
//        _semaphore = dispatch_semaphore_create(-self.times + 1);
//    }
//    return _semaphore;
//}


- (void)testEventsCombine {
    XCTestExpectation * pectation = [[XCTestExpectation alloc]initWithDescription:@"asyncDes"];
    self.semaphore = dispatch_semaphore_create(0);

    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"excuted after wait %ld things has done",(long)self.times);
        [pectation fulfill];
    });
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        NSLog(@"first thing will done");
        [NSThread sleepForTimeInterval:1];
        dispatch_semaphore_signal(self.semaphore);
    });
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        NSLog(@"second thing will done");
        [NSThread sleepForTimeInterval:0.5];
        dispatch_semaphore_signal(self.semaphore);
    });
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_DEFAULT, 0), ^{
        NSLog(@"third thing will done");
        [NSThread sleepForTimeInterval:0.5];
        dispatch_semaphore_signal(self.semaphore);
    });
    
    [self waitForExpectations:@[pectation] timeout:10];
}



- (void)testArrayCopy {
    NSMutableArray * mutableCopyArrayFromOld = [_mutableArray mutableCopy];
    NSArray * immutableCopyArrayFromMutable = [_mutableArray copy];
    
    NSMutableArray * mutableCopyArrayFromImutable = [_array mutableCopy];
    NSArray * immutableCopyArrayFromOld = [_array copy];
    
    NSMutableArray *mutaArrayFromImu = (NSMutableArray *) immutableCopyArrayFromOld;
    
    NSLog(@"mutableCopyArrayFromOld is %p,immutableCopyArrayFromMutable is %p,mutableCopyArrayFromImutable is %p,immutableCopyArrayFromOld is %p\n",mutableCopyArrayFromOld,immutableCopyArrayFromMutable,mutableCopyArrayFromImutable,immutableCopyArrayFromOld);

    NSLog(@"mutableCopyArrayFromOld value is %@,immutableCopyArrayFromMutable value is %@,mutableCopyArrayFromImutable value is %@,immutableCopyArrayFromOld value is %@\n",mutableCopyArrayFromOld,immutableCopyArrayFromMutable,mutableCopyArrayFromImutable,immutableCopyArrayFromOld);
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
        
        [[NSThread mainThread]performSelector:@selector(setMutableArray:) withObject:self];
        
    }
}

- (void)testForLoopAutoReleasePool {
    for (int i = 0; i<1000; i++) {
        NSObject * object = [[NSObject alloc]init];
        NSLog(@"object is %@",object);
    }
    _objc_autoreleasePoolPrint();
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

@end
