//
//  RFSection.h
//  Form
//
//  Created by Denis Mikhaylov on 10.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RFFormElement;
@interface RFSection : NSObject
+ (instancetype)sectionWithFormElement:(id <RFFormElement>)formElement;
- (id)initWithFormElement:(id <RFFormElement>)formElement;
@end