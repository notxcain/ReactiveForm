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
#import "RFSection.h"

@implementation RACSignal (Expect)
- (id)nextAfterBlock:(void (^)(void))block
{
	__block id next = nil;
	[self subscribeNext:^(id x) {
		next = x;
	}];
	block();
	return next;
}
@end

SPEC_BEGIN(RFMutableFormContentProviderSpec)
describe(@"Mutable form content provider", ^{
	__block RFMutableFormContentProvider *contentProvider = nil;
	beforeEach(^{
		contentProvider = [RFMutableFormContentProvider contentProvider];
	});
	context(@"when created", ^{
		it(@"should send empty ordered set", ^{
			[[[[contentProvider visibleSections] first] should] beEmpty];
		});
	});
	context(@"when empty section is added", ^{
		it(@"should send empty ordered set", ^{
			[contentProvider addSectionWithElement:[RFContainer container]];
			[[[[contentProvider visibleSections] first] should] beEmpty];
		});
	});
	
	context(@"when non empty section is added", ^{
		it(@"should send ordered set containing this section", ^{
			RFField *field = [RFField fieldWithName:@"field" title:@"field"];
			id section = [contentProvider addSectionWithElement:field];
			[[[[contentProvider visibleSections] first] should] equal:[NSOrderedSet orderedSetWithObject:section]];
		});
	});
	
	context(@"when a section with an empty mutable container is added", ^{
		it(@"should send an empty ordered set", ^{
			RFContainer *container = [RFContainer container];
			[contentProvider addSectionWithElement:container];
			[[[[contentProvider visibleSections] first] should] beEmpty];
		});
		it(@"should send an ordered set containing this section whe non empty form element is added to the container", ^{
			RFField *field1 = [RFField fieldWithName:@"field" title:@"field"];
			RACSignal *visibleSections = contentProvider.visibleSections;
			id section = [contentProvider addSectionWithElement:field1];
			[[[visibleSections first] should] equal:[NSOrderedSet orderedSetWithObject:section]];
		});
		it(@"should Wooooork", ^{
			RFField *field1 = [RFField fieldWithName:@"field1" title:@"Field 1"];
			RFField *field2 = [RFField fieldWithName:@"field2" title:@"Field 2"];

			__block NSOrderedSet *visibleSections = nil;
			[[contentProvider visibleSections] subscribeNext:^(id x) {
				visibleSections = x;
			}];
			RFContainer *container1 = [RFContainer container];
			id section = [contentProvider addSectionWithElement:container1];
			[[visibleSections should] beEmpty];
			[container1 addElement:field1];
			[[visibleSections should] equal:[NSOrderedSet orderedSetWithObjects:section, nil]];
			[container1 addElement:field2];
			[container1 removeElement:field1];
			[container1 removeElement:field2];
			[[visibleSections should] beEmpty];
		});
	});
});
SPEC_END
