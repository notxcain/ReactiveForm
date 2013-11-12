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
       
       context(@"signal", ^{
           
           __block id <RFFormElement> mockElement = nil;
           
           beforeEach(^{
               mockElement = [RFField fieldWithName:@"" title:@""];
           });
           
           it(@"should send signal when changed", ^{
                __block NSArray *fields = nil;
               
              [container addElement:mockElement];
               
               [[container visibleFields] subscribeNext:^(id x) {
                   fields = x;
               }];
               
               [[theValue([fields containsObject:mockElement]) should] beTrue];
           });
           
           it(@"should propagate visible elements signal", ^{
               
               RFContainer *subcontainer = [RFContainer container];
               [container addElement:subcontainer];
               
               __block NSArray *fields = nil;
               
               [[container visibleFields] subscribeNext:^(id x) {
                   fields = x;
               }];
               
               [subcontainer addElement:mockElement];
               
               [[theValue([fields containsObject:mockElement]) should] beTrue];
           });
       });
   });
});
SPEC_END


