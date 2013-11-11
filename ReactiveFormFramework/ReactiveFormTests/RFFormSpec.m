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
#import "KWMock+RFFormElement.h"
#import "RFField.h"
#import "RFContainer.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

SPEC_BEGIN(RFFormSpec)
describe(@"Form", ^{
   context(@"when created", ^{
       RFField *mockElement = [RFField fieldWithName:@"field" title:@"title"];
	   RFField *field2 = [RFField fieldWithName:@"field2" title:@"title2"];
	   RFContainer *container = [RFContainer container];
      __block RFForm *form = [RFForm formWithBuildingBlock:^(id<RFFormContent> builder) {
          
          [builder addSectionWithElement:mockElement];
		  [builder addSectionWithElement:container];
      }];
       it(@"should return element added in builder", ^{
           [[[form fieldAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]] should] equal:mockElement];
		   [container addElement:field2];
		   [container removeElement:field2];
       });
   });
});
SPEC_END