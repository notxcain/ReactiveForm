//
//  RFElementContainer.h
//  Form
//
//  Created by Denis Mikhaylov on 10.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFFormElement.h"

@class RACSignal;
@interface RFContainer : NSObject <RFFormElement>
+ (instancetype)container;
+ (instancetype)containerWithElements:(NSArray *)elements;
- (void)addElementsFromArray:(NSArray *)array;
- (void)addElement:(id<RFFormElement>)element;
- (void)removeElement:(id<RFFormElement>)element;
@end

@interface NSArray (ConstantContainer) <RFFormElement>

@end