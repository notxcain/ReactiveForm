//
//  RFEActionFieldController.h
//  ReactiveFormExample
//
//  Created by Denis Mikhaylov on 15/11/13.
//  Copyright (c) 2013 ReactiveForm. All rights reserved.
//

#import "RFFieldController.h"
@class RFActionField;
@interface RFEActionFieldController : RFFieldController
@property (nonatomic, strong) RFActionField *field;
- (void)select;
@end
