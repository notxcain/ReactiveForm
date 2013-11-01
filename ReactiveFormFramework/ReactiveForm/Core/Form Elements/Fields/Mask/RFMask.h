//
//  RFInputMask.h
//  Form
//
//  Created by Denis Mikhaylov on 20.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFTextInputController.h"

/*
 Pattern is the sequence of the following symbols:
 d - treated as any number
 w - treated as any not number
 * - treated as any symbol
 ? - makes all symbols after itself optional
 Any other symbols represent themself
 
 Example:
 Given pattern dd-d123w?*d1
 Will match 12-0123c and 12-0123c& and 12-0123c&11
 
*/

@interface RFMask : NSObject <RFTextInputController>
@property (nonatomic, copy) NSString *pattern;

+ (instancetype)maskWithPattern:(NSString *)pattern;
- (NSString *)formatString:(NSString *)string;
- (BOOL)validateString:(NSString *)string;
@end
