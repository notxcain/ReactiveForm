//
//  RFFixedElementContainer.m
//  Form
//
//  Created by Denis Mikhaylov on 10.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFContainer.h"
#import "RFCollectionOperations.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import <ReactiveCocoa/RACEXTKeyPathCoding.h>

@interface RFContainer ()
@property (nonatomic, strong, readonly) NSMutableArray *elements;
@property (nonatomic, strong, readonly) RACSignal *visibleElements;
@end

@implementation RFContainer
+ (instancetype)container
{
    return [self containerWithElements:nil];
}

+ (instancetype)containerWithElements:(NSArray *)elements
{
    RFContainer *container = [[self alloc] init];
    [container addElementsFromArray:elements];
    return container;
}

- (id)init
{
    self = [super init];
    if (self) {
        _elements = [NSMutableArray array];
        _visibleElements = [[RACObserve(self, elements) map:^(NSArray *elements) {
            return [[RACSignal combineLatest:[elements map:^(id <RFFormElement> formElement) {
				return [formElement visibleFields];
			}]] map:^(RACTuple *sequencies) {
                return [sequencies.rac_sequence flatten];
            }];
        }] switchToLatest];
    }
    return self;
}

- (void)addElementsFromArray:(NSArray *)array
{
    [self changeElementsUsingBlock:^(NSMutableArray *elements) {
        [elements addObjectsFromArray:array];
    }];
}

- (void)addElement:(id<RFFormElement>)element
{
    [self changeElementsUsingBlock:^(NSMutableArray *elements) {
        [elements addObject:element];
    }];
}

- (void)removeElement:(id<RFFormElement>)element
{
    [self changeElementsUsingBlock:^(NSMutableArray *elements) {
        [elements removeObject:element];
    }];
}

- (void)changeElementsUsingBlock:(void (^)(NSMutableArray *elements))block
{
    @synchronized(self) {
        [self willChangeValueForKey:@keypath(self.elements)];
        block(self.elements);
        [self didChangeValueForKey:@keypath(self.elements)];
    }
}
@end