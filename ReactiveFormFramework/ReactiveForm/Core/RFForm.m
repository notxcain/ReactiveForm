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


@interface NSObject (Observation)
- (RACSignal *)rf_oldAndNewValuesForKeyPath:(NSString *)keyPath observer:(id)observer;
@end

@implementation NSObject (Observation)
- (RACSignal *)rf_oldAndNewValuesForKeyPath:(NSString *)keyPath observer:(id)observer
{
	return [[self rac_valuesAndChangesForKeyPath:keyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew observer:observer] map:^id(RACTuple *valueAndChanges) {
		NSDictionary *changes = valueAndChanges.second;
		return RACTuplePack(changes[NSKeyValueChangeOldKey], changes[NSKeyValueChangeNewKey]);
	}];
}
@end

@interface RFForm () <RFFormContent>
@property (nonatomic, assign, readwrite, getter = isValid) BOOL valid;
@property (nonatomic, strong, readonly) NSMutableOrderedSet *rootContainer;
@property (nonatomic, strong, readonly) NSOrderedSet *visibleSections;
@property (nonatomic, copy) void (^buildingBlock)(id<RFFormContent>);
@property (nonatomic, strong) RACSubject *sectionRemovals;
@end

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
		_sectionRemovals = [RACSubject subject];
		RAC(self, visibleSections) = [[[RACObserve(self, rootContainer) map:^(NSOrderedSet *sections) {
			return [RACSignal combineLatest:[sections map:^(RFSection *section) {
				return [RACObserve(section, visibleFields) mapReplace:section];
			}]];
		}] switchToLatest] map:^(RACTuple *sections) {
			return [[NSOrderedSet orderedSetWithArray:[sections allObjects]] filter:^(RFSection *section) {
				return (BOOL)([section.visibleFields count] != 0);
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

- (void)setVisibleSections:(NSOrderedSet *)visibleSections
{
    if ([_visibleSections isEqualToOrderedSet:visibleSections]) return;
	
	id<RFOrderedSetDifference> diff = [visibleSections differenceWithOrderedSet:_visibleSections];
	NSArray *insertedSections = [diff insertedObjects];
	NSArray *removedSections = [diff removedObjects];
	
	_visibleSections = visibleSections;
	
	
	[[removedSections map:^(id x) {
		return x[1];
	}] each:^(id x) {
		[self.sectionRemovals sendNext:x];
	}];

	NSMutableArray *fieldInsertions = [NSMutableArray array];
	
	[insertedSections each:^(NSArray *array) {
		RACTupleUnpack(NSNumber *sectionIndex, RFSection *section) = [RACTuple tupleWithObjectsFromArray:array];
		
		[section.visibleFields enumerateObjectsUsingBlock:^(RFField *field, NSUInteger fieldIndex, BOOL *stop) {
			[fieldInsertions addObject:@[[NSIndexPath indexPathForRow:fieldIndex inSection:sectionIndex.unsignedIntegerValue], field]];
		}];
		
		[[[[section rf_oldAndNewValuesForKeyPath:@keypath(section.visibleFields) observer:self] takeUntil:[self removalSignalForSection:section]] map:^(RACTuple *oldAndNewValues) {
			RACTupleUnpack(NSOrderedSet *oldVisibleFields, NSOrderedSet *visibleFields) = oldAndNewValues;
			return [self fieldChangesDictionaryForSectionAtIndex:sectionIndex.unsignedIntegerValue oldValue:oldVisibleFields newValue:visibleFields];
		}] subscribeNext:^(NSDictionary *changesDictionary) {
			NSLog(@"%@", changesDictionary);
		}];
	}];
	
	NSArray *sectionInsertions =  [insertedSections map:^(NSArray *sectionChange) {
		return sectionChange[0];
	}];
	
	NSArray *sectionRemovals = [removedSections map:^(NSArray *sectionChange) {
		return sectionChange[0];
	}];
	
	NSLog(@"%@", @{@"RFSectionChanges" : @{@"RFInserted" : sectionInsertions, @"RFRemoved" : sectionRemovals}, @"RFFieldChanges" : @{@"RFInserted" : fieldInsertions}});
}

- (NSDictionary *)fieldChangesDictionaryForSectionAtIndex:(NSUInteger)sectionIndex oldValue:(NSOrderedSet *)oldValue newValue:(NSOrderedSet *)newValue
{
	id <RFOrderedSetDifference> fieldDiff = [newValue differenceWithOrderedSet:oldValue];
	
	NSMutableArray *insertedFields = [NSMutableArray array];
	[[fieldDiff insertedObjects] each:^(NSArray *change) {
		RACTupleUnpack(NSNumber *fieldIndex, RFField *field) = [RACTuple tupleWithObjectsFromArray:change];
		[insertedFields addObject:@[[NSIndexPath indexPathForRow:fieldIndex.unsignedIntegerValue inSection:sectionIndex], field]];
	}];
	
	NSMutableArray *removedFields = [NSMutableArray array];
	[[fieldDiff removedObjects] each:^(NSArray *change) {
		RACTupleUnpack(NSNumber *fieldIndex, RFField *field) = [RACTuple tupleWithObjectsFromArray:change];
		[removedFields addObject:@[[NSIndexPath indexPathForRow:fieldIndex.unsignedIntegerValue inSection:sectionIndex], field]];
	}];
	
	return @{@"RFFieldChanges" : @{@"RFInserted" : insertedFields, @"RFRemoved" : removedFields}};

}

- (RACSignal *)removalSignalForSection:(RFSection *)section
{
	return [self.sectionRemovals filter:^BOOL(id value) {
		return (value == section);
	}];
}

- (RFSection *)visibleSectionAtIndex:(NSUInteger)index
{
	return self.visibleSections[index];
}

- (RFField *)fieldAtIndexPath:(NSIndexPath *)indexPath
{
	return [self visibleSectionAtIndex:indexPath.section].visibleFields[indexPath.row];
}

- (NSIndexPath *)indexPathForField:(RFField *)field
{
	__block NSIndexPath *result = nil;
	[self.visibleSections enumerateObjectsUsingBlock:^(RFSection *section, NSUInteger idx, BOOL *stop) {
		NSUInteger fieldIndex = [section.visibleFields indexOfObject:field];
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
	return [[self visibleSectionAtIndex:section].visibleFields count];
}


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", [super description], [self.visibleSections description]];
}
@end


