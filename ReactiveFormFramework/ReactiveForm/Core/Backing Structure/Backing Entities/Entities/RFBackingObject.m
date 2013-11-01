//
//  RFBackingManagedObject.m
//  RFKit
//
//  Created by Denis Mikhaylov on 24.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFBackingObject.h"
#import "RFBackingSection.h"
#import "RFBackingField.h"
#import "RFSection.h"
#import "RFField.h"

#import <objc/runtime.h>

@implementation RFBackingObject
+ (NSString *)entityName
{
    RFAssertShouldBeOverriden();
    return nil;
}

+ (instancetype)insertInManagedObjectContext:(NSManagedObjectContext *)managedObjectContext
{
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:managedObjectContext];
}
@end

@interface NSObject (RFBackingObject_Private)
@property (nonatomic, strong) NSManagedObject *backingObject;
- (NSManagedObject *)createBackingObjectInContext:(NSManagedObjectContext *)context;
@end

static const char *kRFBackingObject = "kRFBackingObject";

@implementation NSObject (RFBackingObject)
- (id)backingObjectInContext:(NSManagedObjectContext *)context
{
    NSManagedObject *backingObject = self.backingObject;
    
    if (backingObject.managedObjectContext == context) return backingObject;
    
    if (backingObject) {
        [context deleteObject:backingObject];
    }
    
    backingObject = [self createBackingObjectInContext:context];
    self.backingObject = backingObject;
    return backingObject;
}

- (NSManagedObject *)createBackingObjectInContext:(NSManagedObjectContext *)context
{
    NSAssert(NO, @"Undefined backing object for %@", self);
    return nil;
}

- (void)setBackingObject:(id)backingObject
{
    objc_setAssociatedObject(self, kRFBackingObject, backingObject, OBJC_ASSOCIATION_RETAIN);
}

- (id)backingObject
{
    return objc_getAssociatedObject(self, kRFBackingObject);
}
@end

@implementation RFSection (RFBackingObject_Private)
- (NSManagedObject *)createBackingObjectInContext:(NSManagedObjectContext *)context
{
    return [RFBackingSection insertInManagedObjectContext:context];
}
@end

@implementation RFField (RFBackingObject_Private)
- (NSManagedObject *)createBackingObjectInContext:(NSManagedObjectContext *)context
{
    RFBackingField *backingField = [RFBackingField insertInManagedObjectContext:context];
    backingField.field = self;
    return backingField;
}

@end