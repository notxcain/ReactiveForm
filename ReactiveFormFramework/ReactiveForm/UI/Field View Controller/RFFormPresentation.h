//
//  QWAnythingYouWantFactory.h
//  factoryObjects
//
//  Created by Alexander Desyatov on 31.10.13.
//  Copyright (c) 2013 Alexander Desyatov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RFField;
@class RFFieldController;
@protocol RFFormPresentationBuilder;

@interface RFFormPresentation : NSObject
+ (instancetype)createWithBlock:(void (^)(id <RFFormPresentationBuilder> builder))buildingBlock;
- (RFFieldController *)controllerForField:(RFField *)field;
@end

typedef RFFieldController *(^RFFieldViewControllerInstantiator)(RFField *field);

@protocol RFFormPresentationBuilder
- (void)addMatcher:(id)matcher instantiator:(RFFieldViewControllerInstantiator)instantiator;
@end