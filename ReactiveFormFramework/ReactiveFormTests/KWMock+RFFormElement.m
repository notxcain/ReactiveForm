//
//  KWMock+RFFormElement.m
//  RFKit
//
//  Created by Denis Mikhaylov on 11.07.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "KWMock+RFFormElement.h"
#import "RFFormElement.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@implementation KWMock (RFFormElement)
+ (id<RFFormElement>)mockFormElement
{
    KWMock *mock = [KWMock mockForProtocol:@protocol(RFFormElement)];
    [mock stub:@selector(visibleElements) andReturn:[RACSignal return:@[mock].rac_sequence]];
    return (id<RFFormElement>)mock;
}
@end
