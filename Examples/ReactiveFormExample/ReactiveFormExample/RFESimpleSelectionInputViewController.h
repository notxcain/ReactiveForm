//
//  RFSimpleSelectionInputViewController.h
//  RFKit
//
//  Created by Denis Mikhaylov on 24.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RFESimpleSelectionInputViewControllerDelegate;
@interface RFESimpleSelectionInputViewController : NSObject
@property (nonatomic, copy) NSArray *options;
@property (nonatomic, strong, readonly) UIView *view;
@property (nonatomic, weak) id <RFESimpleSelectionInputViewControllerDelegate> delegate;
@end

@protocol RFESimpleSelectionInputViewControllerDelegate <NSObject>
- (id)selectedOptionForSelectionInputViewController:(RFESimpleSelectionInputViewController *)controller;
- (void)selectionInputViewController:(RFESimpleSelectionInputViewController *)controller didSelectOption:(id)option;
@end


