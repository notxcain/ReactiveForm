//
//  QWAnythingYouWantFactory.h
//  factoryObjects
//
//  Created by Alexander Desyatov on 31.10.13.
//  Copyright (c) 2013 Alexander Desyatov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RFField;
@class RFFieldViewController;
@protocol RFFormPresentationBuilder;

@interface RFFormPresentation : NSObject
+ (instancetype)createWithBlock:(void (^)(id <RFFormPresentationBuilder> builder))buildingBlock;
- (RFFieldViewController *)controllerForField:(RFField *)field;
@end

typedef RFFieldViewController *(^RFFieldViewControllerInstantiator)(RFField *field);

@protocol RFFormPresentationBuilder
- (void)addPredicate:(NSPredicate *)predicate instantiator:(RFFieldViewControllerInstantiator)instantiator;
@end