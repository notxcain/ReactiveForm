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
	context(@"when create with form element", ^{
		__block RFSection *section = nil;
		__block RACSubject *fieldsSubject = nil;
		beforeEach(^{
			fieldsSubject = [RACSubject subject];
			section = [RFSection sectionWithFormElement:[KWMock mockFormElementWithSignal:fieldsSubject]];
		});
		it(@"should expose fields send by form element", ^{
			NSArray *fields = @[[RFField fieldWithName:@"mock" title:nil], [RFField fieldWithName:@"mock2" title:nil]];
			[fieldsSubject sendNext:fields];
			[[section.fields should] equal:[NSOrderedSet orderedSetWithArray:fields]];
		});
	});
});
SPEC_END


