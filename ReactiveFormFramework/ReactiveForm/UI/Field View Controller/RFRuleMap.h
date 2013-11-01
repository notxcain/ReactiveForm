//
//  AnythingYouWantFactory.h
//  factoryObjects
//
//  Created by Alexander Desyatov on 30.10.13.
//  Copyright (c) 2013 Alexander Desyatov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFRuleMap : NSObject
- (id)initWithRules:(NSDictionary *)rules identifierKeyPath:(NSString *)identifierKeyPath;
- (id)objectForObject:(id)object;
@end
