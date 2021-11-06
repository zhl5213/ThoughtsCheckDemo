//
//  NSObject+TestProtocol.m
//  DemoAppTests
//
//  Created by 朱慧林 on 2021/10/22.
//

#import "NSObject+TestProtocol.h"
//#import "TestObject.h"

@implementation NSObject (TestProtocol)

- (void)testInstanceMethodWith:(NSString *)testStr {
    extern NSString* testObGlobalStr;
    testObGlobalStr = @"is global str";
//    staticStr = @"is static,can set outside";
    NSLog(@"test str is %@,test object globalStr is %@,test object staticStr is %@",testStr,testObGlobalStr,@"staticStr");
}

- (void)testNoProtocol {
    NSLog(@"not protocol method");
}

@end
