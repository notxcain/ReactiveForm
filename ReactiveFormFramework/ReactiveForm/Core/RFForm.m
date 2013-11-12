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
- (RACSignal *)rf_mapSectionChangesToFormChanges;
@end

@interface RFForm () <RFFormContent>
@property (nonatomic, assign, readwrite, getter = isValid) BOOL valid;
@property (nonatomic, strong, readonly) NSMutableOrderedSet *rootContainer;
@property (nonatomic, strong, readonly) NSOrderedSet *visibleSections;
@property (nonatomic, copy) void (^buildingBlock)(id<RFFormContent>);
@property (nonatomic, strong) RACSignal *changes;
@property (nonatomic, strong, readonly) NSMutableArray *observers;
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
		_observers = [NSMutableArray array];
        _buildingBlock = [buildingBlock copy];
		RACSignal *sectionsSignal = [[[[RACObserve(self, rootContainer) map:^(NSOrderedSet *sections) {
			return [RACSignal combineLatest:[sections map:^(RFSection *section) {
				return [RACObserve(section, fields) mapReplace:section];
			}]];
		}] switchToLatest] map:^(RACTuple *sections) {
			return [[NSOrderedSet orderedSetWithArray:[sections allObjects]] filter:^(RFSection *section) {
				return (BOOL)([section.fields count] != 0);
			}];
		}] distinctUntilChanged];
		
		RAC(self, visibleSections) = sectionsSignal;
		
		_changes = [sectionsSignal rf_mapSectionChangesToFormChanges];
		
		[_changes subscribeNext:^(id x) {
			[self.observers each:^(id observer) {
				RFApplyFormChangesToObserver(self, x, observer);
			}];
		}];
    }
    return self;
}

- (RACSignal *)someSignals
{
	return nil;
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
	@synchronized(self) {
		[self.observers addObject:observer];
	}
}

- (void)removeFormObserver:(id<RFFormObserver>)observer
{
	@synchronized(self) {
		[self.observers removeObject:observer];
	}
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
		[changes[@"RFSectionChanges"] do:^(NSDictionary *sectionChanges) {
			[sectionChanges[@"RFInserted"] enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
				[observer form:form didInsertSectionAtIndex:idx];
			}];
			[sectionChanges[@"RFRemoved"] enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
				[observer form:form didRemoveSectionAtIndex:idx];
			}];
		}];
	}
	
	if ([observer respondsToSelector:@selector(form:didInsertField:atIndexPath:)] && [observer respondsToSelector:@selector(form:didRemoveField:atIndexPath:)]) {
		[changes[@"RFFieldChanges"] do:^(NSDictionary *fieldChanges) {
			[fieldChanges[@"RFInserted"] enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, RFField *field, BOOL *stop) {
				[observer form:form didInsertField:field atIndexPath:indexPath];
			}];
			[fieldChanges[@"RFRemoved"] enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, RFField *field, BOOL *stop) {
				[observer form:form didRemoveField:field atIndexPath:indexPath];
			}];
		}];
	}
	
	if ([observer respondsToSelector:@selector(formDidChangeContent:)]) {
		[observer formDidChangeContent:form];
	}
}


@implementation RACSignal (RFFormChanges)
- (RACSignal *)rf_mapSectionChangesToFormChanges
{
	NSDictionary *(^composeChangesDictionary)(NSIndexSet *, NSIndexSet *, NSDictionary *, NSDictionary *) =
	^(NSIndexSet *insertedSectionIndexSet, NSIndexSet *removedSectionIndexSet, NSDictionary *insertedFieldsAndIndexPaths, NSDictionary *removedFieldsAndIndexPaths) {
		return @{@"RFSectionChanges" : @{@"RFInserted" : insertedSectionIndexSet,
										 @"RFRemoved" : removedSectionIndexSet},
				 @"RFFieldChanges" : @{@"RFInserted" : insertedFieldsAndIndexPaths,
									   @"RFRemoved" : removedFieldsAndIndexPaths}};
	};
	
	id (^indexSetFromSectionChanges)(NSArray *) = ^(NSArray *changes) {
		return [changes foldLeftWithStart:[NSMutableIndexSet indexSet] block:^(NSMutableIndexSet *accumulator, id <RFChangeItem> changeItem) {
			[accumulator addIndex:changeItem.index];
			return accumulator;
		}];
	};
	
	id (^changeItemForField)(RFField *field, NSUInteger section, NSUInteger row) = ^(RFField *field, NSUInteger section, NSUInteger row) {
		return @{[NSIndexPath indexPathForRow:row inSection:section] : field};
	};
	
	
	NSDictionary *(^arrayFromFieldChanges)(NSArray *, NSUInteger) =
	^(NSArray *changes, NSUInteger section) {
		return [[changes map:^(id <RFChangeItem> changeItem) {
			return changeItemForField(changeItem.object, section, changeItem.index);
		}] foldLeftWithStart:[NSMutableDictionary dictionary] block:^id(id accumulator, id x) {
			[accumulator addEntriesFromDictionary:x];
			return accumulator;
		}];
	};

	return [[self combinePreviousWithStart:[NSOrderedSet orderedSet] reduce:^(NSOrderedSet *previousSections, NSOrderedSet *currentSections){
		return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
			id<RFOrderedSetDifference> sectionDiff = [currentSections differenceWithOrderedSet:previousSections];
		
			NSDictionary *fieldInsertions = [[[[sectionDiff insertedObjects] map:^(id <RFChangeItem> insertion) {
				return [[insertion.object fields] mapWithIndex:^(RFField *field, NSUInteger fieldIndex) {
					return changeItemForField(field, insertion.index, fieldIndex);
				}];
			}] flatten] foldLeftWithStart:[NSMutableDictionary dictionary] block:^id(id accumulator, id x) {
				[accumulator addEntriesFromDictionary:x];
				return accumulator;
			}];
			
			NSIndexSet *insertedSectionIndexSet =  indexSetFromSectionChanges([sectionDiff insertedObjects]);
			NSIndexSet *removedSectionIndexSet = indexSetFromSectionChanges([sectionDiff removedObjects]);
			
			[subscriber sendNext:composeChangesDictionary(insertedSectionIndexSet, removedSectionIndexSet, fieldInsertions, @{})];
			
			return [[RACSignal merge:[currentSections mapWithIndex:^(RFSection *section, NSUInteger sectionIndex) {
				return [[section changesForFields] reduceEach:^(NSOrderedSet *oldFields, NSOrderedSet *currentFields) {
					id <RFOrderedSetDifference> fieldDiff = [currentFields differenceWithOrderedSet:oldFields];
					NSDictionary *insertedFields = arrayFromFieldChanges([fieldDiff insertedObjects], sectionIndex);
					NSDictionary *removedFields = arrayFromFieldChanges([fieldDiff removedObjects], sectionIndex);
					return composeChangesDictionary([NSIndexSet indexSet], [NSIndexSet indexSet], insertedFields, removedFields);
				}];
			}]] subscribe:subscriber];
		}];
	}] switchToLatest];
}
@end


