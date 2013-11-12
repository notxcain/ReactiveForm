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

- (instancetype)mapWithIndex:(id (^)(id, NSUInteger))mapBlock
{
	NSMutableArray *result = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[result addObject:mapBlock(obj, idx)];
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

- (id)foldLeftWithStart:(id)accumulator block:(id (^)(id accumulator, id x))block
{
	for (id x in self) {
		accumulator = block(accumulator, x);
	};
	return accumulator;
}

- (instancetype)flatten
{
	return [[self foldLeftWithStart:[NSMutableArray array] block:^id(id accumulator, id x) {
		NSCParameterAssert([x conformsToProtocol:@protocol(NSFastEnumeration)]);
		for (id obj in x) {
			[accumulator addObject:obj];
		}
		return accumulator;
	}] copy];
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

- (instancetype)mapWithIndex:(id (^)(id, NSUInteger))mapBlock
{
	NSMutableOrderedSet *result = [NSMutableOrderedSet orderedSet];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[result addObject:mapBlock(obj, idx)];
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

- (id)foldLeftWithStart:(id)accumulator block:(id (^)(id accumulator, id x))block
{
	for (id x in self) {
		accumulator = block(accumulator, x);
	};
	return accumulator;
}

- (instancetype)flatten
{
	return [[self foldLeftWithStart:[NSMutableOrderedSet orderedSet] block:^id(id accumulator, id <NSFastEnumeration> x) {
		for (id obj in x) {
			[accumulator addObject:obj];
		}
		return accumulator;
	}] copy];
}
@end