//
//  RFFormPresentationSpec.m
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 05/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "RFFormPresentation.h"
#import "RFFieldController.h"
#import "RFField.h"
#import "RFTextField.h"

SPEC_BEGIN(RFFormPresentationSpec)
describe(@"Form presentation", ^{
	context(@"when created j", ^{
		RFField *field = [RFTextField fieldWithName:@"account" title:@"title"];
		RFTextField *textField = [RFTextField fieldWithName:@"textField" title:@"dds"];
		RFTextField *textField1 = [RFTextField fieldWithName:@"textField1" title:@"dds"];
		RFFieldController *controller = [[RFFieldController alloc] init];
		RFFieldController *textController = [[RFFieldController alloc] init];
		
		RFFormPresentation *presentation = [RFFormPresentation createWithBlock:^(id <RFFormPresentationBuilder> builder) {
			[builder addMatcher:@"account" instantiator:^(RFField *field) {
				return controller;
			}];
			[builder addMatcher:[RFTextField class] instantiator:^(RFField *field) {
				return textController;
			}];
		}];
		
		it(@"should evaluate matcher in given order", ^{
			[[[presentation controllerForField:field] shouldNot] equal:textController];
			[[[presentation controllerForField:field] should] equal:controller];
			[[[presentation controllerForField:textField] should] equal:textController];
			[[[presentation controllerForField:textField1] should] equal:textController];
		});
	});
});
SPEC_END