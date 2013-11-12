//
//  RFSignalFormElement.m
//  RFKit
//
//  Created by Denis Mikhaylov on 27.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFSignalContainer.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>

@interface RFSignalContainer ()
@property (nonatomic, strong) id <RFFormElement> activeFormElement;
@property (nonatomic, strong) RACSignal *signal;
@property (nonatomic, strong) id lastSignalValue;
@property (nonatomic, strong, readonly) NSMutableSet *routes;
@property (nonatomic, strong) RACSignal *visibleFields;
@end

@interface RFSignalContainerRoute : NSObject
@property (nonatomic, strong, readonly) id value;
@property (nonatomic, strong) id <RFFormElement> formElement;
+ (RFSignalContainerRoute *)routeWithSignalValue:(id)value;
- (BOOL)containsValue:(id)value;
@end

@implementation RFSignalContainer

+ (instancetype)containerWithSignal:(RACSignal *)signal routes:(NSArray *)cases
{
    RFSignalContainer *container = [[self alloc] initWithSignal:signal];
    [container addRoutesFromArray:cases];
    return container;
}

- (id)initWithSignal:(RACSignal *)signal
{
    self = [super init];
    if (self) {
        _signal = [signal distinctUntilChanged];
        _routes = [NSMutableSet set];
        
        @weakify(self);
        _visibleFields = [[[[[RACSignal combineLatest:@[_signal, RACObserve(self, routes)] reduce:^(id value, id _) {
            @strongify(self);
            return [self formElementForSignalValue:value];
        }] distinctUntilChanged] map:^(id <RFFormElement> formElement) {
            return formElement ? [formElement visibleFields] : [RACSignal return:[RACSequence empty]];
        }] switchToLatest] startWith:[RACSequence empty]];
        
    }
    return self;
}

- (void)setFormElement:(id<RFFormElement>)formElement forSignalValue:(id)value
{
    [self changeRoutesWithBlock:^(NSMutableSet *routes) {
        RFSignalContainerRoute *route = [self routeForSignalValue:value];
        if (!route) {
            route = [RFSignalContainerRoute routeWithSignalValue:value];
            [routes addObject:route];
        }
        route.formElement = formElement;
    }];
}

- (void)addRoutesFromArray:(NSArray *)array
{
    [self changeRoutesWithBlock:^(NSMutableSet *routes) {
        [self.routes addObjectsFromArray:array];
    }];
}

- (void)changeRoutesWithBlock:(void (^)(NSMutableSet *routes))block
{
    @synchronized(self) {
        [self willChangeValueForKey:@keypath(self.routes)];
        block(self.routes);
        [self didChangeValueForKey:@keypath(self.routes)];
    }
}

- (id <RFFormElement>)formElementForSignalValue:(id)value
{
    return [self routeForSignalValue:value].formElement;
}

- (RFSignalContainerRoute *)routeForSignalValue:(id)value
{
    for (RFSignalContainerRoute *route in self.routes) {
        if ([route containsValue:value]) return route;
    }
    return nil;
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
- (RFSignalContainer *)elementWithRoutes:(NSArray *)routes
{
    return [RFSignalContainer containerWithSignal:self routes:routes];
}
@end
