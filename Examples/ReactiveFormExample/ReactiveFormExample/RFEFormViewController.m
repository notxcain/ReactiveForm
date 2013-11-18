//
//  ViewController.m
//  ReactiveFormExample
//
//  Created by Alexander Desyatov on 06.11.13.
//  Copyright (c) 2013 ReactiveForm. All rights reserved.
//

#import "RFEFormViewController.h"
#import <ReactiveForm/ReactiveForm.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RFETextFieldController.h"
#import "RFETestFormContentProvider.h"
#import "RFEChoiceFieldController.h"
#import "RFEActionFieldController.h"
#import "RFEFormPresentation.h"

@interface RFEFormViewController ()
@property(nonatomic,strong,readonly) RFFormTableViewDataSource *dataSourceModel;
@end

@implementation RFEFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	
	RFETestFormContentProvider *testFormContentProvider = [RFETestFormContentProvider contentProvider];
	
    RFForm *form = [RFForm formWithFormContentProvider:testFormContentProvider];

    _dataSourceModel = [[RFFormTableViewDataSource alloc] initWithForm:form presentation:[RFFormPresentation formPresentation]];

	
    self.tableView.dataSource = self.dataSourceModel;
    self.tableView.tableFooterView = [[UIView alloc] init];
	self.tableView.backgroundView = nil;
	_dataSourceModel.tableView = self.tableView;
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
