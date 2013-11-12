//
//  RFSection.m
//  Form
//
//  Created by Denis Mikhaylov on 10.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFSection.h"
#import "RFFormElement.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>


@interface RFSection ()
@property (nonatomic, strong, readonly) RACSignal *visibleElements;
@property (nonatomic, copy, readwrite) NSOrderedSet *fields;
@end

@implementation RFSection
+ (instancetype)sectionWithFormElement:(id <RFFormElement>)formElement
{
    return [[self alloc] initWithFormElement:formElement];
}

- (id)initWithFormElement:(id<RFFormElement>)formElement
{
    if (!(self = [super init])) return nil;
	
	RACSignal *signalOfFields = [[formElement visibleElements] map:^(RACSequence *value) {
        return [NSOrderedSet orderedSetWithArray:value.array];
    }];
	
    RAC(self, fields) = [signalOfFields startWith:[NSOrderedSet orderedSet]];
	
	_signalOfChangesForFields = [signalOfFields combinePreviousWithStart:[NSOrderedSet orderedSet] reduce:^id(id previous, id current) {
		return RACTuplePack(previous, current);
	}];
	return self;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ %p {\nfields = %@\n}", [self class], self, [self.fields description]];
}
@end