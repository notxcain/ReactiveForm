//
//  RFETextFieldController.m
//  ReactiveFormExample
//
//  Created by Denis Mikhaylov on 15/11/13.
//  Copyright (c) 2013 ReactiveForm. All rights reserved.
//

#import "RFETextFieldController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveForm/ReactiveForm.h>
#import "RFETextCell.h"


@interface RFETextFieldController () <UITextFieldDelegate>
@property (nonatomic, strong, readonly) RFETextCell *view;
@end

@implementation RFETextFieldController
- (void)loadView
{
	self.view = [[RFETextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sfaf"];
	self.view.textField.delegate = self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger caretPosition = 0;
	NSString *newString = [self.field.textInputController stringByReplacingSelectedRange:range ofString:textField.text withString:string caretPosition:&caretPosition];
	textField.text = newString;
	UITextPosition *caretLocation = [textField positionFromPosition:[textField beginningOfDocument] offset:caretPosition];
	textField.selectedTextRange = [textField textRangeFromPosition:caretLocation
														toPosition:caretLocation];
	self.field.value = textField.text;
	return NO;
}

- (void)viewDidLoad
{
	RAC(self.view.textLabel, text) = RACObserve(self, field.title);
}
@end

