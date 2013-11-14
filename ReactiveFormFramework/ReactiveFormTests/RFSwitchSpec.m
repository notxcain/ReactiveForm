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

SPEC_BEGIN(RFSwitchSpec)
describe(@"Signal container", ^{
    __block RFSwitch *switchElement = nil;
    context(@"when created with signal", ^{
        __block RACSubject *subject = nil;
        
        beforeEach(^{
            subject = [RACSubject subject];
            switchElement = [RFSwitch containerWithSignal:subject routes:nil];
        });
        
        it(@"should route to the visibleElements signal of element based in signal", ^{
            __block NSArray *fields = nil;
            [[switchElement visibleFields] subscribeNext:^(NSArray *x) {
                fields = x;
            }];
            
            id<RFFormElement> element1 = [RFField fieldWithName:@"f" title:@"f"];
            [switchElement setFormElement:element1 forSignalValue:@1];
            
            id<RFFormElement> element2 = [RFField fieldWithName:@"a" title:@"a"];
            [switchElement setFormElement:element2 forSignalValue:@2];
            
            [subject sendNext:@1];
            
            [[fields should] equal:@[element1]];
            
            [subject sendNext:@2];
            
            [[fields should] equal:@[element2]];
            
            [subject sendNext:nil];
            
            [[fields should] beEmpty];
        });
    });
});
SPEC_END


