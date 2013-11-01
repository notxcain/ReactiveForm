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

typedef NS_ENUM(NSInteger, RFFormChangeType) {
	RFFormChangeInsert = 1,
	RFFormChangeDelete = 2,
	RFFormChangeMove = 3
};

@optional
- (void)controllerWillChangeContent:(RFFormController *)controller;
- (void)controller:(RFFormController *)controller didChangeField:(RFField *)field atIndexPath:(NSIndexPath *)indexPath changeType:(RFFormChangeType)changeType newIndexPath:(NSIndexPath *)newIndexPath;
- (void)controller:(RFFormController *)controller didChangeSectionAtIndex:(NSUInteger)sectionIndex changeType:(RFFormChangeType)type;
- (void)controllerDidChangeContent:(RFFormController *)controller;
@end