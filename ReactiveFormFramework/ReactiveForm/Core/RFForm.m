//
//  RFForm.m
//  Form
//
//  Created by Denis Mikhaylov on 10.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFForm.h"

#import "RFBackingForm.h"
#import "RFBackingField.h"

#import "RFBackingStructureBuilder.h"
#import "RFField.h"
#import "RFSection.h"
#import <CoreData/CoreData.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveCocoa/RACEXTScope.h>
#import "RFContainer.h"
#import <objc/runtime.h>
#import "RFForm+Private.h"
#import "RFSection+Private.h"

@interface RFForm ()
@property (nonatomic, assign, readwrite, getter = isValid) BOOL valid;
@property (nonatomic, strong, readonly) RFContainer *rootContainer;
@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong, readonly) NSOrderedSet *backingSections;
@property (nonatomic, copy) NSDictionary *visibleFields;
@end

@implementation RFForm
@synthesize managedObjectContext = _managedObjectContext, backingForm = _backingForm, persistentStoreCoordinator = _persistentStoreCoordinator, rootContainer = _rootContainer;

+ (instancetype)form
{
    return [[self alloc] init];
}

- (id)addSectionWithElement:(id<RFFormElement>)formElement
{
    RFSection *section = [RFSection sectionWithFormElement:formElement];
    [self.rootContainer addElement:section];
    return section;
}

- (void)removeSection:(id)section
{
    return [self.rootContainer removeElement:section];
}

- (id)fieldWithName:(NSString *)name
{
    return self.visibleFields[name];
}

- (RFContainer *)rootContainer
{
    if (_rootContainer) return _rootContainer;
    
    _rootContainer = [RFContainer container];
    
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    RAC(self, backingSections) = [[[[_rootContainer visibleElements] map:^(RACSequence *elements) {
        return [elements map:^(id element) {
            return [element backingObjectInContext:managedObjectContext];
        }];
    }] map:^(RACSequence *backingObjects) {
        RFBackingStructureBuilder *builder = [[RFBackingStructureBuilder alloc] init];
        return [backingObjects foldLeftWithStart:builder reduce:^(RFBackingStructureBuilder *builder, RFBackingObject *backingObject) {
            [builder addBackingObject:backingObject];
            return builder;
        }];
    }] map:^(RFBackingStructureBuilder *builder) {
        return [builder sections];
    }];
    
    RAC(self, valid, @NO) = [[[[RACObserve(self, visibleFields) map:^(NSDictionary *fields) {
        return [RACSignal combineLatest:[[fields rac_valueSequence] map:^(RFField *field) {
            return [field validate];
        }]];
    }] switchToLatest] map:^(RACTuple *tuple) {
        return @(![[tuple allObjects] containsObject:@NO]);
    }] distinctUntilChanged];
    
    return _rootContainer;
}

- (void)setBackingSections:(NSOrderedSet *)backingSections
{
    if ([self.backingForm.sections isEqualToOrderedSet:backingSections]) return;
    self.backingForm.sections = backingSections;
    [self.managedObjectContext processPendingChanges];
    [self.managedObjectContext save:NULL];
}

- (RFBackingForm *)backingForm
{
    if (_backingForm) return _backingForm;
    
    _backingForm = [RFBackingForm insertInManagedObjectContext:self.managedObjectContext];
    
    return _backingForm;
}


- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) return _managedObjectContext;
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:self.persistentStoreCoordinator];

    return _managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) return _persistentStoreCoordinator;
    
    NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"RFBackingModel" withExtension:@"momd"]];
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    [_persistentStoreCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL];
    
    return _persistentStoreCoordinator;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ %@", [super description], [self.visibleFields description]];
}
@end