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
	[[self.view.textField rac_newTextChannel] subscribeNext:^(id x) {
		self.textField.value = x;
	}];
	RAC(self.view.textLabel, text) = RACObserve(self.textField, title);
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
	self.textLabel.frame = CGRectMake(5.0f, 5.0f, 50.0f, self.contentView.bounds.size.height - 10.0f);
	self.textField.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame) + 5.0f, 5.0f, self.contentView.bounds.size.width - (CGRectGetMaxX(self.textLabel.frame) + 5.0f) - 5.0f, self.contentView.bounds.size.height - 10.0f);
}
@end
