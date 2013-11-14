//
//  RFSectionSpec.m
//  RFKit
//
//  Created by Denis Mikhaylov on 10.07.13.
//  Copyright 2013 Denis Mikhaylov. All rights reserved.
//

#import "Kiwi.h"
#import "RFSection.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "KWMock+RFFormElement.h"
#import "RFField.h"

SPEC_BEGIN(RFSectionSpec)
describe(@"RFSection", ^{
	context(@"when created with a form element", ^{
		__block RFSection *section = nil;
		__block RACSubject *fieldsSubject = nil;
		NSArray *fields = @[[RFField fieldWithName:@"mock" title:nil], [RFField fieldWithName:@"mock2" title:nil]];
		beforeEach(^{
			fieldsSubject = [RACSubject subject];
			section = [RFSection sectionWithFormElement:[KWMock mockFormElementWithSignal:fieldsSubject]];
		});
		
		it(@"should expose fields send by the form element through fields property", ^{
			[fieldsSubject sendNext:fields];
			
			[[section.fields should] equal:[NSOrderedSet orderedSetWithArray:fields]];
		});
		it(@"should send a tuple of a previous and current fields", ^{
			__block RACTuple *tuple = nil;
			[[section changesOfFields] subscribeNext:^(id x) {
				tuple = x;
			}];
			
			[fieldsSubject sendNext:fields];
			RACTupleUnpack(NSOrderedSet *previousSet, NSOrderedSet *currentSet) = tuple;
			[[previousSet should] equal:[NSOrderedSet orderedSet]];
			[[currentSet should] equal:[NSOrderedSet orderedSetWithArray:fields]];
			[fieldsSubject sendNext:fields];
		});
	});
});
SPEC_END


