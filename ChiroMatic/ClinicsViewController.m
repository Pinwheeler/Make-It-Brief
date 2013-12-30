//
//  ClinicsViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/19/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "ClinicsViewController.h"

@interface ClinicsViewController ()

@end

@implementation ClinicsViewController


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Clinic Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Clinic* clinic = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = clinic.name;
    cell.detailTextLabel.text = clinic.phone;
    
    return cell;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchRequestWithSharedDocumentForEntityName:@"Clinic" descriptor:@"name"];
}


@end
