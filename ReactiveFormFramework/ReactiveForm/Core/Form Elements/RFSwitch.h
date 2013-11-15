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
@interface RFSwitch : NSObject <RFFormElement>
+ (instancetype)switchWithControlSignal:(RACSignal *)signal routes:(NSSet *)routes;
- (id)initWithControlSignal:(RACSignal *)signal routes:(NSSet *)routes;
@end

@interface NSObject (RFCase)
- (RFRoute *)then:(id <RFFormElement>)formElement;
@end

@interface RACSignal (SignalContainer)
- (RFSwitch *)switchWithRoutes:(NSArray *)routes;
@end