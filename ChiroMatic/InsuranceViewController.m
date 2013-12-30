//
//  InsuranceViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/22/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "InsuranceViewController.h"

@interface InsuranceViewController ()

@end

@implementation InsuranceViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Insurance Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Insurance* insurance = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = insurance.name;
    cell.detailTextLabel.text = insurance.phone;
    
    return cell;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchRequestWithSharedDocumentForEntityName:@"Insurance" descriptor:@"name"];
}

@end
