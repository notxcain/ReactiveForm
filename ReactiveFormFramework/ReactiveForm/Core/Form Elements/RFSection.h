//
//  RFSection.h
//  Form
//
//  Created by Denis Mikhaylov on 10.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RFFormElement;
@class RACSignal;
@interface RFSection : NSObject
@property (nonatomic, copy, readonly) NSOrderedSet *fields;
@property (nonatomic, copy, readonly) RACSignal *changesForFields;
+ (instancetype)sectionWithFormElement:(id <RFFormElement>)formElement;
- (id)initWithFormElement:(id <RFFormElement>)formElement;
@end