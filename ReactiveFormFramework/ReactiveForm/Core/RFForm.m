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
			[[NSNotificationCenter defaultCenter] postNotificationName:RFFormDidChangeNotification object:self userInfo:x];
		}];
    }
    return self;
}

- (NSDictionary *)fieldChangesDictionaryForSectionAtIndex:(NSUInteger)sectionIndex oldValue:(NSOrderedSet *)oldValue newValue:(NSOrderedSet *)newValue
{
	id <RFOrderedSetDifference> fieldDiff = [newValue differenceWithOrderedSet:oldValue];
	
	NSArray *insertedFields = [[fieldDiff insertedObjects] map:^(NSArray *change) {
		return @[[NSIndexPath indexPathForRow:[change[0] unsignedIntegerValue] inSection:sectionIndex], change[1]];
	}];
	
	NSArray *removedFields = [[fieldDiff removedObjects] map:^(NSArray *change) {
		return @[[NSIndexPath indexPathForRow:[change[0] unsignedIntegerValue] inSection:sectionIndex], change[1]];
	}];
	
	return @{@"RFFieldChanges" : @{@"RFInserted" : insertedFields, @"RFRemoved" : removedFields}};
	
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


- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", [super description], [self.visibleSections description]];
}
@end

@implementation RACSignal (RFFormChanges)
- (RACSignal *)rf_mapSectionChangesToFormChanges
{
	NSDictionary *(^composeChangesDictionary)(NSIndexSet *, NSIndexSet *, NSArray *, NSArray *) =
	^(NSIndexSet *insertedSectionIndexSet, NSIndexSet *removedSectionIndexSet, NSArray *insertedFieldsAndIndexPaths, NSArray *removedFieldsAndIndexPaths) {
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
		return @[[NSIndexPath indexPathForRow:row inSection:section], field];
	};
	
	
	NSArray *(^arrayFromFieldChanges)(NSArray *, NSUInteger) =
	^(NSArray *changes, NSUInteger section) {
		return [changes map:^(id <RFChangeItem> changeItem) {
			return changeItemForField(changeItem.object, section, changeItem.index);
		}];
	};

	return [[self combinePreviousWithStart:[NSOrderedSet orderedSet] reduce:^(NSOrderedSet *previousSections, NSOrderedSet *currentSections){
		return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
			id<RFOrderedSetDifference> sectionDiff = [currentSections differenceWithOrderedSet:previousSections];
			
			NSArray *fieldInsertions = [[[sectionDiff insertedObjects] map:^(id <RFChangeItem> insertion) {
				return [[insertion.object fields] mapWithIndex:^(RFField *field, NSUInteger fieldIndex) {
					return changeItemForField(field, insertion.index, fieldIndex);
				}];
			}] flatten];
			
			NSIndexSet *insertedSectionIndexSet =  indexSetFromSectionChanges([sectionDiff insertedObjects]);
			NSIndexSet *removedSectionIndexSet = indexSetFromSectionChanges([sectionDiff removedObjects]);
			
			[subscriber sendNext:composeChangesDictionary(insertedSectionIndexSet, removedSectionIndexSet, fieldInsertions, @[])];
			
			return [[RACSignal merge:[currentSections mapWithIndex:^(RFSection *section, NSUInteger sectionIndex) {
				return [[section signalOfChangesForFields] reduceEach:^(NSOrderedSet *oldFields, NSOrderedSet *currentFields) {
					id <RFOrderedSetDifference> fieldDiff = [currentFields differenceWithOrderedSet:oldFields];
					NSArray *insertedFields = arrayFromFieldChanges([fieldDiff insertedObjects], sectionIndex);
					NSArray *removedFields = arrayFromFieldChanges([fieldDiff removedObjects], sectionIndex);
					return composeChangesDictionary([NSIndexSet indexSet], [NSIndexSet indexSet], insertedFields, removedFields);
				}];
			}]] subscribe:subscriber];
		}];
	}] switchToLatest];
}
@end


