//
//  DMFormField.m
//  DMForms3
//
//  Created by Denis Mikhaylov on 17.03.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFField.h"
#import "RFValidator.h"
#import "RFDefines.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface RFField ()
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, strong, readonly) RACSignal *validitySignal;
@property (nonatomic, strong, readonly) RACSignal *visibleFields;
@end

@implementation RFField
@synthesize validitySignal = _validitySignal;

#pragma mark - Value Interaction

+ (NSSet *)keyPathsForValuesAffectingValid
{
    return [NSSet setWithObject:@"value"];
}

+ (instancetype)fieldWithName:(NSString *)name title:(NSString *)title
{
    RFField *field = [[self alloc] initWithName:name];
    field.title = title;
    return field;
}

- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _required = YES;
        _name = [name copy];
        @weakify(self);
        _visibleFields = [RACSignal defer:^{
			@strongify(self);
			return [RACSignal return:@[self]];
		}];
    }
    return self;
}

- (BOOL)validate:(out NSError *__autoreleasing *)errorPtr
{
    RFAssertShouldBeOverriden();
    return NO;
}

- (NSString *)stringValue
{
    return [self.value description];
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ %p {name = %@, title = %@, value = %@}", [self class], self, self.name, self.title, self.value ];
}
@end
