//
//  FHJSONObject.m
//  FHJSONObject
//
//  Created by shenfh on 2016/11/15.
//  Copyright © 2016年 shenfh. All rights reserved.
//

#import "FHJSONObject.h"

@interface FHJSONObject()
@property(nonatomic,strong) id objectValue;
@end



@implementation FHJSONObject
+(instancetype) jsonNUll {
    static FHJSONObject *jsonNull;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        jsonNull = [FHJSONObject jsonObject:[NSNull null]];
    });
    return jsonNull;
}
+ (instancetype)jsonObject:(id)object {
    FHJSONObject *jObject = [[FHJSONObject alloc]initWidthObject:object];
    return jObject;  
}

+(instancetype) jsonFromString:(NSString*)jsonString {
    if (jsonString == nil) {
        return [FHJSONObject jsonNUll];
    }
    return [FHJSONObject jsonObject:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
}
-(instancetype) initWidthObject:(id)object {
    self = [super init];
    if (self) {
        [self parseJSON:object];
    }
    return self;
}

- (void) parseJSON:(id)object {
    @autoreleasepool {
        if ([object isKindOfClass:NSDictionary.class]) {
            self.objectValue = [NSMutableDictionary dictionaryWithCapacity:[object count]];
            [object enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                self.objectValue[key] = [FHJSONObject jsonObject:obj];
            }];
        } else if( [object isKindOfClass:NSArray.class]) {
            self.objectValue = [NSMutableArray arrayWithCapacity:[object count]];
            for (id value in (NSArray*)object) {
                [self.objectValue addObject:[FHJSONObject jsonObject:value]];
            }
        } else if ([object isKindOfClass:NSString.class]) {
            self.objectValue = object;
        } else if ([object isKindOfClass:NSNumber.class]) {
            self.objectValue = object;
        } else  if ( [object isKindOfClass:NSData.class]) {
            NSError *error ;
            id result =  [NSJSONSerialization JSONObjectWithData:object options:NSJSONReadingAllowFragments error:&error];
            if (error != nil) {
                NSLog(@"%@",error);
            } else {
                if ([result isKindOfClass:NSData.class]) {
                    self.objectValue = nil;
                } else {
                    [self parseJSON:result];
                    return;
                }
            }
            NSAssert(error == nil, @"JSON 解析出错了");
        } else if ([object isKindOfClass:FHJSONObject.class]) {
            self.objectValue = ((FHJSONObject*)object).objectValue;
        } else {
            self.objectValue = object;
        }
    }    
}

- (FHJSONType)type {
    if (self.objectValue == nil || [self.objectValue isKindOfClass:NSNull.class]) {
        return FHJSONTypeNull;
    }
    if ([self.objectValue isKindOfClass:NSString.class]) {
        return FHJSONTypeString;
    }
    if ([self.objectValue isKindOfClass:FHJSONObject.class]) {
        return FHJSONTypeJSON;
    }
    if ([self.objectValue isKindOfClass:NSArray.class]) {
        return FHJSONTypeArray;
    }
    if ([self.objectValue isKindOfClass:NSNumber.class ]) {
        return FHJSONTypeNumber;
    }
    if ([self.objectValue isKindOfClass:NSDictionary.class]) {
        return FHJSONTypeDictionary;
    }
   
    return FHJSONTypeNull;
}

#pragma mark dictionary action
- (FHJSONObject*)objectForKey:(NSString *)key {
    if (self.type == FHJSONTypeDictionary) {
        FHJSONObject *object = [self.objectValue objectForKey:key];
        if ([object isKindOfClass:FHJSONObject.class]) {
            return object;
        }
    }
    return [FHJSONObject jsonNUll];
}

- (void) setObjectForKey:(NSString *)key object:(id)object {
    if (self.type != FHJSONTypeDictionary) {
        NSAssert(false, @"FHJSONObject 不是一个字典哦");
        return;
    }
    if(![self.objectValue isKindOfClass:NSMutableDictionary.class]) {
        self.objectValue = [NSMutableDictionary dictionaryWithDictionary:self.objectValue];
    }
    [((NSMutableDictionary*)self.objectValue) setObject:[FHJSONObject jsonObject:object] forKey:key];
}

- (void) removeObjectForKey:(NSString *)key {
    if (self.type != FHJSONTypeDictionary) {
        NSAssert(false, @"FHJSONObject 不是一个字典哦");
        return;
    }
    if(![self.objectValue isKindOfClass:NSMutableDictionary.class]) {
        self.objectValue = [NSMutableDictionary dictionaryWithDictionary:self.objectValue];
    }
    [self.objectValue removeObjectForKey:key];
}

#pragma mark array action
- (FHJSONObject*) objectAtIndex:(NSUInteger)index {
    if (self.type == FHJSONTypeArray) {
        if (index >= [self.objectValue count]) {
            return [FHJSONObject jsonNUll];
        }
        FHJSONObject *object = [self.objectValue objectAtIndex:index];
        if ([object isKindOfClass:FHJSONObject.class]) {
            return object;
        }
    }
    return [FHJSONObject jsonNUll];
}

- (void) setObjectAtIndex:(NSUInteger)index object:(id)object {
    
    if (self.type != FHJSONTypeArray) {
        NSAssert(false, @"FHJSONObject 不是一个数组");
        return;
    }
    if (![self.objectValue isKindOfClass:NSMutableArray.class]) {
        self.objectValue = [NSMutableArray arrayWithArray:self.objectValue];
    }
    if (index < [self.objectValue count]) {
        [((NSMutableArray*)self.objectValue) replaceObjectAtIndex:index withObject:[FHJSONObject jsonObject:object]];
    } else {
        [self.objectValue addObject:[FHJSONObject jsonObject:object]];
    }
}

- (void) removeObjectAtIndex:(NSUInteger)index {
    if (self.type != FHJSONTypeArray) {
        NSAssert(false, @"FHJSONObject 不是一个数组");
        return;
    }
    if (![self.objectValue isKindOfClass:NSMutableArray.class]) {
        self.objectValue = [NSMutableArray arrayWithArray:self.objectValue];
    }
    if (index < [self.objectValue count]) {
        [self.objectValue removeObjectAtIndex:index];
    }
}

- (id) rawValue {
    if (self.type == FHJSONTypeString) {
        return self.objectValue;
    } else if (self.type == FHJSONTypeJSON ) {
        return [self.objectValue rawValue];
    } else if (self.type == FHJSONTypeNumber ) {
        return self.objectValue;
    } else if (self.type == FHJSONTypeNull) {
        return nil;
    } else if (self.type == FHJSONTypeArray ) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:[self.objectValue count]];
        for (FHJSONObject *object in ((NSArray*)self.objectValue) ) {
            if ([object rawValue] == nil) {
                continue;
            }
            [array addObject:[object rawValue]];
        }
        return array;
    } else if (self.type == FHJSONTypeDictionary ) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:[self.objectValue count]];
        [self.objectValue enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj rawValue] != nil) {
                dic[key] = [obj rawValue];
            }
        }];
        return dic;
    }
    return nil;
}
- (NSString *) string {
    if (self.type == FHJSONTypeString) {
        return self.objectValue;
    } else if (self.type == FHJSONTypeNumber) {
        return [((NSNumber*)self.objectValue) stringValue];
    }
    return nil;
}
- (NSString*) stringValue {
    NSString *value = [self string];
    if (value == nil) {
        return @"";
    }
    return value;
}

- (NSNumber *) number {
    if (self.type == FHJSONTypeNumber) {
        return self.objectValue;
    } else if (self.type == FHJSONTypeString ) {
       return [[NSNumberFormatter alloc]numberFromString:self.objectValue];
    }
    return nil;
}

- (NSNumber *) numberValue {
    NSNumber *number = [self number];
    if (number == nil) {
        return @(0);
    }
    return number;
}
- (BOOL) boolValue {
    return [self.numberValue boolValue];
}
- (double) doubleValue {
    return [self.numberValue doubleValue ];
}
- (NSInteger) integerValue {
    return [self.numberValue integerValue];
}
- (NSUInteger) unsignedIntegerValue {
    return [self.numberValue unsignedIntegerValue];
}

- (NSDictionary*) dictionary {
    if (self.type == FHJSONTypeDictionary) {
        return self.objectValue;
    }
    return nil;
}
- (NSDictionary *) dictionaryValue {
    NSDictionary *dicValue = [self dictionary];  
    if ([dicValue isKindOfClass:NSDictionary.class]) {
        return dicValue;
    }
    return @{};
}

- (NSArray*)  array {
    if (self.type == FHJSONTypeArray) {
        return self.objectValue;
    }
    return nil;
}

- (NSArray*) arrayValue {
    NSArray *array = [self array]; 
    if ([array isKindOfClass:NSArray.class]) {
        return array;
    }
    return @[];
}

- (FHJSONObject*) lastObject {
    if (self.type == FHJSONTypeArray) {
        return [self.objectValue lastObject];
    }
    return nil;
}

- (BOOL) isEqual:(FHJSONObject *)object {
    if (self.type != object.type) {
        return FALSE;
    }
    if (self.type == FHJSONTypeNull) {
        return TRUE;
    }
    if (self.type == FHJSONTypeString ) {
        return [self.rawValue isEqualToString:object.rawValue ];
    }
    
    return [self.rawValue isEqual:object.rawValue];
}
- (FHJSONObject *) firstObject {
    if (self.type == FHJSONTypeDictionary || self.type == FHJSONTypeArray) {
        return [self.objectValue firstObject];
    }
    return nil;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"type = %lu \t rawValuew = %@",(unsigned long)self.type,self.rawValue];
}
- (NSString*) debugDescription {
    return [self description];
}
@end
