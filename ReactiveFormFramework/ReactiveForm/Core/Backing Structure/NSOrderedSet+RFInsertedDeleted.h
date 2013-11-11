//
//  NSOrderedSet+RFInsertedDeleted.h
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 11/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RFOrderedSetDifference <NSObject>
- (NSArray *)removedObjects;
- (NSArray *)insertedObjects;
@end

@interface NSOrderedSet (RFInsertedDeleted)
- (id <RFOrderedSetDifference>)differenceWithOrderedSet:(NSOrderedSet *)previousOrderedSet;
@end
