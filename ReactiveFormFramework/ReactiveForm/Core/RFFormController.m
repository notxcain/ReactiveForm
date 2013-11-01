//
//  RFFormController.m
//  RFKit
//
//  Created by Denis Mikhaylov on 29/07/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFFormController.h"
#import <CoreData/CoreData.h>
#import "RFForm+Private.h"
#import "RFBackingForm.h"
#import "RFBackingField.h"

@interface RFFormController () <NSFetchedResultsControllerDelegate>
{
    struct {
        BOOL willChangeContent;
        BOOL didChangeField;
        BOOL didChangeSection;
        BOOL didChangeContent;
    } _delegateRespondsTo;
}
@property (nonatomic, strong, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, weak) RFBackingForm *backingForm;
@end

@implementation RFFormController
@synthesize fetchedResultsController = _fetchedResultsController;

- (id)initWithForm:(RFForm *)form
{
    self = [super init];
    if (self) {
        _form = form;
        _backingForm = _form.backingForm;
    }
    return self;
}

- (NSUInteger)numberOfSections
{
    return [[self.fetchedResultsController sections] count];
}

- (NSUInteger)numberOfFieldsInSection:(NSUInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (RFField *)fieldAtIndexPath:(NSIndexPath *)indexPath
{
    return [[self.fetchedResultsController objectAtIndexPath:indexPath] field];
}

- (NSIndexPath *)indexPathForField:(id)field
{
    return [self.fetchedResultsController indexPathForObject:[field backingObjectInContext:self.backingForm.managedObjectContext]];
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
    _delegateRespondsTo.didChangeField = [_delegate respondsToSelector:@selector(controller:didChangeField:atIndexPath:changeType:newIndexPath:)];
    _delegateRespondsTo.didChangeSection = [_delegate respondsToSelector:@selector(controller:didChangeSectionAtIndex:changeType:)];
    _delegateRespondsTo.didChangeContent = [_delegate respondsToSelector:@selector(controllerDidChangeContent:)];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (_delegateRespondsTo.willChangeContent) {
        [self.delegate controllerWillChangeContent:self];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(RFBackingField *)backingField atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (type != NSFetchedResultsChangeUpdate && _delegateRespondsTo.didChangeField) {
        [self.delegate controller:self didChangeField:backingField.field atIndexPath:indexPath changeType:type newIndexPath:newIndexPath];
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    if (_delegateRespondsTo.didChangeSection) {
        [self.delegate controller:self didChangeSectionAtIndex:sectionIndex changeType:type];
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (_delegateRespondsTo.didChangeContent) {
        [self.delegate controllerDidChangeContent:self];
    }
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) return _fetchedResultsController;
    
    _fetchedResultsController = [self.backingForm fieldsController];
    [_fetchedResultsController setDelegate:self];
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:nil]) {
        NSLog(@"Form fetch error: %@", [error localizedDescription]);
    }

    
    return _fetchedResultsController;
}
@end
