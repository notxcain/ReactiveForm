//
//  RFMockFormElementSpec.m
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 14/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "KWMock+RFFormElement.h"
#import "RFFormElement.h"

SPEC_BEGIN(RFMockFormElementSpec)
describe(@"Mock form element", ^{
	context(@"when created with signal", ^{
		RACSubject *subject = [RACSubject subject];
		id <RFFormElement> element = [KWMock mockFormElementWithSignal:subject];
		it(@"should pass all nexts through the visible fields signal", ^{
			__block id next = nil;
			[[element visibleFields] subscribeNext:^(id x) {
				next = x;
			}];
			[subject sendNext:@1];
			[[next should] equal:@1];
		});
	});
});
SPEC_END