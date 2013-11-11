//
//  RFChoice.m
//  RFKit
//
//  Created by Denis Mikhaylov on 26.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFChoice.h"

@implementation RFChoice
- (id)initWithValue:(id)value title:(NSString *)title formElement:(id<RFFormElement>)formElement
{
    self = [super init];
    if (self) {
        _value = value;
        _title = [title copy];
        _formElement = formElement;
    }
    return self;
}
@end

@implementation NSObject (RFChoice)
- (id)choiceWithTitle:(NSString *)title
{
    return [self choiceWithTitle:title formElement:nil];
}

- (id)choiceWithTitle:(NSString *)title formElement:(id<RFFormElement>)formElement
{
    return [[RFChoice alloc] initWithValue:self title:title formElement:formElement];
}
@end