//
//  QWClassWrapper.m
//  factoryObjects
//
//  Created by Alexander Desyatov on 30.10.13.
//  Copyright (c) 2013 Alexander Desyatov. All rights reserved.
//

#import "RFClassWrapper.h"

@interface RFClassWrapper ()
@property (nonatomic, strong, readonly) Class wrappedClass;
@end

@implementation RFClassWrapper 
- (id)initWithClass:(Class)class
{
    self = [super init];
    if (self) {
        _wrappedClass = class;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (NSUInteger)hash
{
    return [self.wrappedClass hash];
}

- (BOOL)isEqual:(id)object
{
    if (object == self) return YES;
    if (!object || ![object isKindOfClass:[self class]]) return NO;
    return [self isEqualToClassWrapper:object];
}

- (BOOL)isEqualToClassWrapper:(RFClassWrapper *)classWrapper
{
    return [self.wrappedClass isEqual:classWrapper.wrappedClass];
}

@end
