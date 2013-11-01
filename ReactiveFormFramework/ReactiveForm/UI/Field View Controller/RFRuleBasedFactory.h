//
//  RFFieldViewControllerFactory.h
//  RFKit
//
//  Created by Denis Mikhaylov on 07/08/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFField.h"

@class RFFieldViewController;
@protocol RFRuleBasedFactoryRule;

typedef id(^RFInstantiator)(RFField *field);

@interface RFRuleBasedFactory : NSObject
- (instancetype)initWithRules:(NSArray *)rules;
- (RFFieldViewController *)createFieldViewControllerForField:(RFField *)field;
@end


