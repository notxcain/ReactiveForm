//
//  RFSection.h
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 10.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RFFormElement;
@class RACSignal;
@class RFField;



@interface RFSection : NSObject
/// Return a signal that sends currently visible field immediately upon subscription
/// and then each time they change

@property (nonatomic, copy, readonly) RACSignal *currentFields;
@property (nonatomic, copy, readonly) NSOrderedSet *fields;

- (NSUInteger)numberOfFields;
- (RFField *)fieldAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfField:(RFField *)field;
- (BOOL)isEmpty;

+ (instancetype)sectionWithFormElement:(id <RFFormElement>)formElement;
- (id)initWithFormElement:(id <RFFormElement>)formElement;

@end