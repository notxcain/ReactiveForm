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
+ (id<RFFormElement>)mockFormElementWithSignal:(RACSignal *)signal
{
    KWMock <RFFormElement> *mock = [KWMock mockForProtocol:@protocol(RFFormElement)];
    [mock stub:@selector(visibleFields) andReturn:signal];
    return (id<RFFormElement>)mock;
}

+ (id<RFFormElement>)mockFormElementWithElements:(NSArray *)elements
{
	return [self mockFormElementWithSignal:[RACSignal return:elements]];
}
@end
