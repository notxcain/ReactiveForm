//
//  RFField+RFRuleCreation.m
//  RFKit
//
//  Created by Denis Mikhaylov on 08/08/13.
//  Copyright (c) 2013 Denis Mikhailov. All rights reserved.
//

#import "RFField+RFRuleCreation.h"
#import "RFRule.h"

@implementation RFField (RFRuleCreation)
+ (id)ruleWithInstantiator:(RFInstantiator)instantiator
{
    return [self ruleForFieldNames:nil instantiator:instantiator];
}

+ (id)ruleForFieldNames:(NSArray *)names instantiator:(RFInstantiator)instantiator;
{
    return [[RFRule alloc] initWithFieldClass:self fieldNames:names instantiator:instantiator];
}
@end
