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
               mockElement = [KWMock mockFormElement];
           });
           
           it(@"should send signal when changed", ^{
                __block RACSequence *elements = nil;
               
              [container addElement:mockElement];
               
               [[container visibleFields] subscribeNext:^(id x) {
                   elements = x;
               }];
               
               [[theValue([[elements array] containsObject:mockElement]) should] beTrue];
           });
           
           it(@"should propagate visible elements signal", ^{
               
               RFContainer *subcontainer = [RFContainer container];
               [container addElement:subcontainer];
               
               __block RACSequence *elements = nil;
               
               [[container visibleFields] subscribeNext:^(id x) {
                   elements = x;
               }];
               
               [subcontainer addElement:mockElement];
               
               [[theValue([[elements array] containsObject:mockElement]) should] beTrue];
           });
       });
   });
});
SPEC_END


