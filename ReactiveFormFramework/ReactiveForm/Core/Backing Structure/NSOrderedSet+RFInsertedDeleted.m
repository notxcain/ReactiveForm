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

NSDictionary *RFOrderedSetInsertedObjectsComparedToOrderedSet(NSOrderedSet *self, NSOrderedSet *oldOrderedSet)
{
	NSMutableOrderedSet *addedObjectSet = [self mutableCopy];
	[addedObjectSet minusOrderedSet:oldOrderedSet];
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if ([addedObjectSet containsObject:obj]) {
			[result setObject:obj forKey:@(idx)];
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
	NSDictionary *addedObjects = RFOrderedSetInsertedObjectsComparedToOrderedSet(self, orderedSet);
	NSDictionary *deletedObjects = RFOrderedSetInsertedObjectsComparedToOrderedSet(orderedSet, self);
	return @{RFInsertedObjectsKey : [addedObjects copy], RFRemovedObjectsKey : [deletedObjects copy]};
}
@end

@implementation NSDictionary (RFOrderedSetDifference)
- (NSDictionary *)removedObjects
{
	return [self objectForKey:RFRemovedObjectsKey];
}

- (NSDictionary *)insertedObjects
{
	return [self objectForKey:RFInsertedObjectsKey];
}
@end