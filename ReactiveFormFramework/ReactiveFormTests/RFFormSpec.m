//
//  RFFormSpec.m
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 07.11.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "RFForm.h"
#import "RFFormElement.h"
#import "RFField.h"
#import "RFContainer.h"
#import "RFFormContentProvider.h"
#import "KWMock+RFFormElement.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RFFormObserverMock : NSObject <RFFormObserver>
@end

SPEC_BEGIN(RFFormSpec)
describe(@"Form", ^{
   context(@"when created", ^{
       it(@"should return element added in builder", ^{
		   RFField *field1 = [RFField fieldWithName:@"field1" title:@"Field 1"];
		   RFField *field2 = [RFField fieldWithName:@"field2" title:@"Field 2"];
		   RFField *field3 = [RFField fieldWithName:@"field3" title:@"Field 3"];
		   RFField *field4 = [RFField fieldWithName:@"field4" title:@"Field 4"];
		   RFMutableFormContentProvider *contentProvider = [[RFMutableFormContentProvider alloc] init];
		   RFForm *form = [RFForm formWithFormContentProvider:contentProvider];
		   [form addFormObserver:[RFFormObserverMock new]];
		   RFContainer *container = [RFContainer container];
		   
		   [contentProvider addSectionWithElement:container];
		   [[theValue([form numberOfSections]) should] equal:theValue(0)];
		   
		   [container addElement:field1];
		   [[theValue([form numberOfSections]) should] equal:theValue(1)];
		   [[theValue([form numberOfFieldsInSection:0]) should] equal:theValue(1)];
		   
		   [container addElement:field2];
		   [[theValue([form numberOfFieldsInSection:0]) should] equal:theValue(2)];
		   
		   [container removeElement:field1];
		   [[theValue([form numberOfFieldsInSection:0]) should] equal:theValue(1)];
		   
		   [container addElement:field3];
		   [[theValue([form numberOfFieldsInSection:0]) should] equal:theValue(2)];
		   
		   [container addElement:field4];
		   [[theValue([form numberOfFieldsInSection:0]) should] equal:theValue(3)];
		   
		   [form title];
       });
	   
	   it(@"should notify observers when changed", ^{
		
	   });
   });
});
SPEC_END

@implementation RFFormObserverMock
- (void)formWillChangeContent:(RFForm *)form
{
	
}

- (void)form:(RFForm *)form didInsertSectionAtIndex:(NSUInteger)index
{
	NSLog(@"Inserted section at index: %d", index);
}

- (void)form:(RFForm *)form didRemoveSectionAtIndex:(NSUInteger)index
{
	NSLog(@"Removed section at index: %d", index);
}

- (void)form:(RFForm *)form didInsertField:(RFField *)field atIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Inserted field %@ at row %d in section %d", field, indexPath.row, indexPath.section);
}

- (void)form:(RFForm *)form didRemoveField:(RFField *)field atIndexPath:(NSIndexPath *)indexPath
{
	NSLog(@"Removed field %@ at row %d in section %d", field, indexPath.row, indexPath.section);
}

- (void)formDidChangeContent:(RFForm *)form
{
	NSLog(@"------------------------------------------------------");
}
@end