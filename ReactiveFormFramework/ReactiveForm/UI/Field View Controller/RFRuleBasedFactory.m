//
//  RFFieldViewControllerFactory.m
//  RFKit
//
//  Created by Denis Mikhaylov on 07/08/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFRuleBasedFactory.h"
#import "RFRule.h"

@interface RFRuleBasedFactory ()
@property (nonatomic, strong, readonly) NSArray *rules;
@end

@implementation RFRuleBasedFactory

- (id)initWithRules:(NSArray *)rules
{
    self = [super init];
    if (self) {
        _rules = [rules copy];
    }
    return self;
}

- (id)createFieldViewControllerForField:(RFField *)field
{
    return [[self bestMatchingRuleForField:field] createFieldViewControllerForField:field];
}

- (RFRule *)bestMatchingRuleForField:(RFField *)field
{
    RFRule *bestMatchingRule = nil;
    int maxMatchLevel = 0;
    for (RFRule *rule in self.rules) {
        int matchLevel = [rule matchLevelForField:field];
        if (matchLevel > maxMatchLevel) {
            maxMatchLevel = matchLevel;
            bestMatchingRule = rule;
        }
    }
    return bestMatchingRule;
}
@end
