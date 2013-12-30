//
//  ExamsViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 3/24/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "ExamsViewController.h"

@interface ExamsViewController ()

@end

@implementation ExamsViewController

@synthesize currentlySelectedExam = _currentlySelectedExam;
@synthesize currentReport = _currentReport;

- (IBAction)addObject:(id)sender
{
    if (self.currentSuperobject) {

        NSEntityDescription* newObject = [NSEntityDescription insertNewObjectForEntityForName:@"Exam" inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
        if ([newObject respondsToSelector:@selector(setName:)]) {
        newObject.name = [NSString stringWithFormat:@"<New %@>",@"Finding"];
        }
        Patient* currentPatient;
        if ([self.currentSuperobject isKindOfClass:[Patient class]]) {
        currentPatient = (Patient*)self.currentSuperobject;
        }
        [currentPatient addExamsObject:(Exam*)newObject];
    }
}

- (void) setCurrentSuperobject:(NSManagedObject *)currentSuperobject
{
    ChiroMaticAppDelegate* sharedDelegate = [[UIApplication sharedApplication]delegate];
    self.sharedContext = sharedDelegate.managedObjectContext;
    if (_currentSuperobject != currentSuperobject) {
        _currentSuperobject = currentSuperobject;
    }
    Patient* currentPatient;
    if ([self.currentSuperobject isKindOfClass:[Patient class]]) {
        currentPatient = (Patient*)self.currentSuperobject;
    }
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Exam"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF IN %@",currentPatient.exams];
    request.predicate = predicate;
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.sharedContext sectionNameKeyPath:nil cacheName:nil];
    [self.tableView reloadData];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Exam Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    Exam* exam = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([self.currentReport.exams containsObject:exam]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    cell.textLabel.text = exam.name;
    return cell;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentlySelectedExam && self.delegate.specialReturnValue) {
        self.currentlySelectedExam.name = self.delegate.specialReturnValue;
    }
    Exam* exam = [self.fetchedResultsController objectAtIndexPath:indexPath];
    self.currentObject = exam;
    //First check to see if the doctor is already selected and if so
    if (exam == self.currentlySelectedExam) {
        //Check to see if the superobject is a clinic or an insurance
        //Toggle whether the selected doctor belongs or does not belong to the current clinic

            if ([self.currentReport.exams containsObject:exam]) {
                [self.currentReport removeExamsObject:exam];
                [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
            }else
            {
                [self.currentReport addExamsObject:exam];
                [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
    }

    //Otherwise make all edits before selecting the new one
    self.currentlySelectedExam = exam;
    [self.delegate populateFieldsWithDataOfObject:self.currentlySelectedExam];
    [self saveData];
}

@end
