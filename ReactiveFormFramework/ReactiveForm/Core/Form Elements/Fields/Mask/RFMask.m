//
//  RFInputMask.m
//  Form
//
//  Created by Denis Mikhaylov on 20.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFMask.h"
#import "RFMaskComponent.h"

@interface RFMask ()
@property (nonatomic, strong) NSArray *components;
@property (nonatomic, assign) NSUInteger adequateLength;
@end


@implementation RFMask
+ (instancetype)maskWithPattern:(NSString *)pattern
{
    RFMask *mask = [[RFMask alloc] init];
    mask.pattern = pattern;
    return mask;
}

- (void)setPattern:(NSString *)pattern
{
    if ([_pattern isEqualToString:pattern]) return;
    
    _pattern = [pattern copy];
    [self parsePattern];
}

- (void)parsePattern
{
    NSUInteger mandatoryLength = [self.pattern length];
    self.components = [RFMaskComponent parseMaskPattern:self.pattern mandatoryLength:&mandatoryLength];
    self.adequateLength = mandatoryLength;
}

- (BOOL)validateString:(NSString *)string
{
    NSString *formattedString = string;
    NSUInteger subjectLength = [formattedString length];
    for (NSUInteger componentIdx = 0; componentIdx < [self.components count]; componentIdx++)
    {
        if (componentIdx >= subjectLength) return (componentIdx >= self.adequateLength);
        
        id <RFMaskComponent> component = [self maskComponentAtIndex:componentIdx];
        
        if (![component validateCharachter:[formattedString characterAtIndex:componentIdx]]) return NO;
    }
    
    return YES;
}

- (NSString *)formatString:(NSString *)string
{
    if ([self.components count] == 0) return string;
    
    NSMutableString *result = [NSMutableString string];
    NSUInteger stringCharacterIndex = 0;
    NSUInteger componentIndex = 0;
    NSUInteger numberOfComponents = [self.components count];
    
    
    while (stringCharacterIndex < [string length] && componentIndex != numberOfComponents)
    {
        unichar stringCharacter = [string characterAtIndex:stringCharacterIndex];
        
        id <RFMaskComponent> maskComponent = [self maskComponentAtIndex:componentIndex];
        unichar staticCharacter = [maskComponent staticCharacter];
        
        if (staticCharacter)
        {
            [result appendFormat:@"%C", staticCharacter];
            componentIndex++;
            if (staticCharacter == stringCharacter)
            {
                stringCharacterIndex++;
            }
        }
        else if ([maskComponent validateCharachter:stringCharacter])
        {
            [result appendFormat:@"%C", stringCharacter];
            componentIndex++;
            stringCharacterIndex++;
        }
        else
        {
            stringCharacterIndex++;
        }
    }
    
    [result appendString:[self staticCharactersFromIndex:componentIndex]];
    
    return result;
}

- (NSString *)staticCharactersFromIndex:(NSUInteger)index
{
    NSMutableString *result = [NSMutableString string];
    while (index < [self.components count])
    {
        id <RFMaskComponent> maskComponent = [self maskComponentAtIndex:index];
        unichar staticCharacter = [maskComponent staticCharacter];
        if (!staticCharacter) break;
        [result appendFormat:@"%C", staticCharacter];
        index++;
    }
    return result;
}

- (id <RFMaskComponent>)maskComponentAtIndex:(NSUInteger)index
{
    return [self.components objectAtIndex:index];
}

- (NSUInteger)numberOfStaticComponentsToTheLeftFromIndex:(NSUInteger)index
{        
    NSArray *components = self.components.reverseObjectEnumerator.allObjects;
    NSUInteger startIndex = [self.components count] - index;
    
    NSUInteger result = 0;
    for (NSUInteger idx = startIndex; idx < [components count]; idx++) {
        if (![components[idx] staticCharacter]) break;
        result++;
    }
    return result;
}

- (NSString *)stringByReplacingSelectedRange:(NSRange)range ofString:(NSString *)string withString:(NSString *)replacement caretPosition:(out NSUInteger *)caretPosition
{
    NSRange adjustedRange = range;
    if ([replacement length] == 0) {
        NSUInteger numberOfStaticSymbols = [self numberOfStaticComponentsToTheLeftFromIndex:adjustedRange.location + adjustedRange.length];
        if (NSEqualRanges(range, NSMakeRange(0, numberOfStaticSymbols))) {
            adjustedRange.location = numberOfStaticSymbols;
            adjustedRange.length = 0;
        } else {
            adjustedRange.location -=numberOfStaticSymbols;
            adjustedRange.length += numberOfStaticSymbols;
        }
    }
    NSUInteger cursorPosition = adjustedRange.location;
    NSUInteger cursorIncrement = [replacement length] == 0 ? 0 : 1;
    
    NSMutableString *result = [NSMutableString stringWithString:string];
    
    [result replaceCharactersInRange:adjustedRange withString:@""];
    
    NSUInteger replacementIdx = 0;
    NSUInteger componentIdx = adjustedRange.location;
    while (componentIdx < [self.components count]) {
        id <RFMaskComponent> maskComponent = [self maskComponentAtIndex:componentIdx];
        
        if ([maskComponent staticCharacter]) {
            [result replaceCharactersInRange:NSMakeRange(componentIdx, 0) withString:[NSString stringWithFormat:@"%C", [maskComponent staticCharacter]]];
            if (componentIdx < [replacement length] && [replacement characterAtIndex:componentIdx] == [maskComponent staticCharacter]) {
                replacementIdx++;
            }
            componentIdx++;
            cursorPosition += cursorIncrement;
            continue;
        }
        
        if (replacementIdx >= [replacement length]) break;
        
        if ([maskComponent validateCharachter:[replacement characterAtIndex:replacementIdx]]) {
            [result replaceCharactersInRange:NSMakeRange(componentIdx, 0) withString:[NSString stringWithFormat:@"%C", [replacement characterAtIndex:replacementIdx]]];
            cursorPosition += cursorIncrement;
            componentIdx++;
            replacementIdx++;
        } else {
            replacementIdx++;
        }
    }
    NSString *formattedResult = [self formatString:result];
    
    *caretPosition = cursorPosition;
    
    return formattedResult;
}

- (UIKeyboardType)keyboardType
{
    if ([self.pattern rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"w*"]].location == NSNotFound) {
        return UIKeyboardTypeNumberPad;
    }
    
    return UIKeyboardTypeDefault;
}
@end
