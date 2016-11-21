//
//  FHJSONObjectTests.m
//  FHJSONObjectTests
//
//  Created by shenfh on 2016/11/15.
//  Copyright © 2016年 shenfh. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FHJSONObject.h"
@interface FHJSONObjectTests : XCTestCase

@end

@implementation FHJSONObjectTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    FHJSONObject *object = [FHJSONObject jsonFromString:@"{\"title\":\"\u56fe\u96c6\",\"content\":\"\u56fe\u96c6\"}"];
    
    XCTAssert([object type] == FHJSONTypeDictionary,@"解析结果不是一个字典");
    
    NSLog(@"%@",[object rawValue]);
}

- (void)testDictionary {
    NSDictionary *dictionary = @{@"key1" : @"Hello World", @"ke2" :@"value2",@"dic" :@{@"dicKey1" :@"dicValue1",@"dicKey2":@"dicValue2"}};
   
    FHJSONObject *object = [FHJSONObject jsonObject:dictionary];
    XCTAssert([object type] == FHJSONTypeDictionary,@"解析结果不是一个字典");
   
    FHJSONObject *keyObject = [object objectForKey:@"key1"];
    
    XCTAssert( [keyObject type] == FHJSONTypeString,@"解析结果不是一个字符串");
    
    FHJSONObject *dicObject = [object objectForKey:@"dic"];
    
     XCTAssert([dicObject type] == FHJSONTypeDictionary,@"解析结果不是一个字典");
    
    FHJSONObject *nullObject = [[object objectForKey:@"key1"] objectForKey:@"key1"];
    
     XCTAssert([nullObject type] == FHJSONTypeNull,@"解析结果不是一个null");
    
    NSLog(@"value ======== %@",[[[object objectForKey:@"dic"] objectForKey:@"dicKey6"]stringValue]);
    
    [object setObjectForKey:@"shenf" object: @{@"Key":@"value",@"key2":@"value2"}];
//    [object setObjectAtIndex:1 object:@"arrar"];
     NSLog(@"\n%@\n",[object rawValue]);
}

- (void) testArray {
    NSArray *array = @[@"array1",@"array2",@"array3",@(4)];
   
    FHJSONObject *object = [FHJSONObject jsonObject:array];
    
    XCTAssert([object type] == FHJSONTypeArray, @"解析结果不是一个Array");
    
    FHJSONObject *firstObject = [object objectAtIndex:0];
    
    XCTAssert([firstObject type] == FHJSONTypeString,@"解析结果不是一个字符串");
    
    FHJSONObject *numObject = [object objectAtIndex:3];
    XCTAssert([numObject type] == FHJSONTypeNumber,@"解析结果不是一个数字");
    
    [object setObjectAtIndex:0 object:@{@"Key":@"value",@"key2":@"value2"}];
     NSLog(@"\n%@\n",[object rawValue]);
    
    NSLog(@"\n\nstirngValue=%@\n", [[[object objectForKey:@"shenfh"] objectForKey:@"shenfh"]stringValue]);
   
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
        NSArray *array = @[@"array1",@"array2",@"array3",@(4)];
        
        FHJSONObject *object = [FHJSONObject jsonObject:array];
        
        XCTAssert([object type] == FHJSONTypeArray, @"解析结果不是一个Array");
        
        NSDictionary *dictionary = @{@"key1" : @"Hello World", @"ke2" :@"value2",@"dic" :@{@"dicKey1" :@"dicValue1",@"dicKey2":@"dicValue2"}};
        
        FHJSONObject *object1 = [FHJSONObject jsonObject:dictionary];
        XCTAssert([object1 type] == FHJSONTypeDictionary,@"解析结果不是一个字典");
    }];
}

@end
