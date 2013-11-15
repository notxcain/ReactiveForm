//
//  RFSignalContainerSpec.m
//  RFKit
//
//  Created by Denis Mikhaylov on 11.07.13.
//  Copyright 2013 Denis Mikhaylov. All rights reserved.
//

#import "Kiwi.h"
#import "RFSwitch.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "KWMock+RFFormElement.h"
#import "RFField.h"
#import "RFField.h"
#import "RFContainer.h"
#import "RFCollectionOperations.h"

SPEC_BEGIN(RFSwitchSpec)
describe(@"Signal container", ^{
    __block RFSwitch *switchElement = nil;
    context(@"when created with control signal and routes", ^{
        __block RACSubject *subject = nil;
        id<RFFormElement> element1 = [RFField fieldWithName:@"f" title:@"f"];
        id<RFFormElement> element2 = [RFField fieldWithName:@"a" title:@"a"];
        NSSet *routes = [NSSet setWithArray:@[[@1 then:element1], [@2 then:element2]]];
        beforeEach(^{
            subject = [RACSubject subject];
            switchElement = [[RFSwitch alloc] initWithControlSignal:subject routes:routes];
        });
        
        it(@"should route to the visibleElements signal of element based in control signal next value", ^{
            __block NSArray *fields = nil;
            [[switchElement visibleFields] subscribeNext:^(NSArray *x) {
                fields = x;
            }];
            [[fields should] beEmpty];
            
            [subject sendNext:@1];
            
            [[fields should] equal:@[element1]];
            
            [subject sendNext:@2];
            
            [[fields should] equal:@[element2]];
            
            [subject sendNext:@1];
            
            [[fields should] equal:@[element1]];
            
            [subject sendNext:nil];
            
            [[fields should] beEmpty];
        });
    });
});
SPEC_END


