//
//  RFActionFormField.h
//  Form
//
//  Created by Denis Mikhaylov on 17.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFField.h"

typedef  id (^RFActionFieldCommandValueBlock)(void);

@class RACCommand;
@interface RFActionField : RFField
- (void)setCommand:(RACCommand *)command valueBlock:(RFActionFieldCommandValueBlock)valueBlock;

/// Executes a command with a value received from the value block, ignores all values, sends completed or error;
- (RACSignal *)performAction;
@end
