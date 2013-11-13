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
        RACSignal *sectionsSignal = [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
			NSMutableOrderedSet *rootContainer = [NSMutableOrderedSet orderedSet];
			
			RACCompoundDisposable *disposable = [RACCompoundDisposable compoundDisposable];
			
			[disposable addDisposable:[[self rac_signalForSelector:@selector(addSection:)] subscribeNext:^(RACTuple *args) {
				RFSection *section = args.first;
				[rootContainer addObject:section];
				[subscriber sendNext:rootContainer];
			}]];
			
			[disposable addDisposable:[[self rac_signalForSelector:@selector(removeSection:)] subscribeNext:^(RACTuple *args) {
				RFSection *section = args.first;
				[rootContainer removeObject:section];
				[subscriber sendNext:rootContainer];
			}]];
		
			
			[subscriber sendNext:rootContainer];
			return disposable;
		}];
		
		_visibleSections = [[[[[[sectionsSignal map:^(NSOrderedSet *sections) {
			return [RACSignal combineLatest:[sections map:^(RFSection *section) {
				return [section.contentSignal mapReplace:section];
			}]];
		}] switchToLatest] map:^(RACTuple *sections) {
			return [[sections allObjects] filterNot:^(RFSection *section) {
				return [section isEmpty];
			}];
		}] distinctUntilChanged] map:^(NSArray *array) {
			return [NSOrderedSet orderedSetWithArray:array];
		}] replayLast];
    }
    return self;
}

- (id)addSectionWithElement:(id <RFFormElement>)formElement{
	RFSection *section = [RFSection sectionWithFormElement:formElement];
	[self addSection:section];
	return section;
}

- (void)addSection:(RFSection *)section
{
	
}

- (void)removeSection:(id)section
{
	
}
@end