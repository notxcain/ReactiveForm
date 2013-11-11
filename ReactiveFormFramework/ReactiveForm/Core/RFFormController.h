//
//  RFFormController.h
//  RFKit
//
//  Created by Denis Mikhaylov on 29/07/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RFForm;
@protocol RFFormControllerDelegate;
@class RFField;
@interface RFFormController : NSObject
@property (nonatomic, weak) id <RFFormControllerDelegate> delegate;
@property (nonatomic, strong, readonly) RFForm *form;
- (instancetype)initWithForm:(RFForm *)form;

- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfFieldsInSection:(NSUInteger)section;

- (RFField *)fieldAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForField:(RFField *)field;
- (RFField *)fieldBeforeField:(RFField *)field;
- (RFField *)fieldAfterField:(RFField *)field;
@end

@protocol RFFormControllerDelegate <NSObject>
@optional
- (void)controllerWillChangeContent:(RFFormController *)controller;
- (void)controller:(RFFormController *)controller didInsertField:(RFField *)field atIndexPath:(NSIndexPath *)indexPath;
- (void)controller:(RFFormController *)controller didRemoveField:(RFField *)field atIndexPath:(NSIndexPath *)indexPath;
- (void)controller:(RFFormController *)controller didInsertSectionAtIndex:(NSUInteger)index;
- (void)controller:(RFFormController *)controller didRemoveSectionAtIndex:(NSUInteger)index;
- (void)controllerDidChangeContent:(RFFormController *)controller;
@end