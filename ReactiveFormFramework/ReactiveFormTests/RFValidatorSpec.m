//
//  RFValidatorSpec.m
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 01/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Kiwi/Kiwi.h>
#import "RFValidator.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

SPEC_BEGIN(RFValidatorSpec)
describe(@"Validator", ^{
	context(@"when created with block", ^{
		it(@"should call this block for any value passed to validator and return result of block execution and error passed by reference", ^{
			__block BOOL blockHasBeenCalled = NO;
			__block id passedValue = nil;
			RFValidator *validator = [RFValidator validatorWithBlock:^BOOL(id value, NSError *__autoreleasing *error) {
				blockHasBeenCalled = YES;
				passedValue = value;
				*error = [NSError errorWithDomain:@"rf.test" code:1 userInfo:nil];
				return NO;
			}];
			
			NSError *error = nil;
			BOOL result = [validator validateValue:@1 error:&error];
			[[passedValue should] equal:@1];
			[[theValue(blockHasBeenCalled) should] equal:theValue(YES)];
			[[theValue(result) should] equal:theValue(NO)];
			[[theValue(error.code) should] equal:theValue(1)];
		});
	});
	
	context(@"when created as successfull validator", ^{
		RFValidator *successfulValidator = [RFValidator successfulValidator];
		it(@"should return YES and output no error for any value", ^{
			NSError *error = nil;
			BOOL result = [successfulValidator validateValue:[KWAny any] error:&error];
			[[theValue(result) should] equal:theValue(YES)];
			[[error should] beNil];
		});
	});
});
SPEC_END