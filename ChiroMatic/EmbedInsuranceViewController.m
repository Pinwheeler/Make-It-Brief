//
//  EmbedInsuranceViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/23/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "EmbedInsuranceViewController.h"

@interface EmbedInsuranceViewController ()

@end

@implementation EmbedInsuranceViewController

@synthesize delegate = _delegate;

- (void) setCurrentSuperobject:(NSManagedObject *)currentSuperobject
{
    if (_currentSuperobject != currentSuperobject) {
        _currentSuperobject = currentSuperobject;
    }
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Insurance Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    Insurance* insurance = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Patient* currentPatient;
    if ([self.currentSuperobject isKindOfClass:[Patient class]]) {
        currentPatient = (Patient*)self.currentSuperobject;
    }
    if (currentPatient.insurance == insurance) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    cell.textLabel.text = insurance.name;
    return cell;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchRequestWithSharedDocumentForEntityName:@"Insurance" descriptor:@"name"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Insurance* insurance = [self.fetchedResultsController objectAtIndexPath:indexPath];
    Patient* currentPatient;
    if ([self.currentSuperobject isKindOfClass:[Patient class]]) {
        currentPatient = (Patient*)self.currentSuperobject;
    }
    currentPatient.insurance = insurance;
    [insurance addPatientsObject:currentPatient];
    
    [self saveData];
}


@end
