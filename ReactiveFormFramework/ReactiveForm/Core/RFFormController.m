//
//  RFFormController.m
//  RFKit
//
//  Created by Denis Mikhaylov on 29/07/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFFormController.h"
#import "RFForm+Private.h"

@interface RFFormController () {
    struct {
        BOOL willChangeContent;
        BOOL didInsertField;
		BOOL didRemoveField;
        BOOL didInsertSection;
        BOOL didRemoveSection;
		BOOL didChangeContent;
    } _delegateRespondsTo;
}

@end

@implementation RFFormController

- (id)initWithForm:(RFForm *)form
{
    self = [super init];
    if (self) {
        _form = form;
    }
    return self;
}

- (NSUInteger)numberOfSections
{
    return [self.form numberOfSections];
}

- (NSUInteger)numberOfFieldsInSection:(NSUInteger)section
{
    return [self.form numberOfFieldsInSection:section];
}

- (RFField *)fieldAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.form fieldAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForField:(id)field
{
    return [self.form indexPathForField:field];
}

- (RFField *)fieldBeforeField:(RFField *)field
{
    return [self fieldAtIndexPath:[self indexPathBeforeIndexPath:[self indexPathForField:field]]];;
}

- (RFField *)fieldAfterField:(RFField *)field
{
    return [self fieldAtIndexPath:[self indexPathAfterIndexPath:[self indexPathForField:field]]];
}

- (NSIndexPath *)indexPathBeforeIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        return [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    } else if (indexPath.section > 0) {
        NSUInteger previousSection = indexPath.section - 1;
        return [NSIndexPath indexPathForRow:[self numberOfFieldsInSection:previousSection] - 1 inSection:previousSection];
    }
    return nil;
}

- (NSIndexPath *)indexPathAfterIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row + 1 < [self numberOfFieldsInSection:indexPath.section]) {
        return [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    } else if (indexPath.section + 1 < [self numberOfSections]) {
        return [NSIndexPath indexPathForRow:0 inSection:indexPath.section + 1];
    }
    return nil;
}

- (void)setDelegate:(id<RFFormControllerDelegate>)delegate
{
    _delegate = delegate;
    _delegateRespondsTo.willChangeContent = [_delegate respondsToSelector:@selector(controllerWillChangeContent:)];
    _delegateRespondsTo.didInsertField = [_delegate respondsToSelector:@selector(controller:didInsertField:atIndexPath:)];
	_delegateRespondsTo.didRemoveField = [_delegate respondsToSelector:@selector(controller:didRemoveField:atIndexPath:)];
    _delegateRespondsTo.didInsertSection = [_delegate respondsToSelector:@selector(controller:didInsertSectionAtIndex:)];
	_delegateRespondsTo.didRemoveSection = [_delegate respondsToSelector:@selector(controller:didRemoveSectionAtIndex:)];
    _delegateRespondsTo.didChangeContent = [_delegate respondsToSelector:@selector(controllerDidChangeContent:)];
}


@end
