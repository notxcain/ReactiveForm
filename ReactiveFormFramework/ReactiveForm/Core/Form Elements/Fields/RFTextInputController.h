//
//  RFInputController.h
//  Form
//
//  Created by Denis Mikhaylov on 19.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RFTextInputState;
@protocol RFTextInputController <NSObject>
- (NSString *)stringByReplacingSelectedRange:(inout NSRangePointer)range ofString:(NSString *)string withString:(NSString *)replacement;
@optional
- (UIKeyboardType)keyboardType;
@end