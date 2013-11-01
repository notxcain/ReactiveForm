//
//  RFValidator.h
//  Form
//
//  Created by Denis Mikhaylov on 19.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;
@protocol RFValidator <NSObject>
///Returns a signal which sends YES if validated successfully or error if failed
- (RACSignal *)validateValue:(id)value;
@end

typedef BOOL(^RFValidationBlock)(id value, NSError *__autoreleasing*error);

@interface RFValidator : NSObject <RFValidator>
+ (instancetype)validatorWithBlock:(RFValidationBlock)block;
+ (instancetype)successfulValidator;
@end

@interface NSRegularExpression (RFValidator)
- (id <RFValidator>)validatorWithFailureError:(NSError *)failureError;
@end