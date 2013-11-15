//
//  RFSimpleSelectionInputViewController.m
//  RFKit
//
//  Created by Denis Mikhaylov on 24.06.13.
//  Copyright (c) 2013 Denis Mikhaylov. All rights reserved.
//

#import "RFESimpleSelectionInputViewController.h"

@interface RFESimpleSelectionInputViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong, readonly) UITableView *tableView;
@end

@implementation RFESimpleSelectionInputViewController

- (id)init
{
    self = [super init];
    if (self) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 280.0f) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithWhite:0.276 alpha:0.920];
        _tableView.separatorColor = [UIColor colorWithWhite:0.128 alpha:1.000];
        _tableView.tableFooterView = [UIView new];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        
    }
    return self;
}

- (UIView *)view
{
    return self.tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.options count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor colorWithWhite:0.276 alpha:0.920];
    }
    cell.textLabel.text = [self.options[indexPath.row] title];
    return cell;
}

- (void)setOptions:(NSArray *)options
{
    _options = [options copy];
    [self.tableView reloadData];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectionInputViewController:self didSelectOption:self.options[indexPath.row]];
}
@end
