//
//  CoreDataTableViewController.m
//
//  Created for Stanford CS193p Fall 2011.
//  Copyright 2011 Stanford University. All rights reserved.
//

#import "CoreDataTableViewController.h"
#import "TotalStringToDateFormatter.h"

@interface CoreDataTableViewController()
@property (nonatomic) BOOL beganUpdates;
@property (nonatomic,weak) ChiroMaticAppDelegate* sharedDelegate;

@end

@implementation CoreDataTableViewController

#pragma mark - Properties

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize suspendAutomaticTrackingOfChangesInManagedObjectContext = _suspendAutomaticTrackingOfChangesInManagedObjectContext;
@synthesize debug = _debug;
@synthesize beganUpdates = _beganUpdates;
@synthesize sharedDelegate = _sharedDelegate;
@synthesize sharedContext = _sharedContext;
@synthesize currentObject = _currentObject;
@synthesize nameOfManagedEntity = _nameOfManagedEntity;

- (IBAction)addObject:(id)sender
{
    NSEntityDescription* newObject = [NSEntityDescription insertNewObjectForEntityForName:self.nameOfManagedEntity inManagedObjectContext:self.fetchedResultsController.managedObjectContext];
    if ([newObject respondsToSelector:@selector(setName:)]) {
        newObject.name = [NSString stringWithFormat:@"<New %@>",self.nameOfManagedEntity];
    }
}
- (IBAction)deleteObject:(id)sender
{
    if (self.currentObject) {
        [self.fetchedResultsController.managedObjectContext deleteObject:self.currentObject];
        [self saveData];
    }
        UINavigationController* nc = self.splitViewController.viewControllers.lastObject;
        id vc = nc.viewControllers.lastObject;
        
        if ([[vc class]conformsToProtocol:@protocol(DataPopulator)]) {
            id <DataPopulator> view = vc;
            [view populateFieldsWithDataOfObject:nil];
            view.delegate = self;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Pass Object data to detailviewcontroller if it conforms to protocool
    self.currentObject = [self.fetchedResultsController objectAtIndexPath:indexPath];
    UINavigationController* nc = self.splitViewController.viewControllers.lastObject;
    id vc = nc.viewControllers.lastObject;
    
    if ([[vc class]conformsToProtocol:@protocol(DataPopulator)]) {
        id <DataPopulator> view = vc;
        [view populateFieldsWithDataOfObject:self.currentObject];
        view.delegate = self;
    }
    [self saveData];
}

- (void) viewWillDisappear:(BOOL)animated
{
    id vc = self.splitViewController.viewControllers.lastObject;
    if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController* nc = vc;
        [nc popToRootViewControllerAnimated:NO];
    }
}

/*- (void) navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item
{
    [self performSegueWithIdentifier:@"Splash Segue" sender:self];
    //self.navigationController.navigationBar.delegate = nil;
}
 */

- (void) updateCurrentEntityWithValue:(id)value forKey:(NSString *)key
{
    [self.currentObject setValue:value forKey:key];
}

- (void) updateCurrentEntityWithStringToDateValue:(NSString*)value forKey:(NSString *)key
{
    /*NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSDate* date = [dateFormatter dateFromString:value];*/
    NSDate* date = [TotalStringToDateFormatter convertString:value];
    [self.currentObject setValue:date forKey:key];
}

- (void) setupFetchRequestWithSharedDocumentForEntityName:(NSString*)entityName descriptor:(NSString*)descriptor
{
    self.nameOfManagedEntity = entityName;
    self.sharedDelegate = [[UIApplication sharedApplication]delegate];
    self.sharedContext = self.sharedDelegate.managedObjectContext;
    
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:descriptor ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:request managedObjectContext:self.sharedContext sectionNameKeyPath:nil cacheName:nil];
}

- (void) saveData
{
    [self.sharedDelegate saveContext];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Fetching

- (void)performFetch
{
    if (self.fetchedResultsController) {
        if (self.fetchedResultsController.fetchRequest.predicate) {
            if (self.debug) NSLog(@"[%@ %@] fetching %@ with predicate: %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName, self.fetchedResultsController.fetchRequest.predicate);
        } else {
            if (self.debug) NSLog(@"[%@ %@] fetching all %@ (i.e., no predicate)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), self.fetchedResultsController.fetchRequest.entityName);
        }
        NSError *error;
        [self.fetchedResultsController performFetch:&error];
        if (error) NSLog(@"[%@ %@] %@ (%@)", NSStringFromClass([self class]), NSStringFromSelector(_cmd), [error localizedDescription], [error localizedFailureReason]);
    } else {
        if (self.debug) NSLog(@"[%@ %@] no NSFetchedResultsController (yet?)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
    }
    [self.tableView reloadData];
}

- (void)setFetchedResultsController:(NSFetchedResultsController *)newfrc
{
    NSFetchedResultsController *oldfrc = _fetchedResultsController;
    if (newfrc != oldfrc) {
        _fetchedResultsController = newfrc;
        newfrc.delegate = self;
        if ((!self.title || [self.title isEqualToString:oldfrc.fetchRequest.entity.name]) && (!self.navigationController || !self.navigationItem.title)) {
            self.title = newfrc.fetchRequest.entity.name;
        }
        if (newfrc) {
            if (self.debug) NSLog(@"[%@ %@] %@", NSStringFromClass([self class]), NSStringFromSelector(_cmd), oldfrc ? @"updated" : @"set");
            [self performFetch]; 
        } else {
            if (self.debug) NSLog(@"[%@ %@] reset to nil", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
	return [self.fetchedResultsController sectionForSectionIndexTitle:title atIndex:index];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sectionIndexTitles];
}

#pragma mark - NSFetchedResultsControllerDelegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext) {
        [self.tableView beginUpdates];
        self.beganUpdates = YES;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
		   atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type
{
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath
{		
    if (!self.suspendAutomaticTrackingOfChangesInManagedObjectContext)
    {
        switch(type)
        {
            case NSFetchedResultsChangeInsert:
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeMove:
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if (self.beganUpdates) [self.tableView endUpdates];
}

- (void)endSuspensionOfUpdatesDueToContextChanges
{
    _suspendAutomaticTrackingOfChangesInManagedObjectContext = NO;
}

- (void)setSuspendAutomaticTrackingOfChangesInManagedObjectContext:(BOOL)suspend
{
    if (suspend) {
        _suspendAutomaticTrackingOfChangesInManagedObjectContext = YES;
    } else {
        [self performSelector:@selector(endSuspensionOfUpdatesDueToContextChanges) withObject:0 afterDelay:0];
    }
}

@end

