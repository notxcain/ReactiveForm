//
//  RFSectionsBuilder.m
//  Form
//
//  Created by Denis Mikhaylov on 18.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFBackingStructureBuilder.h"
#import "RFBackingSection.h"
#import "RFBackingField.h"
#import "RFField.h"

@interface RFBackingObject (RFBackingStructureBuilder)
- (void)acceptBuilder:(RFBackingStructureBuilder *)builder;
@end

@interface RFBackingStructureBuilder ()
@property (nonatomic, strong) NSMutableArray *mutableSections;
@property (nonatomic, strong) NSMutableDictionary *mutableNameMap;
@property (nonatomic, strong) RFBackingSection *currentSection;
@property (nonatomic, strong) NSMutableArray *fields;
@end

@implementation RFBackingStructureBuilder
- (id)init
{
    self = [super init];
    if (self) {
        [self prepare];
    }
    return self;
}

- (void)prepare
{
    self.mutableNameMap = [NSMutableDictionary dictionary];
    self.mutableSections = [NSMutableArray array];
}

- (void)addBackingObject:(RFBackingObject *)backingObject
{
    [backingObject acceptBuilder:self];
}

- (void)addSection:(RFBackingSection *)section
{
    [self finishSection];
    [self setCurrentSection:section];
}

- (void)finishSection
{
    if ([self.fields count]) {
        [self.currentSection setFields:[NSOrderedSet orderedSetWithArray:self.fields]];
        [self.mutableSections addObject:self.currentSection];
    } else {
        self.currentSection.form = nil;
    }
}

- (void)setCurrentSection:(RFBackingSection *)currentSection
{
    _currentSection = currentSection;
    self.fields = [NSMutableArray array];
}

- (void)addField:(RFBackingField *)backingField
{
    RFField *field = backingField.field;
    
    [self addFieldToMap:field];
    [self.fields addObject:backingField];
}

- (void)addFieldToMap:(RFField *)field
{
    NSAssert(self.mutableNameMap[field.name] == nil, @"Form inconsistency, field with name '%@' already exists", [field name]);
    self.mutableNameMap[field.name] = field;
}

- (NSOrderedSet *)sections
{
    [self finishSection];
    return [NSOrderedSet orderedSetWithArray:self.mutableSections];
}

- (NSDictionary *)nameMap
{
    return [self.mutableNameMap copy];
}
@end

@implementation RFBackingSection (RFBackingStructureBuilder)
- (void)acceptBuilder:(RFBackingStructureBuilder *)builder
{
    [builder addSection:self];
}
@end

@implementation RFBackingField (RFBackingStructureBuilder)
- (void)acceptBuilder:(RFBackingStructureBuilder *)builder
{
    [builder addField:self];
}
@end
