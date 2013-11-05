//
//  RFFieldController.h
//  RFKit
//
//  Created by Denis Mikhaylov on 06/08/13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface RFFieldViewController : NSObject
@property (nonatomic, strong) UITableViewCell *view;
@property (nonatomic, assign) UIViewController *presentationController;

- (void)loadView;
- (void)viewDidLoad;
- (BOOL)isViewLoaded;
@end
