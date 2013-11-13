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
	
	_contentSignal = [[[formElement visibleFields] distinctUntilChanged] map:^(NSArray *fields) {
        return [NSOrderedSet orderedSetWithArray:fields];
    }];
	
    RAC(self, fields) = _contentSignal;
	
	_changesOfFields = [_contentSignal combinePreviousWithStart:[NSOrderedSet orderedSet] reduce:^(id previous, id current) {
		return RACTuplePack(previous, current);
	}];
	return self;
}

- (BOOL)isEmpty
{
	return [self.fields count] == 0;
}

- (NSOrderedSet *)items
{
	return self.fields;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ %p {\nfields = %@\n}", [self class], self, [self.fields description]];
}
@end