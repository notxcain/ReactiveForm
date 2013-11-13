//
//  RFForm.m
//  Form
//
//  Created by Denis Mikhaylov on 10.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFForm.h"
#import "RFDefines.h"

#import "RFField.h"
#import "RFSection.h"
#import <CoreData/CoreData.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "RFContainer.h"
#import <objc/runtime.h>
#import "RFForm+Private.h"
#import <ReactiveCocoa/RACEXTKeyPathCoding.h>
#import "NSOrderedSet+RFInsertedDeleted.h"
#import "RFCollectionOperations.h"
#import "RFFormContentProvider.h"

@interface RFForm ()
@property (nonatomic, assign, readwrite, getter = isValid) BOOL valid;
@property (nonatomic, strong, readonly) NSMutableOrderedSet *rootContainer;
@property (nonatomic, strong, readonly) NSOrderedSet *visibleSections;
@property (nonatomic, strong, readonly) RFFormContentProvider *contentProvider;
@property (nonatomic, strong) RACSignal *changes;
@property (nonatomic, strong, readonly) RACSignal *visibleSectionsSignal;
@end

NSDictionary *RFChangesDictionary(NSDictionary *insertedItems, NSDictionary *removedItems, NSDictionary *changedItems) {
	return [@{@"inserted" : insertedItems, @"removed" : removedItems, @"changed" : changedItems} filter:^BOOL(id x) {
		return !([x count] == 0);
	}];
}

NSDictionary *RFChangesDictionaryWithFieldDiff(NSOrderedSet *previousFields, NSOrderedSet *currentFields) {
	id<RFOrderedSetDifference> diff = [currentFields differenceWithOrderedSet:previousFields];
	NSDictionary *insertedItems = [diff insertedObjects];
	NSDictionary *removedItems = [diff removedObjects];
	return RFChangesDictionary(insertedItems, removedItems, @{});
}

NSDictionary *RFChangesDictionaryWithSectionDiff(NSOrderedSet *previousItems, NSOrderedSet *currentItems) {
	id<RFOrderedSetDifference> collectionDiff = [currentItems differenceWithOrderedSet:previousItems];
	NSDictionary *insertedItems = [collectionDiff insertedObjects];
	NSDictionary *removedItems = [collectionDiff removedObjects];
	NSDictionary *changedItems = [insertedItems map:^(RFSection *section) {
		return RFChangesDictionaryWithFieldDiff([NSOrderedSet orderedSet], section.fields);
	}];
	return RFChangesDictionary(insertedItems, removedItems, changedItems);
}

@implementation RFForm
@synthesize rootContainer = _rootContainer, changes = _changes;

+ (instancetype)formWithFormContentProvider:(RFFormContentProvider *)contentProvider
{
    return [[self alloc] initWithFormContentProvider:contentProvider];
}

- (id)initWithFormContentProvider:(RFFormContentProvider *)contentProvider
{
    self = [super init];
    if (self) {
		_contentProvider = contentProvider;
		
		RAC(self, visibleSections) = contentProvider.visibleSections;
		
		@weakify(self);
		[[self rac_signalForSelector:@selector(addFormObserver:)] subscribeNext:^(RACTuple *args) {
			@strongify(self);
			NSObject <RFFormObserver> *observer = args.first;
			RACSignal *removalSignal = [[self rac_signalForSelector:@selector(removeObserver:)] filter:^BOOL(RACTuple *removeArgs) {
				return removeArgs.first == observer;
			}];
			
			[[[self.changes takeUntil:removalSignal] takeUntil:[observer rac_willDeallocSignal]] subscribeNext:^(id x) {
				@strongify(self);
				[self notifyObserver:observer withChangesDictionary:x];
			}];
		}];
    }
    return self;
}

- (void)notifyObserver:(id <RFFormObserver>)observer withChangesDictionary:(NSDictionary *)changes
{
	if ([observer respondsToSelector:@selector(formWillChangeContent:)]) {
		[observer formWillChangeContent:self];
	}
	
	if ([observer respondsToSelector:@selector(form:didInsertSectionAtIndex:)] && [observer respondsToSelector:@selector(form:didRemoveSectionAtIndex:)]) {
		[changes[@"inserted"] eachWithKey:^(id x, id key) {
			[observer form:self didInsertSectionAtIndex:[key unsignedIntegerValue]];
		}];
		[changes[@"removed"] eachWithKey:^(id x, id key) {
			[observer form:self didRemoveSectionAtIndex:[key unsignedIntegerValue]];
		}];
	}
	
	if ([observer respondsToSelector:@selector(form:didInsertField:atIndexPath:)] && [observer respondsToSelector:@selector(form:didRemoveField:atIndexPath:)]) {
		[changes[@"changed"] do:^(NSDictionary *fieldChanges) {
			[fieldChanges eachWithKey:^(NSDictionary *sectionChanges, id key) {
				NSUInteger section = [key unsignedIntegerValue];
				[sectionChanges[@"inserted"] eachWithKey:^(RFField *field, id key) {
					NSUInteger row = [key unsignedIntegerValue];
					[observer form:self didInsertField:field atIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
				}];
				
				[sectionChanges[@"removed"] eachWithKey:^(RFField *field, id key) {
					NSUInteger row = [key unsignedIntegerValue];
					[observer form:self didRemoveField:field atIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
				}];
			}];
		}];
	}
	
	if ([observer respondsToSelector:@selector(formDidChangeContent:)]) {
		[observer formDidChangeContent:self];
	}

}

- (RACSignal *)changes
{
	if (_changes) return _changes;
	
	_changes = [[[self.contentProvider.visibleSections combinePreviousWithStart:self.visibleSections reduce:^(NSOrderedSet *previousSections, NSOrderedSet *currentSections){
		if ([previousSections isEqualToOrderedSet:currentSections]) {
			return [RACSignal empty];
		}
		return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
			[subscriber sendNext:RFChangesDictionaryWithSectionDiff(previousSections, currentSections)];
			return [[RACSignal merge:[currentSections mapWithIndex:^(RFSection *section, NSUInteger sectionIndex) {
				return [[section changesOfFields] reduceEach:^(NSOrderedSet *previousFields, NSOrderedSet *currentFields) {
					return RFChangesDictionary(@{}, @{}, @{@(sectionIndex) : RFChangesDictionaryWithFieldDiff(previousFields, currentFields)});
				}];
			}]] subscribe:subscriber];
		}];
	}] switchToLatest] replayLast];
	
	return _changes;
}

- (RFSection *)visibleSectionAtIndex:(NSUInteger)index
{
	return self.visibleSections[index];
}

- (RFField *)fieldAtIndexPath:(NSIndexPath *)indexPath
{
	return [self visibleSectionAtIndex:indexPath.section].fields[indexPath.row];
}

- (NSIndexPath *)indexPathForField:(RFField *)field
{
	__block NSIndexPath *result = nil;
	[self.visibleSections enumerateObjectsUsingBlock:^(RFSection *section, NSUInteger idx, BOOL *stop) {
		NSUInteger fieldIndex = [section.fields indexOfObject:field];
		if (fieldIndex != NSNotFound) {
			*stop = YES;
			result = [NSIndexPath indexPathForRow:fieldIndex inSection:idx];
		}
	}];
	return result;
}

- (NSUInteger)numberOfSections
{
	return [self.visibleSections count];
}

- (NSUInteger)numberOfFieldsInSection:(NSUInteger)section
{
	return [[self visibleSectionAtIndex:section].fields count];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", [super description], [self.visibleSections description]];
}
@end




