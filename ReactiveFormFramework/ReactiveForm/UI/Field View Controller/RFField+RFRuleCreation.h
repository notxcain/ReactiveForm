//
//  RFField+RFRuleCreation.h
//  RFKit
//
//  Created by Denis Mikhaylov on 08/08/13.
//  Copyright (c) 2013 Denis Mikhailov. All rights reserved.
//

#import "RFField.h"

typedef id(^RFInstantiator)(RFField *field);

@class RFRule;
@interface RFField (RFRuleCreation)
+ (RFRule *)ruleWithInstantiator:(RFInstantiator)instantiator;
+ (RFRule *)ruleForFieldNames:(NSArray *)names instantiator:(RFInstantiator)instantiator;
@end
