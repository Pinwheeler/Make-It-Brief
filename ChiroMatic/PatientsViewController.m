//
//  PatientsViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/18/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "PatientsViewController.h"

@interface PatientsViewController ()

@end

@implementation PatientsViewController



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Patient Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Patient* patient = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = patient.name;
    cell.detailTextLabel.text = patient.fileNumber;
    
    return cell;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchRequestWithSharedDocumentForEntityName:@"Patient" descriptor:@"name"];
}

@end
