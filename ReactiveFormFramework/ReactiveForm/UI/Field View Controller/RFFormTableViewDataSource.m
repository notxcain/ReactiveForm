//
//  RFFormTableViewDataSource.m
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 05/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFFormTableViewDataSource.h"
#import "RFFormPresentation.h"
#import "RFForm.h"
#import "RFFieldController.h"

@interface RFFormTableViewDataSource () <RFFormObserver, UITableViewDelegate>
@property (nonatomic, strong, readonly) RFFormPresentation *presentation;
@property (nonatomic, strong, readonly) RFForm *form;
@property (nonatomic, strong, readonly) NSCache *fieldControllerCache;
@end

@implementation RFFormTableViewDataSource
- (id)initWithForm:(RFForm *)form presentation:(RFFormPresentation *)presentation
{
    self = [super init];
    if (self) {
        _form = form;
		[self.form addFormObserver:self];
		_presentation = presentation;
		
		_fieldControllerCache = [[NSCache alloc] init];
		_fieldControllerCache.name = @"rf.fieldViewController.cache";
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.form numberOfFieldsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RFFieldController *fieldViewController = [self controllerAtIndexPath:indexPath];
	return fieldViewController.view;
}

- (RFFieldController *)controllerAtIndexPath:(NSIndexPath *)indexPath
{
	return [self fieldViewControllerForField:[self.form fieldAtIndexPath:indexPath]];
}

- (RFFieldController *)fieldViewControllerForField:(RFField *)field
{
	RFFieldController *result = [self.fieldControllerCache objectForKey:field];
	if (!result) {
		result = [self.presentation controllerForField:field];
		NSAssert(result != nil, @"Failed to create controller for field %@", field);
		[self.fieldControllerCache setObject:result forKey:field];
	}
	return result;
}

//- (void)setTableView:(UITableView *)tableView
//{
//	if (_tableView == tableView) return;
//
//	if (tableView == nil && _tableView != nil) {
//		[self.form removeFormObserver:self];
//	}
//	
//	if (_tableView == nil && tableView) {
//		[self.form addFormObserver:self];
//	}
//	
//	_tableView = tableView;
//	
//
//}

- (void)formWillChangeContent:(RFForm *)form
{
	[self.tableView beginUpdates];
}

- (void)form:(RFForm *)form didInsertSectionAtIndex:(NSUInteger)index
{
	[self.tableView insertSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)form:(RFForm *)form didRemoveSectionAtIndex:(NSUInteger)index
{
	[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)form:(RFForm *)form didInsertField:(RFField *)field atIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)form:(RFForm *)form didRemoveField:(RFField *)field atIndexPath:(NSIndexPath *)indexPath
{
	[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)formDidChangeContent:(RFForm *)form
{
	[self.tableView endUpdates];
}
@end
