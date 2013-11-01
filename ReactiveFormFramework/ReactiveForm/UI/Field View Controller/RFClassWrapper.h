//
//  QWClassWrapper.h
//  factoryObjects
//
//  Created by Alexander Desyatov on 30.10.13.
//  Copyright (c) 2013 Alexander Desyatov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFClassWrapper : NSObject <NSCopying>
- (id)initWithClass:(Class)class;
@end
