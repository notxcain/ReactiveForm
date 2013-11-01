#import "RFBackingField.h"
#import "RFBackingSection.h"
#import "RFField.h"

@interface RFBackingField ()
@property (nonatomic, strong) RFBackingSection *section;
@end

@implementation RFBackingField
@dynamic section;

@synthesize field = _field;


+ (NSString *)entityName
{
    return @"Field";
}

- (NSInteger)index
{
    return [self.section indexOfField:self];
}
@end
