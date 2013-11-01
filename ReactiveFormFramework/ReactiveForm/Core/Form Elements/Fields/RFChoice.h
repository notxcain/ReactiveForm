//
//  RFChoice.h
//  RFKit
//
//  Created by Denis Mikhaylov on 26.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol RFFormElement;

@protocol RFChoice <NSObject>
- (id)value;
- (NSString *)title;
- (id<RFFormElement>)formElement;
@end

@interface RFChoice : NSObject <RFChoice>
@property (nonatomic, strong, readonly) id value;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, strong, readonly) id <RFFormElement> formElement;
- (instancetype)initWithValue:(id)value title:(NSString *)title formElement:(id<RFFormElement>)formElement;
@end


@protocol RFFormElement;
@interface NSObject (RFChoice)
- (id<RFChoice>)asChoiceWithTitle:(NSString *)title;
- (id<RFChoice>)asChoiceWithTitle:(NSString *)title formElement:(id<RFFormElement>)formElement;
@end