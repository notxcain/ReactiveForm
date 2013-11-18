//
//  RFForm.h
//  RFKit
//
//  Created by Denis Mikhaylov on 10.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RFField;
@protocol RFFormObserver;
@class RFFormContentProvider;

@interface RFForm : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, readonly, getter = isValid) BOOL valid;

+ (instancetype)formWithContentProvider:(RFFormContentProvider *)contentProvider;
- (id)initWithContentProvider:(RFFormContentProvider *)contentProvider;

- (RFField *)fieldAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForField:(RFField *)field;
- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfFieldsInSection:(NSUInteger)section;
- (RFField *)fieldBeforeField:(RFField *)field;
- (RFField *)fieldAfterField:(RFField *)field;
@end

@interface RFForm (Observation)
- (void)addFormObserver:(id <RFFormObserver>)observer;
- (void)removeFormObserver:(id <RFFormObserver>)observer;
@end

@protocol RFFormObserver <NSObject>
@optional
- (void)formWillChangeContent:(RFForm *)form;
- (void)form:(RFForm *)form didInsertField:(RFField *)field atIndexPath:(NSIndexPath *)indexPath;
- (void)form:(RFForm *)form didRemoveField:(RFField *)field atIndexPath:(NSIndexPath *)indexPath;
- (void)form:(RFForm *)form didInsertSectionAtIndex:(NSUInteger)index;
- (void)form:(RFForm *)form didRemoveSectionAtIndex:(NSUInteger)index;
- (void)formDidChangeContent:(RFForm *)form;
@end