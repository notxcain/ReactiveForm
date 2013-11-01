//
//  RFBackingManagedObject.h
//  RFKit
//
//  Created by Denis Mikhaylov on 24.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface RFBackingObject : NSManagedObject
+ (NSString *)entityName;
+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;
@end

@interface NSObject (RFBackingManagedObject)
- (id)backingObjectInContext:(NSManagedObjectContext *)context;
@end