//
//  RFContainerSpec.m
//  RFKit
//
//  Created by Denis Mikhaylov on 10.07.13.
//  Copyright 2013 Denis Mikhaylov. All rights reserved.
//

#import "Kiwi.h"
#import "RFContainer.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "KWMock+RFFormElement.h"
#import "RFField.h"

SPEC_BEGIN(RFContainerSpec)
describe(@"Container", ^{
	context(@"when created", ^{
		__block RFContainer *container = nil;
		beforeEach(^{
			container = [RFContainer container];
		});
		
		it(@"should expose non nil visibleElements signal", ^{
			[[container visibleFields] shouldNotBeNil];
		});
		
		it(@"should send empty array to subscribers on visibleElements", ^{
			[[[[container visibleFields] first] should] equal:[NSArray array]];
		});
		
		context(@"when mutated", ^{
			__block id <RFFormElement> field = nil;
			
			beforeEach(^{
				field = [RFField fieldWithName:@"" title:@""];
			});
			
			it(@"should send field when field is added", ^{
				[container addElement:field];
				[[[[container visibleFields] first] should] equal:@[field]];
			});
			
			it(@"should propagate visible elements signal", ^{
				id <RFFormElement> element = [KWMock mockFormElementWithElements:@[field]];
				[container addElement:element];
				[[[[container visibleFields] first] should] equal:@[field]];
			});
		});
	});
});
SPEC_END


