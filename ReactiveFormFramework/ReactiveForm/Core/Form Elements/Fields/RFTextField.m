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
@end

@implementation RFTextField
- (id)initWithName:(NSString *)name
{
    self = [super initWithName:name];
    if (self) {
        _textInputController = [RFDefaultTextInputController sharedInstance];
    }
    return self;
}

- (BOOL)validate:(out NSError *__autoreleasing *)errorPtr
{
    return [self.validator validateValue:self.value error:errorPtr];
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
