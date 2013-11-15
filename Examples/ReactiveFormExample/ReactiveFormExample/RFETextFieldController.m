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

@interface RFETextCell : UITableViewCell
@property (nonatomic, strong, readonly) UITextField *textField;
@end

@interface RFETextFieldController ()
@property (nonatomic, strong, readonly) RFETextCell *view;
@end

@implementation RFETextFieldController
- (void)loadView
{
	self.view = [[RFETextCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sfaf"];
}

- (void)viewDidLoad
{
	RAC(self.textField, value) = [self.view.textField rac_newTextChannel];
}
@end

@implementation RFETextCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [[UITextField alloc] init];
		_textField.font = [UIFont systemFontOfSize:24.0f];
		[self.contentView addSubview:_textField];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	self.textField.frame = CGRectInset(self.contentView.bounds, 5.0f, 5.0f);
}
@end
