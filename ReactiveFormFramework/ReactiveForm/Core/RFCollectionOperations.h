//
//  RFCollectionOperations.h
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 11/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Map)
- (instancetype)map:(id (^)(id x))mapBlock;
- (instancetype)mapWithIndex:(id (^)(id x, NSUInteger idx))mapBlock;
- (instancetype)filter:(BOOL (^)(id x))filterBlock;
- (instancetype)filterNot:(BOOL (^)(id x))filterBlock;
- (void)each:(void (^)(id x))each;
- (id)foldLeftWithStart:(id)accumulator block:(id (^)(id accumulator, id x))block;
- (instancetype)flatten;
- (BOOL)isEmpty;
- (instancetype)filterNotEmpty;
@end

@interface NSOrderedSet (Map)
- (instancetype)map:(id (^)(id x))mapBlock;
- (instancetype)mapWithIndex:(id (^)(id x, NSUInteger idx))mapBlock;
- (instancetype)filter:(BOOL (^)(id x))filterBlock;
- (instancetype)filterNot:(BOOL (^)(id x))filterBlock;
- (void)each:(void (^)(id x))each;
- (id)foldLeftWithStart:(id)accumulator block:(id (^)(id accumulator, id x))block;
- (BOOL)isEmpty;
@end

@interface NSDictionary (Map)
- (instancetype)map:(id (^)(id x))mapBlock;
- (instancetype)mapWithKey:(id (^)(id x, id key))mapBlock;
- (instancetype)filter:(BOOL (^)(id x))filterBlock;
- (void)eachWithKey:(void (^)(id x, id key))block;
- (BOOL)isEmpty;
@end


@interface NSObject (Do)
- (instancetype)do:(void (^)(id x))block;
@end