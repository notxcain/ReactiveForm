//
//  RFInputController.h
//  Form
//
//  Created by Denis Mikhaylov on 19.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RFTextInputController <NSObject>
- (NSString *)stringByReplacingSelectedRange:(NSRange)range ofString:(NSString *)string withString:(NSString *)replacement caretPosition:(out NSUInteger *)caretPosition;
@optional
- (UIKeyboardType)keyboardType;
@end