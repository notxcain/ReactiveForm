//
//  RFSectionSpec.m
//  RFKit
//
//  Created by Denis Mikhaylov on 10.07.13.
//  Copyright 2013 Denis Mikhaylov. All rights reserved.
//

#import "Kiwi.h"
#import "RFSection.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "KWMock+RFFormElement.h"

SPEC_BEGIN(RFSectionSpec)
describe(@"RFSection", ^{
    __block RFSection *section = nil;
    __block id <RFFormElement> mockElement = nil;
    beforeEach(^{
        mockElement = [KWMock mockFormElement];
        section = [RFSection sectionWithFormElement:mockElement];
    });
    context(@"signal", ^{
        
        it(@"should add itself to the head of the sent sequence", ^{
            __block RACSequence *visibleElements = nil;
//            [[section visibleElements] subscribeNext:^(id x) {
//                visibleElements = x;
//            }];
//            [[[visibleElements array] should] equal:@[mockElement]];
        });
    });
});
SPEC_END


