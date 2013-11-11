#import "RFBackingObject.h"

@class RFBackingSection;
@class RFBackingField;
@interface RFBackingForm : RFBackingObject
@property (nonatomic, strong) NSOrderedSet *sections;
- (void)enumerateFieldsUsingBlock:(void (^)(RFBackingField *field, NSIndexPath *indexPath))block;
- (NSInteger)indexOfSection:(RFBackingSection *)section;
- (RFBackingSection *)sectionAtIndex:(NSInteger)index;
- (NSFetchedResultsController *)fieldsController;
- (RFBackingField *)fieldAtIndexPath:(NSIndexPath *)indexPath;
@end
