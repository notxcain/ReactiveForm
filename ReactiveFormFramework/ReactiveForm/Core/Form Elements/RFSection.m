//
//  RFSection.m
//  Form
//
//  Created by Denis Mikhaylov on 10.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFSection.h"
#import "RFSection+Private.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>


@interface RFSection ()
@property (nonatomic, strong, readonly) RACSignal *visibleElements;
@end

@implementation RFSection
+ (instancetype)sectionWithFormElement:(id <RFFormElement>)formElement
{
    return [[self alloc] initWithFormElement:formElement];
}

- (id)initWithFormElement:(id<RFFormElement>)formElement
{
    if (!(self = [super init])) return nil;
    
    @weakify(self);
    _visibleElements = [[formElement visibleElements] map:^(RACSequence *elements) {
        @strongify(self);
        return self ? [@[self].rac_sequence concat:elements] : [RACSequence empty];
    }];
    
    return self;
}
@end