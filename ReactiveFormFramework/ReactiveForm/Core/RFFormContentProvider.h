//
//  RFFormContentProvider.h
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 13/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RACSignal;
@interface RFFormContentProvider : NSObject
+ (instancetype)contentProvider;

/// Subclasses should override this methods and
/// return a signal sending NSOrderedSet of RFSection.
/// The semantics of this signal should be similar to RACObserve(obj, property) i.e. it should send current value immediatly to each subscriber.
- (RACSignal *)visibleSections;
@end

@protocol RFFormElement;
@interface RFMutableFormContentProvider : RFFormContentProvider
@property (nonatomic, strong, readonly) RACSignal *visibleSections;

- (id)addSectionWithElement:(id <RFFormElement>)formElement;
- (void)removeSection:(id)section;
@end

