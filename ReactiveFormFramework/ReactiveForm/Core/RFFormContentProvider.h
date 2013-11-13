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
- (RACSignal *)visibleSections;
@end

@protocol RFFormElement;
@interface RFMutableFormContentProvider : RFFormContentProvider
@property (nonatomic, strong, readonly) RACSignal *visibleSections;
- (id)addSectionWithElement:(id <RFFormElement>)formElement;
- (void)removeSection:(id)section;
@end

