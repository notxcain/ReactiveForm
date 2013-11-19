//
//  RFETextCell.m
//  ReactiveFormExample
//
//  Created by Denis Mikhaylov on 15/11/13.
//  Copyright (c) 2013 ReactiveForm. All rights reserved.
//

#import "RFETextCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation RFETextCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [[UITextField alloc] init];
		_textField.font = [UIFont systemFontOfSize:24.0f];
		self.textLabel.font = [UIFont systemFontOfSize:18.0f];
		
		[self.contentView addSubview:_textField];
		[[_textField rac_newTextChannel] subscribeNext:^(id x) {
			[_textField sizeToFit];
			[self layoutSubviews];
		}];
    }
    return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	[self.textLabel sizeToFit];
	self.textLabel.frame = CGRectMake(5.0f, 5.0f, self.textLabel.frame.size.width, self.contentView.bounds.size.height - 10.0f);
	self.textField.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame) + 5.0f, 5.0f, self.contentView.bounds.size.width - (CGRectGetMaxX(self.textLabel.frame) + 5.0f) - 5.0f, self.contentView.bounds.size.height - 10.0f);
}
@end
