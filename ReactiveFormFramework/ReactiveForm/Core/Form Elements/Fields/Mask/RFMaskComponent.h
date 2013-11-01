//
//  MaskComponent.h
//  FieldAlgo
//
//  Created by Denis Mikhaylov on 18.12.12.
//  Copyright (c) 2012 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RFMaskComponent <NSObject>
- (unichar)staticCharacter;
- (BOOL)validateCharachter:(unichar)character;
@end

@interface RFMaskComponent : NSObject <RFMaskComponent>
+ (NSArray *)parseMaskPattern:(NSString *)pattern mandatoryLength:(out NSUInteger *)mandatoryLength;
+ (instancetype)maskComponentWithStringComponent:(NSString *)stringComponent;
@end