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
#import <ReactiveCocoa/RACEXTKeyPathCoding.h>
#import "NSOrderedSet+Diff.h"
#import "RFCollectionOperations.h"
#import "RFFormContentProvider.h"

@interface RFForm ()
@property (nonatomic, assign, readwrite, getter = isValid) BOOL valid;
@property (nonatomic, strong, readonly) NSOrderedSet *sections;
@property (nonatomic, strong) RACSignal *changes;
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
@synthesize changes = _changes;

+ (instancetype)formWithFormContentProvider:(RFFormContentProvider *)contentProvider
{
    return [[self alloc] initWithFormContentProvider:contentProvider];
}

- (id)initWithFormContentProvider:(RFFormContentProvider *)contentProvider
{
    self = [super init];
    if (self) {
		RAC(self, sections) = contentProvider.visibleSections;
		RACSignal *changes = [[[[contentProvider.visibleSections distinctUntilChanged] combinePreviousWithStart:[NSOrderedSet orderedSet] reduce:^(NSOrderedSet *previousSections, NSOrderedSet *currentSections) {
			return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
				[subscriber sendNext:RFChangesDictionaryWithSectionDiff(previousSections, currentSections)];
				return [[RACSignal merge:[currentSections mapWithIndex:^(RFSection *section, NSUInteger sectionIndex) {
					return [[section.currentFields skip:1] combinePreviousWithStart:section.fields reduce:^(id previous, id current) {
						return RFChangesDictionary(@{}, @{}, @{@(sectionIndex) : RFChangesDictionaryWithFieldDiff(previous, current)});
					}];
				}]] subscribe:subscriber];
			}];
		}] switchToLatest] filter:^BOOL(id value) {
			return ![value isEmpty];
		}];
		
		[self setupObservationManagementWithChangesSignal:changes];
    }
    return self;
}

- (void)setupObservationManagementWithChangesSignal:(RACSignal *)changes
{
	RACSignal *newObserver = [[self rac_signalForSelector:@selector(addFormObserver:)] map:^(RACTuple *args) {
		return args.first;
	}];
	RACSignal *removedObserver = [[self rac_signalForSelector:@selector(removeObserver:)] map:^(RACTuple *args) {
		return args.first;
	}];
	@weakify(self);
	[newObserver subscribeNext:^(id observer) {
		NSCParameterAssert([observer conformsToProtocol:@protocol(RFFormObserver)]);
		@strongify(self);
		RACSignal *observerIsRemoved = [removedObserver filter:^BOOL(id x) {
			return x == observer;
		}];
		RACSignal *observerIsAboutToDealloc = [observer rac_willDeallocSignal];
		[[[changes takeUntil:observerIsRemoved] takeUntil:observerIsAboutToDealloc] subscribeNext:^(id x) {
			@strongify(self);
			NSLog(@"%@", x);
			[self notifyObserver:observer withChangesDictionary:x];
		}];
	}];
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

- (RFSection *)visibleSectionAtIndex:(NSUInteger)index
{
	return self.sections[index];
}

- (RFField *)fieldAtIndexPath:(NSIndexPath *)indexPath
{
	return [self visibleSectionAtIndex:indexPath.section].fields[indexPath.row];
}

- (NSIndexPath *)indexPathForField:(RFField *)field
{
	__block NSIndexPath *result = nil;
	[self.sections enumerateObjectsUsingBlock:^(RFSection *section, NSUInteger idx, BOOL *stop) {
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
	return [self.sections count];
}

- (NSUInteger)numberOfFieldsInSection:(NSUInteger)section
{
	return [[self visibleSectionAtIndex:section].fields count];
}

- (RFField *)fieldBeforeField:(RFField *)field
{
    return [self fieldAtIndexPath:[self indexPathBeforeIndexPath:[self indexPathForField:field]]];;
}

- (RFField *)fieldAfterField:(RFField *)field
{
    return [self fieldAtIndexPath:[self indexPathAfterIndexPath:[self indexPathForField:field]]];
}

- (NSIndexPath *)indexPathBeforeIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row > 0) {
        return [NSIndexPath indexPathForRow:indexPath.row - 1 inSection:indexPath.section];
    } else if (indexPath.section > 0) {
        NSUInteger previousSection = indexPath.section - 1;
        return [NSIndexPath indexPathForRow:[self numberOfFieldsInSection:previousSection] - 1 inSection:previousSection];
    }
    return nil;
}

- (NSIndexPath *)indexPathAfterIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.row + 1 < [self numberOfFieldsInSection:indexPath.section]) {
        return [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
    } else if (indexPath.section + 1 < [self numberOfSections]) {
        return [NSIndexPath indexPathForRow:0 inSection:indexPath.section + 1];
    }
    return nil;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", [super description], [self.sections description]];
}
@end




