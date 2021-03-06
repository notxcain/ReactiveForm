//
//  ReactiveFormTests.m
//  ReactiveFormTests
//
//  Created by Denis Mikhaylov on 01/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Kiwi/Kiwi.h>
#import "NSOrderedSet+Diff.h"

SPEC_BEGIN(RFOrderedSetChangesSpec)
describe(@"RFOrderedSetChangesSpec", ^{
	context(@"when objects are added", ^{
		it(@"works", ^{
			NSArray *oldArray = @[@"account", @"date", @"phoneNumber"];
			NSArray *newArray = @[@"account", @"address", @"date", @"phoneNumber", @"name"];
			id diff = [[NSOrderedSet orderedSetWithArray:newArray] differenceWithOrderedSet:[NSOrderedSet orderedSetWithArray:oldArray]];
			NSDictionary *addedObjects = [diff insertedObjects];
			
			[[addedObjects shouldNot] beEmpty];
			[[addedObjects should] equal:@{@1 : @"address", @4 : @"name"}];
		});
	});
	context(@"when objects are deleted", ^{
		it(@"works", ^{
			NSArray *oldArray = @[@"account", @"address", @"date", @"phoneNumber", @"name"];
			NSArray *newArray = @[@"account", @"date", @"phoneNumber"];
			id diff = [[NSOrderedSet orderedSetWithArray:newArray] differenceWithOrderedSet:[NSOrderedSet orderedSetWithArray:oldArray]];
			NSDictionary *deletedObjects = [diff removedObjects];
			[[deletedObjects shouldNot] beEmpty];
			[[deletedObjects should] equal:@{@1 : @"address", @4 : @"name"}];
		});
	});
	
	context(@"when objects are added and deleted", ^{
		it(@"works", ^{
			NSArray *oldArray = @[@"account", @"date", @"phoneNumber", @"country"];
			NSArray *newArray = @[@"account", @"address", @"country", @"phoneNumber", @"name"];
			id diff = [[NSOrderedSet orderedSetWithArray:newArray] differenceWithOrderedSet:[NSOrderedSet orderedSetWithArray:oldArray]];
			
			NSDictionary *addedObjects = [diff insertedObjects];
			[[addedObjects shouldNot] beEmpty];
			[[addedObjects should] equal:@{@1 : @"address", @4 : @"name"}];
			
			NSDictionary *deletedObjects = [diff removedObjects];
			[[deletedObjects shouldNot] beEmpty];
			[[deletedObjects should] equal:@{@1 : @"date"}];
		});
	});
});
SPEC_END