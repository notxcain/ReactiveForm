//
//  RFCollectionOperations.m
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 11/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFCollectionOperations.h"

@implementation NSArray (Map)
- (instancetype)map:(id (^)(id))mapBlock
{
	NSMutableArray *result = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[result addObject:mapBlock(obj)];
	}];
	return [result copy];
}

- (instancetype)filter:(BOOL (^)(id))filterBlock
{
	NSMutableArray *result = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (!filterBlock(obj)) return;
		[result addObject:obj];
	}];
	return [result copy];
}

- (void)each:(void (^)(id))each
{
	for (id obj in self) {
		each(obj);
	}
}
@end

@implementation NSOrderedSet (Map)
- (instancetype)map:(id (^)(id))mapBlock
{
	NSMutableOrderedSet *result = [NSMutableOrderedSet orderedSet];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[result addObject:mapBlock(obj)];
	}];
	return [result copy];
}

- (instancetype)filter:(BOOL (^)(id))filterBlock
{
	NSMutableOrderedSet *result = [NSMutableOrderedSet orderedSet];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		if (!filterBlock(obj)) return;
		[result addObject:obj];
	}];
	return [result copy];
}

- (void)each:(void (^)(id))each
{
	for (id obj in self) {
		each(obj);
	}
}
@end