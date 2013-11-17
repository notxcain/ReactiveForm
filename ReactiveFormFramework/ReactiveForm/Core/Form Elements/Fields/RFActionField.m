//
//  RFActionFormField.m
//  Form
//
//  Created by Denis Mikhaylov on 17.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFActionField.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface RFActionField ()
@property (nonatomic, assign, readwrite) BOOL valid;
@property (nonatomic, strong) RACCommand *command;
@property (nonatomic, copy) RFActionFieldCommandValueBlock commandValueBlock;
@end

@implementation RFActionField
- (BOOL)validate:(out NSError *__autoreleasing *)error
{
	
    return self.valid;
}

- (void)setCommand:(RACCommand *)command valueBlock:(RFActionFieldCommandValueBlock)valueBlock
{
	self.command = command;
	self.commandValueBlock = valueBlock;
	RAC(self, value) = [[[[command executionSignals] switchToLatest] mapReplace:@YES] catch:^(NSError *error) {
		return [RACSignal return:@NO];
	}];
}

- (RACSignal *)performAction
{
    return [[self.command execute:self.commandValueBlock()] ignoreValues];
}
@end
