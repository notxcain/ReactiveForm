//
//  QWAnythingYouWantFactory.h
//  factoryObjects
//
//  Created by Alexander Desyatov on 31.10.13.
//  Copyright (c) 2013 Alexander Desyatov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFField.h"

@interface RFFieldControllerFactory : NSObject

/**
* Initializes a Factory.
*      @param rules Dictionary, key - object or string, values - blocks:
*                   ^id (id object) {
*                       return newObject;
*                   };
*
*/

- (id)initWithRules:(NSDictionary *)rules;
- (id)createObjectWithObject:(id)object;
@end

@interface RFField (Rule)
+ (id <NSCopying>)classRule;
+ (id <NSCopying>)ruleForName:(NSString *)fieldName;
@end