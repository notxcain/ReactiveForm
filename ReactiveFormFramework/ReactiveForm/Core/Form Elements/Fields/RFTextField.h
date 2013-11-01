//
//  RFTextFormField.h
//  Form
//
//  Created by Denis Mikhaylov on 17.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFField.h"

@protocol RFTextInputController;
@protocol RFValidator;

@interface RFTextField : RFField
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, strong) id <RFTextInputController> textInputController;
@property (nonatomic, strong) id <RFValidator> validator;
@end
