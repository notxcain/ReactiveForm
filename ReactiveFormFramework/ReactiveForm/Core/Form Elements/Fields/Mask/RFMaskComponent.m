//
//  RFMaskComponent.m
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 01/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFMaskComponent.h"

@interface RFCharachterSetMaskComponent : RFMaskComponent
- (id)initWithCharachterSet:(NSCharacterSet *)charahcterSet;
@end

@interface RFStaticMaskComponent : RFMaskComponent
- (id)initWithString:(NSString *)string;
@end

@implementation RFMaskComponent
+ (NSArray *)parseMaskPattern:(NSString *)pattern mandatoryLength:(out NSUInteger *)mandatoryLength
{
    NSMutableArray *components = [[NSMutableArray alloc] init];
    NSUInteger length = [pattern length];
    NSUInteger adequateLength = [pattern length];
    for (NSUInteger idx = 0; idx < length; idx++) {
        NSString *patternComponent = [NSString stringWithFormat:@"%C", [pattern characterAtIndex:idx]];
        if ([patternComponent isEqualToString:@"?"]) {
            adequateLength = idx;
        } else {
            [components addObject:[RFMaskComponent maskComponentWithStringComponent:patternComponent]];
        }
    }
    if (mandatoryLength) {
        *mandatoryLength = adequateLength;
    }
    return components;
}

+ (instancetype)maskComponentWithStringComponent:(NSString *)stringComponent
{
    static NSDictionary *charachterSets = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        charachterSets = @{@"d" : [NSCharacterSet decimalDigitCharacterSet], @"w" : [NSCharacterSet letterCharacterSet], @"*" : [NSCharacterSet alphanumericCharacterSet]};
    });
    NSCharacterSet *charachterSet = charachterSets[stringComponent];
    if (charachterSet) {
        return [[RFCharachterSetMaskComponent alloc] initWithCharachterSet:charachterSet];
    }
    
    return [[RFStaticMaskComponent alloc] initWithString:stringComponent];
}

- (id)init
{
    NSAssert(![self isMemberOfClass:[RFMaskComponent class]], @"Use - [RFMaskComponent maskComponentWithStringComponent:] instead");
    return [super init];
}

- (unichar)staticCharacter
{
    return 0;
}

- (BOOL)validateCharachter:(unichar)character
{
    return NO;
}
@end

@interface RFCharachterSetMaskComponent ()
@property (nonatomic, strong, readonly) NSCharacterSet *charachterSet;
@end

@implementation RFCharachterSetMaskComponent
- (id)initWithCharachterSet:(NSCharacterSet *)charachterSet
{
    self = [super init];
    if (self) {
        _charachterSet = charachterSet;
    }
    return self;
}

- (BOOL)validateCharachter:(unichar)character
{
    return [self.charachterSet characterIsMember:character];
}

- (unichar)staticCharacter
{
    return 0;
}
@end

@interface RFStaticMaskComponent ()
@property (nonatomic, copy, readonly) NSString *string;
@end

@implementation RFStaticMaskComponent
- (id)initWithString:(NSString *)string
{
    NSParameterAssert([string length] == 1);
    
    self = [super init];
    if (self) {
        _string = [string copy];
    }
    return self;
}

- (BOOL)validateCharachter:(unichar)character
{
    return [self staticCharacter] == character;
}

- (unichar)staticCharacter
{
    return [self.string characterAtIndex:0];
}
@end