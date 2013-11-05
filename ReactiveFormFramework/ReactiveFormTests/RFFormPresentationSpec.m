//
//  RFFormPresentationSpec.m
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 05/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "RFFormPresentation.h"
#import "RFFieldViewController.h"
#import "RFField.h"
#import "RFTextField.h"

SPEC_BEGIN(RFFormPresentationSpec)
describe(@"Form presentation", ^{
	context(@"when created j", ^{
		
		RFField *field = [RFField fieldWithName:@"account" title:@"title"];
		RFTextField *textField = [RFTextField fieldWithName:@"textField" title:@"dds"];
		RFFieldController *controller = [RFFieldController mock];
		RFFieldController *textController = [RFFieldController mock];
		RFFormPresentation *presentation = [RFFormPresentation createWithBlock:^(id <RFFormPresentationBuilder> builder) {
			[builder addMatcher:@"account" instantiator:^(RFField *field) {
				return controller;
			}];
			[builder addMatcher:[RFTextField class] instantiator:^(RFField *field) {
				return textController;
			}];
		}];
		
		[[[presentation controllerForField:field] should] equal:controller];
		[[[presentation controllerForField:textField] should] equal:textController];
	});
});
SPEC_END