# FHJSONObject
Objective-c JSON 数据解析

# Installation
## CocoaPods

```ruby
 pod 'FHJSONObject', :git => 'https://github.com/shenfh/FHJSONObject.git', :branch => 'master'
```

# Use

## Dictionary
```ruby
  FHJSONObject *object = [FHJSONObject jsonFromString:@"{\"title\":\"\u56fe\u96c6\",\"content\":\"\u56fe\u96c6\"}"];    
  XCTAssert([object type] == FHJSONTypeDictionary,@"解析结果不是一个字典");
```

```ruby
  NSDictionary *dictionary = @{@"key1" : @"Hello World", @"ke2" :@"value2",@"dic" :@{@"dicKey1"              :@"dicValue1",@"dicKey2":@"dicValue2"}};
   
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
```
## Array
```ruby
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
```

