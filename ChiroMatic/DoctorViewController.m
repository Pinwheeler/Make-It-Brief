//
//  DoctorViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/21/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "DoctorViewController.h"

@interface DoctorViewController ()

@end

@implementation DoctorViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Doctor Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Doctor* doctor = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = doctor.name;
    
    return cell;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchRequestWithSharedDocumentForEntityName:@"Doctor" descriptor:@"name"];
}

@end
