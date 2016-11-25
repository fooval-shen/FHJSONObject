//
//  FHJSONObject.h
//  FHJSONObject
//
//  Created by shenfh on 2016/11/15.
//  Copyright © 2016年 shenfh. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,FHJSONType) {
    FHJSONTypeNull = 0,
    FHJSONTypeNumber,
    FHJSONTypeArray,
    FHJSONTypeDictionary,
    FHJSONTypeString,
    FHJSONTypeJSON,
};

@interface FHJSONObject : NSObject
+ (nonnull instancetype) jsonObject:(nullable id)object;
+ (nonnull instancetype) jsonFromString:(nonnull NSString*)jsonString;


@property(nonatomic,assign,readonly) FHJSONType type;
@property(nonatomic,weak,readonly,nullable) id rawValue;

- (BOOL) isEqual:(nonnull FHJSONObject*) object;
- (nullable FHJSONObject*) firstObject;

#pragma mark Dictionary action
- (nonnull FHJSONObject*) objectForKey:(nonnull NSString*)key;
- (void) setObjectForKey:(nonnull NSString*)key object:(nonnull id)object;;
- (void) removeObjectForKey:(nonnull NSString*)key;

- (nullable NSDictionary<NSString*,FHJSONObject*>*) dictionary;
- (nonnull  NSDictionary<NSString*,FHJSONObject*>*) dictionaryValue;

#pragma mark Array action
- (nonnull FHJSONObject*) objectAtIndex:(NSUInteger)index;
- (void) setObjectAtIndex:(NSUInteger)index object:(nonnull id)object;
- (void) removeObjectAtIndex:(NSUInteger)index;
- (nullable FHJSONObject*) lastObject;

- (nullable NSArray<FHJSONObject*> *) array;
- (nonnull  NSArray<FHJSONObject*> *) arrayValue;


#pragma mark string action
- (nullable NSString*)string;
- (nonnull NSString*)stringValue;

#pragma mark num action
- (nullable NSNumber*) number;
- (nonnull NSNumber *) numberValue;

- (BOOL) boolValue;
- (double) doubleValue;

- (NSInteger) integerValue;
- (NSUInteger) unsignedIntegerValue;

@end
