//
//  RFSignalFormElement.h
//  RFKit
//
//  Created by Denis Mikhaylov on 27.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFFormElement.h"
#import <ReactiveCocoa/RACSignal.h>

@class RACSignal;
@class RFRoute;

@interface RFSignalContainer : NSObject <RFFormElement>
+ (instancetype)containerWithSignal:(RACSignal *)signal routes:(NSArray *)routes;

- (id)initWithSignal:(RACSignal *)signal;
- (void)setFormElement:(id <RFFormElement>)formElement forSignalValue:(id)value;
@end

@interface NSObject (RFCase)
- (RFRoute *)then:(id <RFFormElement>)formElement;
@end

@interface RACSignal (SignalContainer)
- (RFSignalContainer *)elementWithRoutes:(NSArray *)routes;
@end