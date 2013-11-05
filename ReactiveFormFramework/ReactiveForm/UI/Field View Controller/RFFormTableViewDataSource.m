//
//  RFFormTableViewDataSource.m
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 05/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFFormTableViewDataSource.h"
#import "RFFormController.h"
#import "RFFieldViewController.h"
#import "RFFormPresentation.h"

@interface RFFormTableViewDataSource () <RFFormControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong, readonly) RFFormPresentation *presentation;
@property (nonatomic, strong, readonly) RFForm *form;
@property (nonatomic, strong, readonly) RFFormController *formController;
@property (nonatomic, strong, readonly) NSCache *fieldControllerCache;
@end

@implementation RFFormTableViewDataSource
@synthesize formController = _formController, formView = _formView;

- (id)initWithForm:(RFForm *)form presentation:(RFFormPresentation *)presentation
{
    self = [super init];
    if (self) {
        _form = form;
		_presentation = presentation;
		_fieldControllerCache = [[NSCache alloc] init];
		_fieldControllerCache.name = @"rf.fieldViewController.cache";
    }
    return self;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	RFFieldController *fieldViewController = [self controllerAtIndexPath:indexPath];
	return fieldViewController.view;
}

- (RFFieldController *)controllerAtIndexPath:(NSIndexPath *)indexPath
{
	return [self fieldViewControllerForField:[self.formController fieldAtIndexPath:indexPath]];
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

- (RFFormController *)formController
{
	if (_formController) return _formController;
	
	_formController = [[RFFormController alloc] initWithForm:self.form];
	_formController.delegate = self;
	
	return _formController;
}

- (UITableView *)formView
{
	if (_formView) return _formView;
	
	_formView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
	_formView.dataSource = self;
	
	return _formView;
}
@end
