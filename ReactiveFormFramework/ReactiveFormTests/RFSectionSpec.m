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
		NSArray *moreFields = [fields arrayByAddingObject:[RFField fieldWithName:@"field3" title:@"Field 3"]];
		beforeEach(^{
			fieldsSubject = [RACSubject subject];
			section = [RFSection sectionWithFormElement:[KWMock mockFormElementWithSignal:fieldsSubject]];
		});
		
		it(@"should expose fields send by the form element through fields property", ^{
			[fieldsSubject sendNext:fields];
			[[section.fields should] equal:[NSOrderedSet orderedSetWithArray:fields]];
			[fieldsSubject sendNext:moreFields];
			[[section.fields should] equal:[NSOrderedSet orderedSetWithArray:moreFields]];
		});
	});
});
SPEC_END


