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
            __block RACSequence *elements = nil;
            [[container visibleFields] subscribeNext:^(RACSequence *x) {
                elements = x;
            }];
            
            id<RFFormElement> element1 = [KWMock mockFormElement];
            [container setFormElement:element1 forSignalValue:@1];
            
            id<RFFormElement> element2 = [KWMock mockFormElement];
            [container setFormElement:element2 forSignalValue:@2];
            
            [subject sendNext:@1];
            
            [[[elements array] should] equal:@[element1]];
            
            [subject sendNext:@2];
            
            [[[elements array] should] equal:@[element2]];
            
            [subject sendNext:nil];
            
            [[[elements array] should] beEmpty];
        });
    });
});
SPEC_END


