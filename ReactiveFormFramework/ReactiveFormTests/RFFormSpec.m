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
#import "RFForm+Private.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

SPEC_BEGIN(RFFormSpec)
describe(@"Form", ^{
   context(@"when created", ^{
       it(@"should return element added in builder", ^{
		   RFField *field1 = [RFField fieldWithName:@"field1" title:@"Field 1"];
		   RFField *field2 = [RFField fieldWithName:@"field2" title:@"Field 2"];
		   RFField *field3 = [RFField fieldWithName:@"field3" title:@"Field 3"];
		   RFField *field4 = [RFField fieldWithName:@"field4" title:@"Field 4"];
       });
	   
	   it(@"should notify observers when changed", ^{
		   
	   });
   });
});
SPEC_END