//
//  RFFieldRule.m
//  RFKit
//
//  Created by Denis Mikhaylov on 08/08/13.
//  Copyright (c) 2013 Denis Mikhailov. All rights reserved.
//

#import "RFRule.h"

@interface RFRule ()
@property (nonatomic, copy, readonly) RFInstantiator instantiator;
@property (nonatomic, strong, readonly) Class fieldClass;
@property (nonatomic, copy, readonly) NSArray *fieldNames;
@end

@implementation RFRule
- (id)initWithFieldClass:(Class)fieldClass fieldNames:(NSArray *)fieldNames instantiator:(RFInstantiator)instantiator
{
    self = [super init];
    if (self) {
        _fieldClass = fieldClass;
        _fieldNames = [fieldNames copy];
        _instantiator = [instantiator copy];
    }
    return self;
}

- (id)createFieldViewControllerForField:(RFField *)field
{
    return self.instantiator(field);
}

- (NSInteger)matchLevelForField:(RFField *)field
{
    NSInteger result = 0;
    if ([field isMemberOfClass:self.fieldClass]) {
        result++;
        if ([self.fieldNames containsObject:field.name]) {
            result += 2;
        } else {
            result -= 1;
        }
    }
    NSLog(@"Rule %@ %@ field %@ %@ match level: %d", self.fieldClass, self.fieldNames, [field class], [field name], result);
    return result;
}
@end
