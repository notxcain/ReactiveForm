//
//  DMFormField.h
//  DMForms3
//
//  Created by Denis Mikhaylov on 17.03.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFFormElement.h"

@class RACSignal;
@interface RFField : NSObject <RFFormElement>
@property (nonatomic, copy, readonly) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong, readwrite) id value;
@property (nonatomic, assign, getter = isRequired) BOOL required;

+ (instancetype)fieldWithName:(NSString *)name title:(NSString *)title;
- (id)initWithName:(NSString *)name;
- (BOOL)validate:(out NSError **)errorPtr;
- (NSString *)stringValue;
@end