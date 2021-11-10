//
//  OCPrincipleAndStructure.m
//  DemoAppTests
//
//  Created by 朱慧林 on 2021/9/25.

//

//-(NSInteger)globalOCMethod:(NSInteger)firstPa and:(NSInteger)secondPar {
//    return firstPa + secondPar
//}

#import <XCTest/XCTest.h>
#import "TestObject.h"
#import "NSObject+TestProtocol.h"

typedef NSInteger (^caculateBlock)(NSInteger firstPar,NSInteger secondPa);
@interface OCPrincipleAndStructure : XCTestCase

@property(nonatomic,strong) caculateBlock stackBlock;
@property(nonatomic,strong) NSObject * array;


@end

@implementation OCPrincipleAndStructure

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.stackBlock = ^(NSInteger firstPar,NSInteger secondPa){
        NSLog(@"set up stack block,first para is %ld,second para is %ld",(long)firstPar,(long)secondPa);
        return firstPar + secondPa;
    };
    NSLog(@"type of stack block is %@",[self.stackBlock class]);
}


- (void)testSynchronize {
    self.array = [NSObject new];
    XCTestExpectation * textExpectation = [[XCTestExpectation alloc]initWithDescription:@"123"];
    dispatch_queue_t conQueue = dispatch_queue_create("testqueue", DISPATCH_QUEUE_CONCURRENT);
    for (int i = 0 ; i<100000; i++) {
        dispatch_async(conQueue, ^{
            @synchronized (self.array) {
                self.array = [NSObject new];
                NSLog(@"current i is%d",i);
            }
        });
    }
    [self waitForExpectations:@[textExpectation] timeout:30];
}

- (void)testNSMutableArrayGCD {
    XCTestExpectation * textExpectation = [[XCTestExpectation alloc]initWithDescription:@"123"];

    for (int i = 0; i<20000; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.array = [NSMutableArray array];
            NSLog(@"set array for index %d at thread %@",i,[NSThread currentThread].name);
        });
    }
    [self waitForExpectations:@[textExpectation] timeout:30];

}


- (void)testFunction {
    NSInteger result = self.stackBlock(10, 15);
    NSLog(@"type of stack block is %@,result is %d",[self.stackBlock class],result);
    
    typedef NSInteger(^resultBlock)();
    resultBlock returnedBlock = [self highLevelFucPara:self.stackBlock firstPar:3 secondPar:5];
    NSInteger newResult = returnedBlock();
    NSLog(@"type of result block is %@,result is %d",[returnedBlock class],newResult);
        
}

-(NSInteger) methodOfTwoNsinteger:(NSInteger)first and:(NSInteger)second {
    return  first * second;
}

-(NSInteger(^)(void))highLevelFucPara:(caculateBlock) blockpar firstPar:(NSInteger)first secondPar:(NSInteger)second {
    return ^{
        return blockpar(first,second);
    };
}

- (void)testProtectPropertyWithTestObejct {
    TestObject * testobject = [TestObject new];
    testobject->publicData  = [NSData data];
    [testobject instanceMethod:3];
    NSLog(@"test obeject is %@,public data is %@",testobject,testobject->publicData);
    SubTestObject * subTestObject = [SubTestObject new];
    [subTestObject subInstanceMethod:5];
}

- (void)testKVCUseTestObject {
    TestObject * kvcOb = [TestObject new];
    [kvcOb instanceMethod:3];
    [kvcOb setValue:@"new ro str" forKey:@"readonlyString"];
    [kvcOb instanceMethod:3];
    NSObject * object = [NSObject new];
    [object testNoProtocol];
    [object testInstanceMethodWith:@"some test"];
    [kvcOb setNewObject:object];
    id <TestProtocol> protocol;
    NSArray<TestProtocol> * array = @[[NSObject new]];
}


struct Month {
    char name[30];
    char nameAbbre[3];
    int days;
    int monthNumber;
};

#define MONTHCOUNT_AYEAR 12
- (void)testStructAndUnion {
    struct Month year[MONTHCOUNT_AYEAR];
    
    struct Month * cMonth;
    for (int i = 0; i < MONTHCOUNT_AYEAR; i++) {
        struct Month temp = { "123","11",30,i};
        year[i] = temp;
        year[i].monthNumber = i+1;
        cMonth = year + i;
        printf("for %d month, name is %s, addNames is %s, day numbers are %d ",i,year[i].name,year[i].nameAbbre,year[i].days);
        printf("current month's number is %d \n",cMonth->monthNumber);
    }
    char * words;
    gets(words);
    
    fgets(words, 100, stdin);
    
}

-(void) OCTestMethod:(NSString*)strPar andInt:(NSInteger)intPar {
    
}

- (void)testTripleDimensionArray {
    int rows = 3,cols = 5;
    //变长数组不能够初始化，此处如果用会失败。
    int Array[3][5] = {1,2,3,4,5,7,8,6,5,3,2,1};
    //如此申明变长数组
    double dArray[rows][cols];
    printf("&Array is %p,Array address is %p,Array[0] is %p,&Array[0] is %p,*Array is %p \n",&Array,Array,Array[0],&Array[0],*Array);
    int (* arrayPointer)[cols] = Array;
    for (int i = 0; i<rows; i++) {
        printf("use array pointer,*(arrayPointer+%d) is %p\n",i,*(arrayPointer+i));
        for (int col = 0; col<cols; col ++) {
            printf("*(*(arrayPointer+%d)+%d) is %d\n",i,col,*(*(arrayPointer+i)+col));
        }
    }
    
    for (int i = 0; i<rows; i++) {
        for (int col = 0; col<cols;col++) {
            printf("arrayPointer[%d][%d] is %d,user\n",i,col,arrayPointer[i][col]);
        }
    }
    
    
    int (*arrayPointer2)[cols] = Array + 1;
    for (int i = 0; i<rows; i++) {
        printf("--use array pointer  start with 1,*(arrayPointer2+%d) is %p\n",i,*(arrayPointer2+i));
        for (int col = 0; col<cols;col++) {
            printf("--arrayPointer2[%d][%d] is %d,user\n",i,col,arrayPointer2[i][col]);
        }
    }
}

- (void)testArrayCopy {
    double originArray[20] = {1.3,2.4,0.01,20913};
    double copyInArray[10];
    copyArray(originArray, copyInArray, 8);
    copyArrayUsePointer(originArray, copyInArray, 10);
}

static void copyArray(const double firstArray[],double secondArray[],int rows){
    for (int index = 0; index<rows; index++) {
        secondArray[index] = firstArray[index];
        printf("at index %d , value %lf,copyed into second array\n",index,firstArray[index]);
    }
}

void doSomething() {
    
}

void copyArrayUsePointer(const double * firstArray,double * secondArray,int rows){
    for (int index = 0; index<rows; index++) {
        *(secondArray + index) = * (firstArray + index);
        printf("copy use pointer at index %d , value %lf, into new array\n",index,*(firstArray + index));
    }
}

- (void)testString {
    char * staticString = "a我是全局变量";
    printf("staticString address is %p,\"a我是全局变量\" address is %p,\"a我是全局变量\" 第一个字符是 %c \n",staticString,"a我是全局变量",*("a我是全局变量"+1));
    
//    staticString[0] = 'b';
    printf("after change string literal,\"a我是全局变量\" is %s, staticString is %s","a我是全局变量",staticString);
    //常量'Aaa'在常量区存储的时候是以64个字节存储；取出来放入char的时候，char只占一个字节，因此只会把最后的字符写入charV。
    char charV = 'Aaab';
    char charV2 = '90z';
    //数组长度为5，字符串赋值的时候
    char charArray[5] = "1235562123AAB";
    NSString * nsString = @"1235";
    NSLog(@"ns string pointer is %p add 1 is %p",&nsString, &nsString + 1);
    NSLog(@"c str size is %d, c str length is %d",sizeof(charArray),strlen(charArray));
    NSLog(@" character is %c charV2 is %c, c string is %s, ns string is %@ ",charV,charV2,charArray,nsString);
}

- (void)testPointerAndArray {
    int * ptr;
    int (*ptr2)[2];
    int torf[2][2] = {{12},{14,16}};
    ptr = torf[0];
    ptr2 = torf;
    for (int i = 0; i<2; i++) {
        for (int j = 0 ; j<2; j++) {
            NSLog(@"value at array[%d][%d] is %d",i,j,torf[i][j]);
        }
    }
    NSLog(@"*ptr is %d, *(ptr+2) is %d",*ptr,*(ptr+2));
    NSLog(@"*ptr2 is %d, *(ptr2+1) is %d",**ptr2,**(ptr2+1));

}

- (void)testArrayAndVarLengthArray {
    long array[5][5][10] = {{1,12,23,31,5}};
    excuteArray(array, 5);
    excuteVarableArray(5, 5, 10, array);
    excuteVarableArray(5, 3, 4, (long [5][3][4]){2,1,5,4});
}



void excuteArray(long array[][5][10],int rows) {
    for (int row = 0 ; row < rows; row ++) {
        for (int i = 0 ; i<5; i++) {
            for (int j = 0 ; j<10; j++) {
                printf("element at array[%d][%d][%d] is %ld \n",row,i,j,array[row][i][j]);
            }
        }
    }
}

void excuteVarableArray(int rows,int is,int js, long array[rows][is][js]){
    for (int row = 0 ; row < rows; row ++) {
        for (int i = 0 ; i<is; i++) {
            for (int j = 0 ; j<js; j++) {
                printf("element at varble length array[%d][%d][%d] is %ld \n",row,i,j,array[row][i][j]);
            }
        }
    }
}

- (void)testFloat {
    float floatValue = 0.1;
    NSLog(@"float value is %f",floatValue);
}

- (void)testNil {
//    下面的所有测试都是正确的，3个int的地址都是0x0。
//    int * intValue = NULL;
//    int value = 3;
//    intValue = &value;
//    int * intValue2 = nil;
//    int * intValue3 = Nil;
//    if (intValue == NULL) {
//        NSLog(@"int is null");
//    }
//    if (intValue2 == nil) {
//        NSLog(@"int2 is nil");
//    }
//    if (intValue3 == Nil) {
//        NSLog(@"int3 is Nil");
//    }
//    NSLog(@"intValue is %d，intValue address is %p,intValue2 is %p,intValue3 is %p",*intValue,intValue,intValue2,intValue3);
    
//    NSString * nilStr = nil;
//    NSString * NilStr = Nil;
//    NSString * NULLStr = NULL;
//    if (nilStr == nil) {
//        NSLog(@"nilStr is nil");
//    }
//    if (NilStr == Nil) {
//        NSLog(@"NilStr is nil");
//    }
//    if (NULLStr == NULL) {
//        NSLog(@"NULLStr is NULL");
//    }
//    NSComparisonResult result1 =  [nilStr compare:@"12"];
//    NSComparisonResult result2 =  [NilStr compare:@"12"];
//    NSComparisonResult result3 =  [NULLStr compare:@"12"];
//    NSLog(@"nilStr compare result is %ld,NilStr compare result is %ld,NULLStr compare result is %ld",(long)result1,result2,result3);
//    NSLog(@"nilStr is %p,NilStr is %p,NULLStr is %p",nilStr,NilStr,NULLStr);
//    NSLog(@"nilStr is %@,NilStr is %@,NULLStr is %@",nilStr,NilStr,NULLStr);
    
    NSArray * array = [NSArray arrayWithObjects:@1,@"12",[NSObject new],[NSNull null], nil];
    for (id element in array) {
        if (element == nil) {
            NSLog(@" array element is == nil");
        }else {
            NSLog(@" array element is not == nil");
        }
        NSLog(@"element value is %@,address is %p",element,element);
    }
    NSLog(@"array is %@",array);
}

@end
