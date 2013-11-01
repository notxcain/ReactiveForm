//
//  QWAnythingYouWantFactory.m
//  factoryObjects
//
//  Created by Alexander Desyatov on 31.10.13.
//  Copyright (c) 2013 Alexander Desyatov. All rights reserved.
//

#import "RFFieldControllerFactory.h"
#import "RFRuleMap.h"
#import "RFClassWrapper.h"

static NSString *DFFieldKeyPath = @"name";

@interface RFFieldControllerFactory ()
@property(nonatomic,strong,readonly) RFRuleMap *ruleMap;
@end

@implementation RFFieldControllerFactory

- (id)initWithRules:(NSDictionary *)rules
{
    self = [super init];
    if (self) {
        _ruleMap = [[RFRuleMap alloc] initWithRules:rules identifierKeyPath:DFFieldKeyPath];
    }
    return self;
}

- (id)createObjectWithObject:(id)object
{
    id (^resultBlock)(id object) = [self.ruleMap  objectForObject:object];
    return resultBlock(object);;
}

@end

@implementation RFField (Rule)
+ (id<NSCopying>)ruleForName:(NSString *)fieldName
{
    return fieldName;
}

+ (id<NSCopying>)classRule
{
    return [[RFClassWrapper alloc] initWithClass:self];
}
@end