//
//  RFFormElement.h
//  Form
//
//  Created by Denis Mikhaylov on 10.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSignal;
@protocol RFFormElement <NSObject>
/// Returns a signal sending array of currently visible fields
- (RACSignal *)visibleFields;
@end
