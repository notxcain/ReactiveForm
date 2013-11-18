//
//  RFEFormPresentation.m
//  ReactiveFormExample
//
//  Created by Denis Mikhaylov on 18/11/13.
//  Copyright (c) 2013 ReactiveForm. All rights reserved.
//

#import "RFEFormPresentation.h"
#import <ReactiveForm/ReactiveForm.h>
#import "RFETextFieldController.h"
#import "RFEChoiceFieldController.h"
#import "RFEActionFieldController.h"

@implementation RFFormPresentation (Example)
+ (instancetype)formPresentation
{
	return [RFFormPresentation createWithBlock:^(id<RFFormPresentationBuilder> builder) {
        [builder addMatcher:[RFTextField class] instantiator:^(RFTextField *field) {
			RFETextFieldController *controller = [[RFETextFieldController alloc] init];
			controller.field = field;
            return controller;
        }];
		[builder addMatcher:[RFChoiceField class] instantiator:^(RFChoiceField *field) {
			RFEChoiceFieldController *controller = [[RFEChoiceFieldController alloc] init];
			controller.field = field;
            return controller;
        }];
		[builder addMatcher:[RFActionField class] instantiator:^(RFActionField *field) {
			RFEActionFieldController *controller = [[RFEActionFieldController alloc] init];
			controller.field = field;
            return controller;
        }];
    }];
}
@end
