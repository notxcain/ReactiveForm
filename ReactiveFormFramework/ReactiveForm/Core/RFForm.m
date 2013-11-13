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

NSString *const RFFormDidChangeNotification = @"RFFormDidChangeNotification";

@interface RACSignal (RFFormChanges)
- (RACSignal *)rf_mapToRecursiveChanges;
@end

@interface RFForm () <RFFormContent>
@property (nonatomic, assign, readwrite, getter = isValid) BOOL valid;
@property (nonatomic, strong, readonly) NSMutableOrderedSet *rootContainer;
@property (nonatomic, strong, readonly) NSOrderedSet *visibleSections;
@property (nonatomic, copy) void (^buildingBlock)(id<RFFormContent>);
@property (nonatomic, strong) RACSignal *changes;
@end

void RFApplyFormChangesToObserver(RFForm *form, NSDictionary *changes, id <RFFormObserver> observer);

@implementation RFForm
@synthesize rootContainer = _rootContainer;

+ (instancetype)formWithBuildingBlock:(void (^)(id<RFFormContent>))buildingBlock
{
    return [[self alloc] initWithBuildingBlock:buildingBlock];
}

- (id)initWithBuildingBlock:(void (^)(id<RFFormContent>))buildingBlock
{
    self = [super init];
    if (self) {
        _buildingBlock = [buildingBlock copy];
		
		RACSignal *sectionsSignal = [[[[[RACObserve(self, rootContainer) map:^(NSOrderedSet *sections) {
			return [RACSignal combineLatest:[sections map:^(RFSection *section) {
				return [section.contentSignal mapReplace:section];
			}]];
		}] switchToLatest] map:^(RACTuple *sections) {
			NSArray *notEmptySections = [[sections allObjects] filterNot:^(RFSection *section) {
				return [section isEmpty];
			}];
			return notEmptySections;
		}] distinctUntilChanged] map:^(NSArray *array) {
			return [NSOrderedSet orderedSetWithArray:array];
		}];
		
		RAC(self, visibleSections) = sectionsSignal;
		
		_changes = [sectionsSignal rf_mapToRecursiveChanges];
		
		[[self rac_signalForSelector:@selector(addFormObserver:)] subscribeNext:^(RACTuple *args) {
			RACSignal *removalSignal = [[self rac_signalForSelector:@selector(removeObserver:)] filter:^BOOL(RACTuple *removeArgs) {
				return removeArgs.first == args.first;
			}];
			
			[[_changes takeUntil:removalSignal] subscribeNext:^(id x) {
				RFApplyFormChangesToObserver(self, x, args.first);
			}];
		}];
    }
    return self;
}

- (id)addSectionWithElement:(id<RFFormElement>)formElement
{
	[self willChangeValueForKey:@keypath(self.rootContainer)];
    RFSection *section = [RFSection sectionWithFormElement:formElement];
    [self.rootContainer addObject:section];
	[self didChangeValueForKey:@keypath(self.rootContainer)];
    return section;
}


- (void)removeSection:(RFSection *)section
{
	[self willChangeValueForKey:@keypath(self.rootContainer)];
	NSUInteger index = [self.rootContainer indexOfObject:section];
	[self.rootContainer removeObjectAtIndex:index];
	[self didChangeValueForKey:@keypath(self.rootContainer)];
}


- (NSMutableOrderedSet *)rootContainer
{
    if (_rootContainer) return _rootContainer;
    
    _rootContainer = [NSMutableOrderedSet orderedSet];
	
    self.buildingBlock(self);
    
    return _rootContainer;
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

- (void)addFormObserver:(id<RFFormObserver>)observer
{

}

- (void)removeFormObserver:(id<RFFormObserver>)observer
{
	
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", [super description], [self.visibleSections description]];
}
@end


void RFApplyFormChangesToObserver(RFForm *form, NSDictionary *changes, id <RFFormObserver> observer)
{
	if ([observer respondsToSelector:@selector(formWillChangeContent:)]) {
		[observer formWillChangeContent:form];
	}
	
	if ([observer respondsToSelector:@selector(form:didInsertSectionAtIndex:)] && [observer respondsToSelector:@selector(form:didRemoveSectionAtIndex:)]) {
		[changes[@"inserted"] eachWithKey:^(id x, id key) {
			[observer form:form didInsertSectionAtIndex:[key unsignedIntegerValue]];
		}];
		[changes[@"removed"] eachWithKey:^(id x, id key) {
			[observer form:form didRemoveSectionAtIndex:[key unsignedIntegerValue]];
		}];
	}
	
	if ([observer respondsToSelector:@selector(form:didInsertField:atIndexPath:)] && [observer respondsToSelector:@selector(form:didRemoveField:atIndexPath:)]) {
		[changes[@"changed"] do:^(NSDictionary *fieldChanges) {
			[fieldChanges eachWithKey:^(NSDictionary *sectionChanges, id key) {
				NSUInteger section = [key unsignedIntegerValue];
				[sectionChanges[@"inserted"] eachWithKey:^(RFField *field, id key) {
					NSUInteger row = [key unsignedIntegerValue];
					[observer form:form didInsertField:field atIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
				}];
				
				[sectionChanges[@"removed"] eachWithKey:^(RFField *field, id key) {
					NSUInteger row = [key unsignedIntegerValue];
					[observer form:form didRemoveField:field atIndexPath:[NSIndexPath indexPathForRow:row inSection:section]];
				}];
			}];
		}];
	}
	
	if ([observer respondsToSelector:@selector(formDidChangeContent:)]) {
		[observer formDidChangeContent:form];
	}
}

@protocol RFOrderedSetController <NSObject>
@property (nonatomic, strong, readonly) NSOrderedSet *items;
@property (nonatomic, strong, readonly) RACSignal *contentSignal;
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


@implementation RACSignal (RFFormChanges)

+ (RACSignal *)rf_signalForChangesOfSections:(NSOrderedSet *)sections
{
	return [RACSignal merge:[sections mapWithIndex:^(RFSection *section, NSUInteger sectionIndex) {
		return [[section contentSignal] combinePreviousWithStart:section.fields reduce:^(NSOrderedSet *previousFields, NSOrderedSet *currentFields) {
			return RFChangesDictionary(@{}, @{}, @{@(sectionIndex) : RFChangesDictionaryWithFieldDiff(previousFields, currentFields)});
		}];
	}]];
}

- (RACSignal *)rf_mapToRecursiveChanges
{
	return [[self combinePreviousWithStart:[NSOrderedSet orderedSet] reduce:^(NSOrderedSet *previousSections, NSOrderedSet *currentSections){
		return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
			[subscriber sendNext:RFChangesDictionaryWithSectionDiff(previousSections, currentSections)];
			return [[RACSignal rf_signalForChangesOfSections:currentSections] subscribe:subscriber];
		}];
	}] switchToLatest];
}
@end


