//
//  DMFormField.m
//  DMForms3
//
//  Created by Denis Mikhaylov on 17.03.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFField.h"
#import "RFValidator.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface RFField ()
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, strong, readonly) RACSignal *validitySignal;
@property (nonatomic, strong, readonly) RACSignal *visibleElements;
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
        _visibleElements = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [subscriber sendNext:(self ? @[self] : @[]).rac_sequence];
            [subscriber sendCompleted];
            return nil;
        }];
    }
    return self;
}

- (RACSignal *)validate
{
    RFAssertShouldBeOverriden();
    return nil;
}

- (NSString *)stringValue
{
    return [self.value description];
}
@end
