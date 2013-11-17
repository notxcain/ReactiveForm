//
//  RFEActionFieldController.m
//  ReactiveFormExample
//
//  Created by Denis Mikhaylov on 15/11/13.
//  Copyright (c) 2013 ReactiveForm. All rights reserved.
//

#import "RFEActionFieldController.h"
#import <ReactiveForm/ReactiveForm.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface RFEActionFieldController ()
@property (nonatomic, strong) UIButton *button;
@end

@implementation RFEActionFieldController
- (void)viewDidLoad
{
	UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	button.frame = self.view.contentView.bounds;
	[[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		[self.field performAction];
	}];
	[self.view.contentView addSubview:button];
	self.view.selectionStyle = UITableViewCellSelectionStyleNone;
	RAC(self.view.textLabel, text) = RACObserve(self, field.title);
}

- (void)performAction
{
	[self.field performAction];
}
@end
