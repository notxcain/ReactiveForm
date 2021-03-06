//
//  RFFormTableViewDataSource.h
//  ReactiveForm
//
//  Created by Denis Mikhaylov on 05/11/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class RFFormPresentation;
@class RFForm;

@interface RFFormTableViewDataSource : NSObject <UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
- (id)initWithForm:(RFForm *)form presentation:(RFFormPresentation *)presentation;
@end
