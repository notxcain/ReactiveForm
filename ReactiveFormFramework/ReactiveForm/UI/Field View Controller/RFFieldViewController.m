//
//  RFFieldController.m
//  RFKit
//
//  Created by Denis Mikhaylov on 06/08/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFFieldViewController.h"

@interface RFFieldViewController ()

@end

@implementation RFFieldViewController
@synthesize view = _view;
- (UITableViewCell *)view
{
	if (_view) return _view;
	
	[self loadView];
	
	return _view;
}

- (BOOL)isViewLoaded
{
	return (_view != nil);
}

- (void)viewDidLoad
{
	
}

- (void)loadView
{
	self.view = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([self class])];
}
@end
