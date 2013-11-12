//
//  NSOrderedSet+RFInsertedDeleted.m
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 11/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "NSOrderedSet+RFInsertedDeleted.h"

NSString *const RFRemovedObjectsKey = @"RFRemovedObjectsKey";
NSString *const RFInsertedObjectsKey = @"RFInsertedObjectsKey";

@interface NSDictionary (RFOrderedSetDifference) <RFOrderedSetDifference>
@end

@interface NSArray (RFChangeItem) <RFChangeItem>

@end

NSArray *RFOrderedSetInsertedObjectsComparedToOrderedSet(NSOrderedSet *self, NSOrderedSet *oldOrderedSet)
{
	NSMutableOrderedSet *addedObjectSet = [self mutableCopy];
	[addedObjectSet minusOrderedSet:oldOrderedSet];
	NSMutableArray *result = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([addedObjectSet containsObject:obj]) {
			[result addObject:@[@(idx), obj]];
		}
	}];
	return [result copy];
}

@implementation NSOrderedSet (RFInsertedDeleted)
- (id<RFOrderedSetDifference>)differenceWithOrderedSet:(NSOrderedSet *)orderedSet
{
	if (!orderedSet || [orderedSet isEqual:[NSNull null]]) {
		return [self differenceWithOrderedSet:[NSOrderedSet orderedSet]];
	}
	NSArray *addedObjects = RFOrderedSetInsertedObjectsComparedToOrderedSet(self, orderedSet);
	NSArray *deletedObjects = RFOrderedSetInsertedObjectsComparedToOrderedSet(orderedSet, self);
	return @{RFInsertedObjectsKey : [addedObjects copy], RFRemovedObjectsKey : [deletedObjects copy]};
}
@end

@implementation NSDictionary (RFOrderedSetDifference)
- (NSArray *)removedObjects
{
	return [self objectForKey:RFRemovedObjectsKey];
}

- (NSArray *)insertedObjects
{
	return [self objectForKey:RFInsertedObjectsKey];
}
@end

@implementation NSArray (RFChangeItem)
- (id)object
{
	return self[1];
}

- (NSUInteger)index
{
	return [self[0] unsignedIntegerValue];
}
@end