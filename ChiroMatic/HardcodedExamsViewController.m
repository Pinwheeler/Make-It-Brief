//
//  HardcodedExamsViewController.m
//  ChiroMatic
//
//  Created by Anthony Dreessen on 4/4/13.
//  Copyright (c) 2013 Anthony Dreessen. All rights reserved.
//

#import "HardcodedExamsViewController.h"

@interface HardcodedExamsViewController ()
@property (strong,nonatomic) NSArray* examNames;

@end

@implementation HardcodedExamsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ExamProperties" ofType:@"plist"];
        NSDictionary* examsDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
        self.examNames = [examsDict objectForKey:@"examNames"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"ExamProperties" ofType:@"plist"];
    NSDictionary* examsDict = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    self.examNames = [examsDict objectForKey:@"examNames"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.examNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Hardcoded Exam Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.examNames objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) viewWillDisappear:(BOOL)animated
{
    id vc = self.splitViewController.viewControllers.lastObject;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nc = vc;
        [nc popToRootViewControllerAnimated:NO];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChiroMaticAppDelegate* delegate = [[UIApplication sharedApplication]delegate];
    NSManagedObjectContext* context = [delegate managedObjectContext];
    if (self.currentObject) {
        if (!self.currentObject.patient) {
            [context deleteObject:self.currentObject];
        }
    }
    //Create an exam object and add it to the managed object context
    NSEntityDescription* newExam = [NSEntityDescription insertNewObjectForEntityForName:@"Exam" inManagedObjectContext:context];
    newExam.name = [self.examNames objectAtIndex:indexPath.row];
    
    //Pass Object data to detailviewcontroller if it conforms to protocool
    self.currentObject = (Exam*)newExam;
    UINavigationController* nc = self.splitViewController.viewControllers.lastObject;
    id vc = nc.viewControllers.lastObject;
    
    if ([[vc class]conformsToProtocol:@protocol(DataPopulator)]) {
        id <DataPopulator> view = vc;
        [view populateFieldsWithDataOfObject:self.currentObject];
        view.delegate = self;
    }
}

@end
