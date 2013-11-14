//
//  RFFormContentProviderSpec.m
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 13/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RFFormContentProvider.h"
#import "RFContainer.h"
#import "RFField.h"

SPEC_BEGIN(RFMutableFormContentProviderSpec)
describe(@"Mutable form content provider", ^{
	__block RFMutableFormContentProvider *provider = nil;
	beforeEach(^{
		provider = [RFMutableFormContentProvider contentProvider];
	});
	context(@"when created", ^{
		it(@"should send empty ordered set", ^{
			[[[[provider visibleSections] first] should] beEmpty];
		});
	});
	context(@"when empty section is added", ^{
		it(@"should send empty ordered set", ^{
			[provider addSectionWithElement:[RFContainer container]];
			[[[[provider visibleSections] first] should] beEmpty];
		});
	});
	
	context(@"when non empty section is added", ^{
		it(@"should send ordered set containing this section", ^{
			RFField *field = [RFField fieldWithName:@"field" title:@"field"];
			id section = [provider addSectionWithElement:field];
			[[[[provider visibleSections] first] should] equal:[NSOrderedSet orderedSetWithObject:section]];
		});
	});
	
	context(@"when a section with an empty mutable container is added", ^{
		it(@"should send an empty ordered set", ^{
			RFContainer *container = [RFContainer container];
			[provider addSectionWithElement:container];
			[[[[provider visibleSections] first] should] beEmpty];
		});
		it(@"should send an ordered set containing this section whe non empty form element is added to the container", ^{
			RFContainer *container = [RFContainer container];
			id section = [provider addSectionWithElement:container];
			[container addElement:[RFField fieldWithName:@"field" title:@"field"]];
			[[[[provider visibleSections] first] should] containObjects:section, nil];
		});
	});
});
SPEC_END
