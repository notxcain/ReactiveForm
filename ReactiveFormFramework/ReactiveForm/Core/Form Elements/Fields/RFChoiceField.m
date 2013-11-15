//
//  RFChoiceFormField.m
//  Form
//
//  Created by Denis Mikhaylov on 19.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFChoiceField.h"
#import "RFChoice.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "RFCollectionOperations.h"
@interface RFChoiceField ()
@end

@implementation RFChoiceField

+ (instancetype)fieldWithName:(NSString *)name title:(NSString *)title choices:(NSArray *)choices
{
    RFChoiceField *field = [self fieldWithName:name title:title];
    field.choices = choices;
    return field;
}

+ (NSSet *)keyPathsForValuesAffectingStringValue
{
	return [NSSet setWithObject:@keypath([RFChoiceField new], value)];
}

- (RACSignal *)createVisibleFieldsSignal
{
	@weakify(self);
	return [[[RACObserve(self, value) map:^(id <RFChoice> choice) {
		if (!choice) return [RACSignal return:@[]];
		NSCAssert([choice conformsToProtocol:@protocol(RFChoice)], @"Expected value to conform to RFChoice protocol, got %@ instead", choice);
		return [[choice formElement] visibleFields];
	}] switchToLatest] map:^(NSArray *fields) {
		@strongify(self);
		return [@[self] arrayByAddingObjectsFromArray:fields];
	}];
}

- (BOOL)validate:(out NSError *__autoreleasing *)errorPtr
{
	return [self.choices containsObject:self.value];
}

- (NSString *)stringValue
{
    return [self.value title];
}
@end