//
//  RFMaskSpec.m
//  Form
//
//  Created by Denis Mikhaylov on 21.06.13.
//  Copyright 2013 Denis Mikhaylov. All rights reserved.
//

#import "Kiwi.h"
#import "RFMask.h"


SPEC_BEGIN(RFMaskSpec)
describe(@"RFMask", ^{
    
    context(@"formatting", ^{
        __block RFMask *mask = nil;
        beforeEach(^{
            mask = [RFMask maskWithPattern:@"(ddd) ddd-dd-dd"];
        });
        
        it(@"should format string", ^{
            [[[mask formatString:@"1234567890"] should] equal:@"(123) 456-78-90"];
            [[[mask formatString:@"12  $%^&34 56 7 8 90"] should] equal:@"(123) 456-78-90"];
        });
    });
    
    context(@"validating", ^{
        __block RFMask *mask = nil;
        beforeEach(^{
            mask = [RFMask maskWithPattern:@"7048ddddd?dd"];
        });
        it(@"should validate", ^{
            [[@([mask validateString:@"7048"]) should] equal:@NO];
            [[@([mask validateString:@"704812345"]) should] equal:@YES];
            [[@([mask validateString:@"7048123456"]) should] equal:@YES];
            [[@([mask validateString:@"704812345f"]) should] equal:@NO];
            [[@([mask validateString:@"70481234567"]) should] equal:@YES];
        });
    });
    
    
    context(@"input control", ^{
        __block RFMask *mask = nil;
        beforeEach(^{
            mask = [RFMask maskWithPattern:@"(ddd) ddd-dd-dd"];
        });
        
        it(@"should return correct text input state test 1", ^{
            NSRange range = NSMakeRange(3, 0);
            NSString *result = [mask stringByReplacingSelectedRange:&range ofString:@"(12" withString:@"3"];
            [[result should] equal:@"(123) "];
            [[@(range.location) should] equal:@6];
        });
        
        it(@"should return correct text input state test 2", ^{
            NSRange range = NSMakeRange(6, 0);
            NSString *result = [mask stringByReplacingSelectedRange:&range ofString:@"(123) " withString:@"4"];
            [[result should] equal:@"(123) 4"];
            [[@(range.location) should] equal:@7];
        });
        
        it(@"should return correct text input state test 3", ^{
            NSRange range = NSMakeRange(1, 1);
            NSString *result = [mask stringByReplacingSelectedRange:&range ofString:@"(123) " withString:@"4"];
            [[result should] equal:@"(423) "];
            [[@(range.location) should] equal:@2];
        });
        
        it(@"should return correct text input state test 4", ^{
            NSRange range = NSMakeRange(6, 3);
            NSString *result = [mask stringByReplacingSelectedRange:&range ofString:@"(123) 456-78-90" withString:@"(123) "];
            [[result should] equal:@"(123) 123-78-90"];
            [[@(range.location) should] equal:@10];
        });
        
        it(@"should return correct text input state test 5", ^{
            NSRange range = NSMakeRange(6, 3);
            NSString *result = [mask stringByReplacingSelectedRange:&range ofString:@"(123) 456-78-90" withString:@""];
            [[result should] equal:@"(123) 789-0"];
            [[@(range.location) should] equal:@6];
        });
        
        it(@"should return correct text input state test 6", ^{
            NSRange range = NSMakeRange(5, 1);
            NSString *result = [mask stringByReplacingSelectedRange:&range ofString:@"(123) 78" withString:@""];
            [[result should] equal:@"(127) 8"];
            [[@(range.location) should] equal:@3];
        });
        
        it(@"should return correct text input state test 7", ^{
            NSRange range = NSMakeRange(5, 1);
            NSString *result = [mask stringByReplacingSelectedRange:&range ofString:@"(123) " withString:@""];
            [[result should] equal:@"(12"];
            [[@(range.location) should] equal:@3];
        });
        
        it(@"should return correct text input state test 8", ^{
            NSRange range = NSMakeRange(1, 1);
            NSString *result = [mask stringByReplacingSelectedRange:&range ofString:@"(1" withString:@""];
            [[result should] equal:@"("];
            [[@(range.location) should] equal:@1];
        });
        
        it(@"should return correct text input state test 9", ^{
            NSRange range = NSMakeRange(0, 1);
            NSString *result = [mask stringByReplacingSelectedRange:&range ofString:@"(" withString:@""];
            [[result should] equal:@"("];
            [[@(range.location) should] equal:@1];
        });
        
        it(@"should return correct text input state test 10", ^{
            NSRange range = NSMakeRange(15, 0);
            NSString *result = [mask stringByReplacingSelectedRange:&range ofString:@"(123) 456-78-90" withString:@"1"];
            [[result should] equal:@"(123) 456-78-90"];
            [[@(range.location) should] equal:@15];
        });
        
        it(@"should return correct text input state test 11", ^{
            NSRange range = NSMakeRange(8, 3);
            NSString *result = [mask stringByReplacingSelectedRange:&range ofString:@"(123) 456-78-90" withString:@"(123)"];
            [[result should] equal:@"(123) 451-23-89"];
            [[@(range.location) should] equal:@13];
        });
        
        it(@"should return correct text input state test 12", ^{
            NSRange range = NSMakeRange(8, 3);
            NSString *result = [mask stringByReplacingSelectedRange:&range ofString:@"(123) 456-78-90" withString:@"-1-23-"];
            [[result should] equal:@"(123) 451-23-89"];
            [[@(range.location) should] equal:@13];
        });
    });
    
});
SPEC_END


