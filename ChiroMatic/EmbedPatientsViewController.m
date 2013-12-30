//
//  EmbedPatientsViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 4/4/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "EmbedPatientsViewController.h"

@interface EmbedPatientsViewController ()

@end

@implementation EmbedPatientsViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Patient Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    Patient* patient = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    
    cell.textLabel.text = patient.name;
    cell.detailTextLabel.text = patient.fileNumber;
    
    if ([self.currentSuperobject isKindOfClass:[Exam class]]) {
        Exam* currentExam = (Exam*)self.currentSuperobject;
        if (currentExam.patient == patient) {
            [cell setSelected:YES];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
        else
        {
            [cell setSelected:NO];
            [cell setAccessoryType:UITableViewCellAccessoryNone];
        }
    }
    
    return cell;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self setupFetchRequestWithSharedDocumentForEntityName:@"Patient" descriptor:@"name"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentSuperobject) {
        Patient* patient = [self.fetchedResultsController objectAtIndexPath:indexPath];
        Exam* currentExam;
        if ([self.currentSuperobject isKindOfClass:[Exam class]]) {
            currentExam = (Exam*)self.currentSuperobject;
        
        
        // Remove any exams associated with the patient that share the same name with the current exam
        // The goal of this is to prevent adding any duplicate exams.
            NSMutableSet* removalSet = [NSMutableSet setWithCapacity:0];
            for (Exam* patientExam in patient.exams) {
                if ([patientExam.name isEqualToString:currentExam.name])
                    [removalSet addObject:patientExam];
                    //[patient removeExamsObject:patientExam];
            }
            [patient removeExams:removalSet];
            [patient addExamsObject:currentExam];
            currentExam.patient = patient;
        }
            
        [self saveData];
    }
}

@end
