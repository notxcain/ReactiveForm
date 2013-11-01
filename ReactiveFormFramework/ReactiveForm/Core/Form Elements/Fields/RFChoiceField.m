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
            return [[choice formElement] visibleElements];
        }] switchToLatest] map:^(RACSequence *elements) {
            @strongify(self);
            return [RACSequence concat:@[@[self].rac_sequence, elements]];
        }];
    }
    return self;
}

- (RACSignal *)validate
{
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        if ([self.choices containsObject:self.value]) {
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
        } else {
            NSError *error = [NSError errorWithDomain:@"qw.form.error" code:1 userInfo:@{}];
            [subscriber sendError:error];
        }
        return nil;
    }];
}

- (NSString *)stringValue
{
    return [self.value title];
}
@end