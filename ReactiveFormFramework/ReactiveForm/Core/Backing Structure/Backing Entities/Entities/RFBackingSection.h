
#import "RFBackingObject.h"

@class RFBackingField, RFBackingForm;
@interface RFBackingSection : RFBackingObject
@property (nonatomic, strong) RFBackingForm *form;
@property (nonatomic, strong) NSOrderedSet *fields;

- (void)enumerateFieldsUsingBlock:(void (^)(RFBackingField *field, NSUInteger idx))block;
- (NSInteger)indexOfField:(RFBackingField *)field;
- (NSComparisonResult)compare:(RFBackingSection *)section;
- (NSInteger)index;
@end
