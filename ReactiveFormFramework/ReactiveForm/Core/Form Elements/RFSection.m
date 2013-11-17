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
	
	@weakify(self);
	_currentFields = [[[[[formElement visibleFields] map:^(id value) {
			return [NSOrderedSet orderedSetWithArray:value];
		}] doNext:^(id x) {
			@strongify(self);
			self.fields = x;
		}] startWith:[NSOrderedSet orderedSet]] replayLast];
	
	return self;
}

- (NSUInteger)numberOfFields
{
	return [self.fields count];
}

- (id)fieldAtIndex:(NSUInteger)index
{
	return [self.fields objectAtIndex:index];
}

- (NSUInteger)indexOfField:(RFField *)field
{
	return [self.fields indexOfObject:field];
}

- (BOOL)isEmpty
{
	return [self.fields count] == 0;
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ %p {\nfields = %@\n}", [self class], self, [self.fields description]];
}
@end