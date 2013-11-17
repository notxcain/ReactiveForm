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

@interface RFEFormViewController ()
@property(nonatomic,strong,readonly) RFFormTableViewDataSource *dataSourceModel;
@end

@implementation RFEFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RFFormPresentation *formPresentation = [RFFormPresentation createWithBlock:^(id<RFFormPresentationBuilder> builder) {
        [builder addMatcher:[RFTextField class] instantiator:^(RFTextField *field) {
			RFETextFieldController *controller = [[RFETextFieldController alloc] init];
			controller.field = field;
            return controller;
        }];
		[builder addMatcher:[RFChoiceField class] instantiator:^(RFChoiceField *field) {
			RFEChoiceFieldController *controller = [[RFEChoiceFieldController alloc] init];
			controller.field = field;
            return controller;
        }];
		[builder addMatcher:[RFActionField class] instantiator:^(RFActionField *field) {
			RFEActionFieldController *controller = [[RFEActionFieldController alloc] init];
			controller.field = field;
            return controller;
        }];
    }];
	
	RFETestFormContentProvider *testFormContentProvider = [RFETestFormContentProvider contentProvider];
	
    RFForm *form = [RFForm formWithFormContentProvider:testFormContentProvider];

    _dataSourceModel = [[RFFormTableViewDataSource alloc] initWithForm:form presentation:formPresentation];

	
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
