//
//  RFForm.h
//  RFKit
//
//  Created by Denis Mikhaylov on 10.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RFFormElement;
@protocol RFFormContent;
@class RACSignal;
@class RFField;

extern NSString *const RFFormDidChangeNotification;

@protocol RFFormObserver;
@interface RFForm : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, readonly, getter = isValid) BOOL valid;

+ (instancetype)formWithBuildingBlock:(void (^)(id <RFFormContent> builder))buildingBlock;
- (id)initWithBuildingBlock:(void (^)(id <RFFormContent> builder))buildingBlock;

- (RFField *)fieldAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForField:(RFField *)field;
- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfFieldsInSection:(NSUInteger)section;

- (void)addFormObserver:(id <RFFormObserver>)observer;
- (void)removeFormObserver:(id <RFFormObserver>)observer;
@end

@protocol RFFormContent <NSObject>
- (id)addSectionWithElement:(id <RFFormElement>)formElement;
- (void)removeSection:(id)section;
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