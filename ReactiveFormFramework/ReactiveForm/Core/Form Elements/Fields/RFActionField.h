//
//  RFActionFormField.h
//  Form
//
//  Created by Denis Mikhaylov on 17.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFField.h"

@class RACCommand;
@interface RFActionField : RFField
@property (nonatomic, strong) RACCommand *command;
- (RACSignal *)performAction;
@end
