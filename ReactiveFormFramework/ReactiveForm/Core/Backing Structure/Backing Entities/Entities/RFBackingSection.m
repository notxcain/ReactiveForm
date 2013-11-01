#import "RFBackingSection.h"
#import "RFBackingField.h"
#import "RFBackingForm.h"

@interface RFBackingSection ()

@end


@implementation RFBackingSection
@dynamic fields, form;

+ (NSString *)entityName
{
    return @"Section";
}

- (void)addField:(RFBackingField *)field;
{
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithOrderedSet:self.fields];
    [set addObject:field];
    self.fields = set;
}

- (NSInteger)indexOfField:(RFBackingField *)field
{
    return [self.fields indexOfObject:field];
}

- (NSComparisonResult)compare:(RFBackingSection *)section
{
    return [@([self.form indexOfSection:self]) compare:@([self.form indexOfSection:section])];
}

- (NSInteger)index
{
    return [self.form indexOfSection:self];
}

- (void)enumerateFieldsUsingBlock:(void (^)(RFBackingField *, NSUInteger idx))block
{
    [self.fields enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj, idx);
    }];
}

@end
