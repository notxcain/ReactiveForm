//
//  RFFormContentProvider.m
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 13/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFFormContentProvider.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RFCollectionOperations.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import "RFSection.h"
#import "RFDefines.h"

@implementation RFFormContentProvider

+ (instancetype)contentProvider
{
	return [[self alloc] init];
}

- (RACSignal *)visibleSections
{
	RFAssertShouldBeOverriden();
	return nil;
}
@end

@interface RFMutableFormContentProvider ()

@end

@implementation RFMutableFormContentProvider

- (id)init
{
    self = [super init];
    if (self) {
		@weakify(self);

        RACSignal *currentSections = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
            NSMutableOrderedSet *sections = [NSMutableOrderedSet orderedSet];
			@strongify(self);
			RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];
			[disposable addDisposable:[[self rac_signalForSelector:@selector(addSection:)] subscribeNext:^(RACTuple *args) {
				[sections addObject:args.first];
				[subscriber sendNext:sections];
			}]];
			[disposable addDisposable:[[self rac_signalForSelector:@selector(removeSection:)] subscribeNext:^(RACTuple *args) {
				[sections removeObject:args.first];
				[subscriber sendNext:sections];
			}]];
			[subscriber sendNext:sections];
			return disposable;
		}];
		
		RACSignal *visibleSections = [[[currentSections map:^(NSOrderedSet *sections) {
            if ([sections isEmpty]) return [RACSignal return:[NSOrderedSet orderedSet]];
            
			return [[RACSignal combineLatest:[sections map:^(RFSection *section) {
				return [section.currentFields mapReplace:section];
			}]] map:^(RACTuple *sections) {
				return [NSOrderedSet orderedSetWithArray:[[sections allObjects] filterNotEmpty]];
			}];
		}] switchToLatest] replayLast];
		
		_visibleSections = visibleSections;
    }
    return self;
}

- (id)addSectionWithElement:(id <RFFormElement>)formElement{
	RFSection *section = [RFSection sectionWithFormElement:formElement];
	[self addSection:section];
	return section;
}

- (void)addSection:(RFSection *)section{}

- (void)removeSection:(id)section{}
@end