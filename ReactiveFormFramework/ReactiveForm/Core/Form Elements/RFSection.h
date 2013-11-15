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
@interface RFSection : NSObject

/// Returns a set containing currently visible fields provided by formElement passed during initialization;
@property (nonatomic, copy, readonly) NSOrderedSet *fields;

/// Returns a signal that sends tuples of previous and current value of fields;
/// Exists for the optimization sake
@property (nonatomic, copy, readonly) RACSignal *currentFields;

+ (instancetype)sectionWithFormElement:(id <RFFormElement>)formElement;
- (id)initWithFormElement:(id <RFFormElement>)formElement;

- (BOOL)isEmpty;
@end