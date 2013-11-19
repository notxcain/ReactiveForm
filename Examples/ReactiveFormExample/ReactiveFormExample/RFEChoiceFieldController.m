//
//  RFEChoiceFieldController.m
//  ReactiveFormExample
//
//  Created by Denis Mikhaylov on 15/11/13.
//  Copyright (c) 2013 ReactiveForm. All rights reserved.
//

#import "RFEChoiceFieldController.h"
#import "RFETextCell.h"
#import <ReactiveForm/ReactiveForm.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RFESimpleSelectionInputViewController.h"

@interface RFEChoiceFieldController () <RFESimpleSelectionInputViewControllerDelegate>
@property (nonatomic, strong, readonly) RFETextCell *view;
@property (nonatomic, strong, readonly) RFESimpleSelectionInputViewController *inputViewController;
@end

@implementation RFEChoiceFieldController

- (id)init
{
    self = [super init];
    if (self) {
        _inputViewController = [[RFESimpleSelectionInputViewController alloc] init];
		_inputViewController.delegate = self;
		RAC(_inputViewController, options) = RACObserve(self, field.choices);
    }
    return self;
}

- (void)loadView
{
	self.view = [[RFETextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fdsfd"];
}

- (void)viewDidLoad
{
	self.view.selectionStyle = UITableViewCellSelectionStyleNone;
	RAC(self.view.textLabel, text) = RACObserve(self.field, title);
	[RACObserve(self.field, stringValue) subscribe:self.view.textField.rac_newTextChannel];

	
	self.view.textField.inputView = self.inputViewController.view;
}

- (void)selectionInputViewController:(RFESimpleSelectionInputViewController *)controller didSelectOption:(id)option
{
	self.field.value = option;
}

- (id)selectedOptionForSelectionInputViewController:(RFESimpleSelectionInputViewController *)controller
{
	return self.field.value;
}
@end
