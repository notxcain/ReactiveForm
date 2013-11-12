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
@property (nonatomic, strong, readonly) RACSignal *visibleElements;
@end

@implementation RFChoiceField

+ (instancetype)fieldWithName:(NSString *)name title:(NSString *)title choices:(NSArray *)choices
{
    RFChoiceField *field = [self fieldWithName:name title:title];
    field.choices = choices;
    return field;
}

- (id)initWithName:(NSString *)name
{
    self = [super initWithName:name];
    if (self) {
        @weakify(self);
        _visibleElements = [[[RACObserve(self, value) map:^(id <RFChoice> choice) {
            NSCAssert([choice conformsToProtocol:@protocol(RFChoice)], @"Expected value to conform to RFChoice protocol, got %@ instead", choice);
            return [[choice formElement] visibleFields];
        }] switchToLatest] map:^(NSArray *fields) {
            @strongify(self);
            return [@[self] arrayByAddingObjectsFromArray:fields];
        }];
    }
    return self;
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