//
//  AnythingYouWantFactory.m
//  factoryObjects
//
//  Created by Alexander Desyatov on 30.10.13.
//  Copyright (c) 2013 Alexander Desyatov. All rights reserved.
//

#import "RFRuleMap.h"
#import "RFClassWrapper.h"

@interface RFRuleMap ()
@property(nonatomic,strong,readonly) NSDictionary *rules;
@property(nonatomic,strong,readonly) NSString *identifierKeyPath;
@end

@implementation RFRuleMap

- (id)initWithRules:(NSDictionary *)rules identifierKeyPath:(NSString *)identifierKeyPath
{
    self = [super init];
    if (self) {
        _rules = rules;
        _identifierKeyPath = identifierKeyPath;
    }
    return self;
}

- (id)objectForObject:(id)object
{
    id result = [[self rules] objectForKey:[object valueForKeyPath:self.identifierKeyPath]];
    if (result) {
        return result;
    }
    RFClassWrapper *classWrapper = [[RFClassWrapper alloc] initWithClass:[object class]];
    return [[self rules] objectForKey:classWrapper];
    
}
@end
