#import "RFBackingForm.h"
#import "RFBackingSection.h"
#import "RFBackingField.h"

@interface RFBackingForm ()
@end


@implementation RFBackingForm
@dynamic sections;

+ (NSString *)entityName
{
    return @"Form";
}

- (NSInteger)indexOfSection:(RFBackingSection *)section
{
    return [self.sections indexOfObject:section];
}

- (RFBackingSection *)sectionAtIndex:(NSInteger)index
{
    return (self.sections)[index];
}

- (void)enumerateFieldsUsingBlock:(void (^)(RFBackingField *, NSIndexPath *))block
{
    [self.sections enumerateObjectsUsingBlock:^(RFBackingSection *section, NSUInteger sectionIndex, BOOL *stop) {
       [section enumerateFieldsUsingBlock:^(RFBackingField *field, NSUInteger rowIdx) {
           block(field, [NSIndexPath indexPathForRow:rowIdx inSection:sectionIndex]);
       }];
    }];
}

- (NSFetchedResultsController *)fieldsController
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[RFBackingField entityName]];
    request.predicate = [NSPredicate predicateWithFormat:@"section.form == %@", self];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"section.index" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES]];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                                               managedObjectContext:self.managedObjectContext
                                                                                                 sectionNameKeyPath:@"section.index"
                                                                                                          cacheName:nil];
    return fetchedResultsController;
}

@end
