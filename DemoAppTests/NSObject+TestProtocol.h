//
//  NSObject+TestProtocol.h
//  DemoAppTests
//
//  Created by 朱慧林 on 2021/10/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol TestProtocol <NSObject>

-(void)testInstanceMethodWith:(NSString*) testStr;

@end


@interface NSObject (TestProtocol)<TestProtocol>

-(void)testNoProtocol;

@end

NS_ASSUME_NONNULL_END
