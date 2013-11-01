//
//  RFChoiceFormField.h
//  Form
//
//  Created by Denis Mikhaylov on 19.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFField.h"

@class RACSignal;
@class RACCommand;
@interface RFChoiceField : RFField
@property (nonatomic, copy) NSArray *choices;
+ (instancetype)fieldWithName:(NSString *)name title:(NSString *)title choices:(NSArray *)choices;
@end