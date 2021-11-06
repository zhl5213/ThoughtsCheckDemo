//
//  OCViewController.m
//  DemoApp
//
//  Created by 朱慧林 on 2020/12/17.
//

#import "OCViewController.h"


@interface OCViewController ()
@property(nonatomic,copy)NSMutableArray * mutableArray;
@property(nonatomic,copy)NSArray * array;

@end

@implementation OCViewController

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

//-(void *) callBack(CFSocketRef s, CFSocketCallBackType type, CFDataRef address, const void *data, void *info) {
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self testArrayCopy];
//    CFAllocatorRef allocator = CFAllocatorGetDefault();
    
//    CFSocketRef socket = CFSocketCreate(allocator, AF_INET, SOCK_STREAM, 0, 1, callBack, NULL);
}

- (void)testArrayCopy {
    NSMutableArray * mutableCopyArrayFromOld = [self.mutableArray mutableCopy]; 
    NSArray * immutableCopyArrayFromMutable = [self.mutableArray copy];
    
    NSMutableArray * mutableCopyArrayFromImutable = [self.array mutableCopy];
    NSArray * immutableCopyArrayFromOld = [self.array copy];
       
    NSLog(@"self.mutableArray is %p,self.array is %p\n",self.mutableArray,self.array);
    
    NSLog(@"mutableCopyArrayFromOld is %p,immutableCopyArrayFromMutable is %p,mutableCopyArrayFromImutable is %p,immutableCopyArrayFromOld is %p\n",mutableCopyArrayFromOld,immutableCopyArrayFromMutable,mutableCopyArrayFromImutable,immutableCopyArrayFromOld);
    
    [self logArrayElements:self.mutableArray forSome:@"origin mutable array"];
    [self logArrayElements:self.array forSome:@"origin array"];
    [self logArrayElements:mutableCopyArrayFromOld forSome:@"mutableCopyArrayFromOld"];
    [self logArrayElements:immutableCopyArrayFromMutable forSome:@"immutableCopyArrayFromMutable"];
    [self logArrayElements:mutableCopyArrayFromImutable forSome:@"mutableCopyArrayFromImutable"];
    [self logArrayElements:immutableCopyArrayFromOld forSome:@"immutableCopyArrayFromOld"];
    
    
}

-(void)logArrayElements:(NSArray*) array forSome:(NSString*)name {
    
    for (int index = 0; index<array.count; index++) {
        NSLog(@"at index %d, value is %p for %@ \n",index,array[index],name);
    }
    NSLog(@"-----\n\n");
    
}


@end
