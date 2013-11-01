//
//  RFForm.h
//  RFKit
//
//  Created by Denis Mikhaylov on 10.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RFField;
@protocol RFFormElement;
@interface RFForm : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, readonly, getter = isValid) BOOL valid;

+ (instancetype)form;

- (void)prepareForm;
- (id)addSectionWithElement:(id <RFFormElement>)formElement;
- (void)removeSection:(id)section;
@end