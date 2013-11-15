//
//  ViewController.m
//  ReactiveFormExample
//
//  Created by Alexander Desyatov on 06.11.13.
//  Copyright (c) 2013 ReactiveForm. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveForm/RFForm.h>
#import <ReactiveForm/RFFormTableViewDataSource.h>
#import <ReactiveForm/RFFormPresentation.h>
#import <ReactiveForm/RFTextField.h>
#import <ReactiveForm/RFFieldController.h>
#import <ReactiveForm/RFContainer.h>
#import <ReactiveForm/RFFormContentProvider.h>
#import "RFETextFieldController.h"

@interface ViewController ()
@property(nonatomic,strong,readonly) UITableView *tableView;
@property(nonatomic,strong,readonly) RFFormTableViewDataSource *dataSourceModel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RFTextField *textField = [RFTextField fieldWithName:@"textField" title:@"title"];
    RFContainer *container = [RFContainer container];
    [container addElement:textField];

    RFFormPresentation *formPresentation = [RFFormPresentation createWithBlock:^(id<RFFormPresentationBuilder> builder) {
        [builder addMatcher:[RFTextField class] instantiator:^RFFieldController *(RFField *field) {
			RFETextFieldController *controller = [[RFETextFieldController alloc] init];
			controller.textField = field;
            return controller;
        }];
    }];
    
	RFMutableFormContentProvider *provider = [RFMutableFormContentProvider contentProvider];
	[provider addSectionWithElement:container];
	
    RFForm *form = [RFForm formWithFormContentProvider:provider];

    _dataSourceModel = [[RFFormTableViewDataSource alloc] initWithForm:form presentation:formPresentation];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.dataSource = self.dataSourceModel;
    self.tableView.tableFooterView = [[UIView alloc] init];
	
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
