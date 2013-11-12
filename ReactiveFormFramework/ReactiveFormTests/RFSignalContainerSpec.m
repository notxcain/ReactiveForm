//
//  RFSignalContainerSpec.m
//  RFKit
//
//  Created by Denis Mikhaylov on 11.07.13.
//  Copyright 2013 Denis Mikhaylov. All rights reserved.
//

#import "Kiwi.h"
#import "RFSignalContainer.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "KWMock+RFFormElement.h"
#import "RFField.h"

SPEC_BEGIN(RFSignalContainerSpec)
describe(@"Signal container", ^{
    __block RFSignalContainer *container = nil;
    context(@"when created with signal", ^{
        __block RACSubject *subject = nil;
        
        beforeEach(^{
            subject = [RACSubject subject];
            container = [RFSignalContainer containerWithSignal:subject routes:nil];
        });
        
        it(@"should route to the visibleElements signal of element based in signal", ^{
            __block NSArray *fields = nil;
            [[container visibleFields] subscribeNext:^(NSArray *x) {
                fields = x;
            }];
            
            id<RFFormElement> element1 = [RFField fieldWithName:@"f" title:@"f"];
            [container setFormElement:element1 forSignalValue:@1];
            
            id<RFFormElement> element2 = [RFField fieldWithName:@"a" title:@"a"];
            [container setFormElement:element2 forSignalValue:@2];
            
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


