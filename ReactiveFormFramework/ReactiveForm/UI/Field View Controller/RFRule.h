//
//  RFFieldRule.h
//  RFKit
//
//  Created by Denis Mikhaylov on 08/08/13.
//  Copyright (c) 2013 Denis Mikhailov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RFField+RFRuleCreation.h"

@interface RFRule : NSObject
- (id)initWithFieldClass:(Class)fieldClass fieldNames:(NSArray *)fieldNames instantiator:(RFInstantiator)instantiator;
- (NSInteger)matchLevelForField:(RFField *)field;
- (id)createFieldViewControllerForField:(RFField *)field;
@end

