//
//  RFActionFormField.m
//  Form
//
//  Created by Denis Mikhaylov on 17.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFActionField.h"

@interface RFActionField ()
@property (nonatomic, assign, readwrite) BOOL valid;
@end

@implementation RFActionField
- (BOOL)validate:(out NSError *__autoreleasing *)error
{
    return YES;
}

- (RACSignal *)performAction
{
    return NULL;
}
@end
