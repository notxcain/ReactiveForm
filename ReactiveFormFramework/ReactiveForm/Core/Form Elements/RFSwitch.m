//
//  RFSignalFormElement.m
//  RFKit
//
//  Created by Denis Mikhaylov on 27.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFSwitch.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface RFSwitch ()
@property (nonatomic, strong) RACSignal *visibleFields;
@end

@interface RFSignalContainerRoute : NSObject
@property (nonatomic, strong, readonly) id value;
@property (nonatomic, strong) id <RFFormElement> formElement;
+ (RFSignalContainerRoute *)routeWithSignalValue:(id)value;
- (BOOL)containsValue:(id)value;
@end

@implementation RFSwitch

+ (instancetype)switchWithControlSignal:(RACSignal *)signal routes:(NSSet *)routes
{
    RFSwitch *container = [[self alloc] initWithControlSignal:signal routes:routes];
    return container;
}

- (id)initWithControlSignal:(RACSignal *)signal routes:(NSSet *)routes
{
    self = [super init];
    if (self) {
        _visibleFields = [[[[signal distinctUntilChanged] map:^(id value) {
            for (RFSignalContainerRoute *route in routes) {
                if ([route containsValue:value]) return [route.formElement visibleFields];
            }
            return [RACSignal return:[NSArray array]];
        }] switchToLatest] startWith:[NSArray array]];
        
    }
    return self;
}
@end

@implementation RFSignalContainerRoute
+ (RFSignalContainerRoute *)routeWithSignalValue:(id)value
{
    RFSignalContainerRoute *route = [[self alloc] init];
    route->_value = value;
    return route;
}

- (BOOL)containsValue:(id)value
{
    if (self.value == nil) return (value == nil);
    if (value == nil) return (self.value == nil);
    return [self.value isEqual:value];
}
@end

@implementation NSObject (RFCase)
- (id)then:(id<RFFormElement>)formElement
{
    RFSignalContainerRoute *route = [RFSignalContainerRoute routeWithSignalValue:self];
    route.formElement = formElement;
    return route;
}
@end

@implementation RACSignal (SignalContainer)
- (RFSwitch *)switchWithRoutes:(NSSet *)routes
{
    return [RFSwitch switchWithControlSignal:self routes:routes];
}
@end
