//
//  RFTextFormField.m
//  Form
//
//  Created by Denis Mikhaylov on 17.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFTextField.h"

#import "RFTextInputController.h"
#import "RFValidator.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>


@interface RFDefaultTextInputController : NSObject <RFTextInputController>
+ (instancetype)sharedInstance;
@end

@interface RFTextField ()
@property (nonatomic, strong, readonly) RACSignal *validate;
@end

@implementation RFTextField
@synthesize validate = _validate;
- (id)initWithName:(NSString *)name
{
    self = [super initWithName:name];
    if (self) {
        _textInputController = [RFDefaultTextInputController sharedInstance];
        
        _validate = [RACSignal
                     if:[RACObserve(self, validator)
                         map:^(id <RFValidator> validator) {
                             return validator ? @YES : @NO;
                         }]
                     then:[[RACObserve(self, value)
                            map:^(id value) {
                                return [self.validator validateValue:self.value];
                            }] switchToLatest]
                     else:[RACSignal return:@YES]];
        
    }
    return self;
}

- (void)setTextInputController:(id<RFTextInputController>)textInputController
{
    _textInputController = textInputController ?: [RFDefaultTextInputController sharedInstance];
}

- (UIKeyboardType)keyboardType
{
    if ([_textInputController respondsToSelector:@selector(keyboardType)]) {
        return [_textInputController keyboardType];
    }
    return _keyboardType;
}
@end

@implementation RFDefaultTextInputController
+ (instancetype)sharedInstance
{
    static RFDefaultTextInputController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSString *)stringByReplacingSelectedRange:(inout NSRange *)range ofString:(NSString *)string withString:(NSString *)replacement
{
    NSRange sourceRange = *range;
    NSString *result = [string stringByReplacingCharactersInRange:sourceRange withString:replacement];
    NSRange resultRange = NSMakeRange(sourceRange.location + replacement.length, 0);
    *range = resultRange;
    return result;
}
@end
