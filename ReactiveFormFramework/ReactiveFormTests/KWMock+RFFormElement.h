//
//  KWMock+RFFormElement.h
//  RFKit
//
//  Created by Denis Mikhaylov on 11.07.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "KWMock.h"

@protocol RFFormElement;
@interface KWMock (RFFormElement)
+ (id <RFFormElement>)mockFormElement;
@end
