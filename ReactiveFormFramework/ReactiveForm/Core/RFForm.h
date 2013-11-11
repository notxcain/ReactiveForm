//
//  RFForm.h
//  RFKit
//
//  Created by Denis Mikhaylov on 10.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RFFormElement;
@protocol RFFormContent;
@class RACSignal;
@class RFField;

@interface RFForm : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign, readonly, getter = isValid) BOOL valid;
+ (instancetype)formWithBuildingBlock:(void (^)(id <RFFormContent> builder))buildingBlock;
- (id)initWithBuildingBlock:(void (^)(id <RFFormContent> builder))buildingBlock;
- (RACSignal *)changes;
- (RFField *)fieldAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForField:(RFField *)field;
- (NSUInteger)numberOfSections;
- (NSUInteger)numberOfFieldsInSection:(NSUInteger)section;
@end

@protocol RFFormContent <NSObject>
- (id)addSectionWithElement:(id <RFFormElement>)formElement;
- (void)removeSection:(id)section;
@end
