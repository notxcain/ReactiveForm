//
//  RFValidator.m
//  Form
//
//  Created by Denis Mikhaylov on 19.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFValidator.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RFBlockValidator : RFValidator
@property (nonatomic, copy, readonly) RFValidationBlock block;
- (id)initWithBlock:(RFValidationBlock)block;
@end

@implementation RFBlockValidator
- (id)initWithBlock:(RFValidationBlock)block
{
    NSParameterAssert(block != nil);
    self = [super init];
    if (self) {
        _block = [block copy];
    }
    return self;
}

- (RACSignal *)validateValue:(id)value
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error = nil;
        BOOL result = self.block(value, &error);
        if (result) {
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
        } else {
            [subscriber sendError:error];
        }
        return nil;
    }];
}
@end

@implementation NSRegularExpression (RFValidator)

- (id<RFValidator>)validatorWithFailureError:(NSError *)failureError
{
    return [RFValidator validatorWithBlock:^BOOL(id value, NSError *__autoreleasing *error) {
        NSCParameterAssert(value == nil || [value isKindOfClass:[NSString class]]);
        
        if (value && [self numberOfMatchesInString:value options:NSMatchingReportCompletion range:NSMakeRange(0, [value length])]) return YES;
        
        if (error) {
            *error = failureError;
        }
        return NO;
    }];
}
@end


@implementation RFValidator

+ (instancetype)successfulValidator
{
    return [self validatorWithBlock:^BOOL(id value, NSError *__autoreleasing *error) {
        return YES;
    }];
}

+ (instancetype)validatorWithBlock:(RFValidationBlock)block
{
    if (!block) return [self successfulValidator];
    
    return [[RFBlockValidator alloc] initWithBlock:block];
}

- (RACSignal *)validateValue:(id)value
{
    RFAssertShouldBeOverriden();
    return NO;
}
@end