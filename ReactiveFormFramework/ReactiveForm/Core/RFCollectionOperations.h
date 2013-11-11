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
- (instancetype)filter:(BOOL (^)(id x))filterBlock;
@end

@interface NSOrderedSet (Map)
- (instancetype)map:(id (^)(id x))mapBlock;
- (instancetype)filter:(BOOL (^)(id x))filterBlock;
@end