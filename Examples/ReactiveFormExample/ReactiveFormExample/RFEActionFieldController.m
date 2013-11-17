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
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.frame = self.view.bounds;
	button.titleLabel.font = [UIFont systemFontOfSize:22.0f];
	[button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
	
	UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activity setHidesWhenStopped:YES];
	[self.view.contentView addSubview:activity];
	
	[[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
		activity.center = CGPointMake(CGRectGetMidX(self.view.contentView.bounds), CGRectGetMidY(self.view.contentView.bounds));
		[button setHidden:YES];
		[activity startAnimating];
		[[self performAction] subscribeError:^(NSError *error) {
			[button setHidden:NO];
			[activity stopAnimating];
		} completed:^{
			[button setHidden:NO];
			[activity stopAnimating];
		}];
	}];
	[button setTitle:self.field.title forState:UIControlStateNormal];
	button.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.view.userInteractionEnabled = YES;
	self.view.contentView.userInteractionEnabled = YES;
	[self.view addSubview:button];
	self.view.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (RACSignal *)performAction
{
	return [self.field performAction];
}
@end
