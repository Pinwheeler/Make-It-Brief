//
//  EmbedDoctorViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/21/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "EmbedDoctorViewController.h"

@interface EmbedDoctorViewController ()
@property (weak, nonatomic) Doctor* currentlySelectedDoctor;
@property (strong, nonatomic) UIPopoverController* popover;

@end

@implementation EmbedDoctorViewController

@synthesize currentlySelectedDoctor = _currentlySelectedDoctor;
@synthesize delegate = _delegate;

- (void) setCurrentSuperobject:(NSManagedObject *)currentSuperobject
{
    if (_currentSuperobject != currentSuperobject) {
        _currentSuperobject = currentSuperobject;
    }
    [self.tableView reloadData];
}

- (void) setDoctorName:(NSString *)name
{
    self.currentlySelectedDoctor.name = name;
}

- (void) setDoctorSignatureData:(NSData *)data
{
    NSLog(@"Changing %@ signature",self.currentlySelectedDoctor.name);
    [self updateCurrentEntityWithValue:data forKey:@"signature"];
    [self.tableView reloadData];
}


- (IBAction)deleteObject:(id)sender
{
    if (self.currentObject) {
        [self.fetchedResultsController.managedObjectContext deleteObject:self.currentObject];
        [self saveData];
        [self.delegate clearTextfieldsAssociatedWithEntityType:[Doctor class]];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Doctor Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    Doctor* doctor = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // If the superobject is a clinic
    if ([self.currentSuperobject isKindOfClass:[Clinic class]]) {
        Clinic* currentClinic = ((Clinic*)self.currentSuperobject);
        
        // Show if the current clinic has the doctor, making a check mark appear if the clinic does have the given doctor
        if ([currentClinic.doctors containsObject:doctor]) {
            //[self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    // If the superobject is an Insurance
    else if ([self.currentSuperobject isKindOfClass:[Insurance class]]) {
        Insurance* insurance = ((Insurance*)self.currentSuperobject);
        
        // Show if the current Ins has the doctor, making a check mark appear if the clinic does have the given doctor
        if ([insurance.doctors containsObject:doctor]) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    else if ([self.currentSuperobject isKindOfClass:[Patient class]])
    {
        Patient* patient = (Patient*)self.currentSuperobject;
        if (patient.doctor == doctor) {
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }

    }
    cell.textLabel.text = doctor.name;
    return cell;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchRequestWithSharedDocumentForEntityName:@"Doctor" descriptor:@"name"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentlySelectedDoctor && self.delegate.specialReturnValue) {
        self.currentlySelectedDoctor.name = self.delegate.specialReturnValue;
    }
    Doctor* doctor = [self.fetchedResultsController objectAtIndexPath:indexPath];
        //First check to see if the doctor is already selected and if so
        if (doctor == self.currentlySelectedDoctor) {
            //Check to see if the superobject is a clinic or an insurance
            //Toggle whether the selected doctor belongs or does not belong to the current clinic
            if ([self.currentSuperobject isKindOfClass:[Clinic class]]) {
                Clinic* clinic = (Clinic*)self.currentSuperobject;
                if ([clinic.doctors containsObject:doctor]) {
                    [clinic removeDoctorsObject:doctor];
                    doctor.clinic = nil;
                    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
                }else
                {
                    [clinic addDoctorsObject:doctor];
                    doctor.clinic = clinic;
                    [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
                }
            }
        }
    if ([self.currentSuperobject isKindOfClass:[Insurance class]]) {
        Insurance* insurance = (Insurance*)self.currentSuperobject;
        [insurance addDoctorsObject:doctor];
        [doctor addInsurancesObject:insurance];
    }
    if ([self.currentSuperobject isKindOfClass:[Patient class]]) {
        Patient* patient = (Patient*)self.currentSuperobject;
        
        //--Check if the doctor is liscensed with the patient's current insurance
        Insurance* insurance = patient.insurance;
        if (![insurance.doctors containsObject:doctor]) {
            // Create error message
            [self createErrorPopupAtView:tableView inView:self.view];
            for (NSIndexPath* indexPath in tableView.indexPathsForSelectedRows) {
                [tableView deselectRowAtIndexPath:indexPath animated:YES];
                [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
            }
            
        }
        else {
            patient.doctor = doctor;
            [doctor addPatientsObject:patient];
        }
    }
        //Otherwise make all edits before selecting the new one
    self.currentlySelectedDoctor = doctor;
    [self.delegate populateFieldsWithDataOfObject:self.currentlySelectedDoctor];
    [self saveData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Doctor* doctor = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([self.currentSuperobject isKindOfClass:[Insurance class]]) {
        Insurance* insurance = (Insurance*)self.currentSuperobject;
        [insurance removeDoctorsObject:doctor];
    }
}

- (void) createErrorPopupAtView:(UIView*)targetView inView:(UIView*)parentView{
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    UIViewController* vc = [storyboard instantiateViewControllerWithIdentifier:@"UnlicensedPopover"];
    self.popover = [[UIPopoverController alloc]initWithContentViewController:vc];
    [self.popover presentPopoverFromRect:targetView.frame inView:parentView permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


@end
