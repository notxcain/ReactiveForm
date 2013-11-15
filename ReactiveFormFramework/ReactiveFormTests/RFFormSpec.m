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

@interface RFMockFormObserver : KWMock <RFFormObserver>
@end

SPEC_BEGIN(RFFormSpec)
describe(@"Form", ^{
   context(@"when created with content provider", ^{
	   RFField *field1 = [RFField fieldWithName:@"field1" title:@"Field 1"];
	   RFField *field2 = [RFField fieldWithName:@"field2" title:@"Field 2"];
	   RFField *field3 = [RFField fieldWithName:@"field3" title:@"Field 3"];
	   RFField *field4 = [RFField fieldWithName:@"field4" title:@"Field 4"];
	   __block RFContainer *container = nil;
	   __block RFForm *form = nil;
	   __block RFMutableFormContentProvider *contentProvider = nil;
	   beforeEach(^{
		   contentProvider = [RFMutableFormContentProvider contentProvider];
		   form = [RFForm formWithFormContentProvider:contentProvider];
		   container = [RFContainer container];
	   });
	   
       it(@"should mutate along with the content provider", ^{
		   id section = [contentProvider addSectionWithElement:container];
		   [[theValue([form numberOfSections]) should] equal:theValue(0)];
		   [contentProvider removeSection:section];
		   
		   [container addElement:field1];
		   [contentProvider addSectionWithElement:container];
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
		   KWMock <RFFormObserver> *observer = [KWMock mockForProtocol:@protocol(RFFormObserver)];
		   [contentProvider addSectionWithElement:container];
		   [form addFormObserver:observer];
		   [[[observer should] receiveWithCount:2] formWillChangeContent:form];
		   [[[observer should] receive] form:form didInsertSectionAtIndex:0];
		   [[[observer should] receive] form:form didInsertField:field1 atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
		   [[[observer should] receive] form:form didInsertField:field2 atIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
		   [[[observer should] receiveWithCount:2] formDidChangeContent:form];
		   
		   [container addElement:field1];
		   [container addElement:field2];
		   
	   });
   });
});
SPEC_END

@implementation RFMockFormObserver

+ (id)mock
{
	return [self mockForProtocol:@protocol(RFFormObserver)];
}

//- (void)formWillChangeContent:(RFForm *)form
//{
//	
//}

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