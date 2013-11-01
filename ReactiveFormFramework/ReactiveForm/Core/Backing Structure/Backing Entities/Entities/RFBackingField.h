#import "RFBackingObject.h"

@class RFField;
@interface RFBackingField : RFBackingObject
@property (nonatomic, weak) RFField *field;
- (NSInteger)index;
@end
