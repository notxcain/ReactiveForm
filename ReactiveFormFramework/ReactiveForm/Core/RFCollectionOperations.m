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
	return [self mapWithIndex:^id(id x, NSUInteger idx) {
		return mapBlock(x);
	}];
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

- (instancetype)flattenMapWithIndex:(id (^)(id, NSUInteger))mapBlock
{
    NSMutableArray *result = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		[result addObject:mapBlock(obj, idx)];
	}];
    return [result flatten];
}

- (instancetype)filterNot:(BOOL (^)(id))filterBlock
{
	return [self filter:^BOOL(id x) {
		return !filterBlock(x);
	}];
}

- (instancetype)filterNotEmpty
{
    return [self filterNot:^BOOL(id x) {
        return [x isEmpty];
    }];
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

- (BOOL)isEmpty
{
	return [self count] == 0;
}
@end

@implementation NSOrderedSet (Map)
- (instancetype)map:(id (^)(id))mapBlock
{
	return [self mapWithIndex:^id(id x, NSUInteger idx) {
		return mapBlock(x);
	}];
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

- (instancetype)filterNot:(BOOL (^)(id))filterBlock
{
	return [self filter:^BOOL(id x) {
		return !filterBlock(x);
	}];
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

- (BOOL)isEmpty
{
	return [self count] == 0;
}
@end

@implementation NSDictionary (Map)

- (instancetype)map:(id (^)(id))mapBlock
{
	return [self mapWithKey:^id(id x, id key) {
		return mapBlock(x);
	}];
}

- (void)eachWithKey:(void (^)(id, id))block
{
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		block(obj, key);
	}];
}

- (instancetype)mapWithKey:(id (^)(id, id))mapBlock
{
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	[self eachWithKey:^(id x, id key) {
		[result setObject:mapBlock(x, key) forKey:key];
	}];
	return result;
}

- (instancetype)filter:(BOOL (^)(id x))filterBlock
{
	NSMutableDictionary *result = [NSMutableDictionary dictionary];
	[self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
		if (!filterBlock(obj)) return;
		result[key] = obj;
	}];
	return [result copy];
}

- (BOOL)isEmpty
{
	return [self count] == 0;
}
@end

@implementation NSObject (Do)
- (instancetype)do:(void (^)(id))block
{
	block(self);
	return self;
}
@end