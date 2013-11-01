//
//  RFFieldController.h
//  RFKit
//
//  Created by Denis Mikhaylov on 06/08/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
@class RFField;
@class RFFieldView;
@interface RFFieldViewController : NSObject
@property (nonatomic, strong, readonly) RFFieldView *view;
- (id)initWithObject:(id)object presenter:(UIViewController *)presenter;
- (void)select;
@end
