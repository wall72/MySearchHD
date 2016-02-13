//
//  RootViewController.m
//  MySearchHD
//
//  Created by cliff on 11. 6. 13..
//  Copyright 2011 타임교육. All rights reserved.
//

#import "RootViewController.h"
#import "EditViewController.h"
#import "DetailViewController.h"
#import "SearchItem.h"

@interface RootViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
- (void)goEditView:(SearchItem *)searchItem;
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;
@end

@implementation RootViewController
		
@synthesize detailViewController;
@synthesize fetchedResultsController;
@synthesize managedObjectContext;
@synthesize itemSearchDisplayController;

#pragma mark - Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [detailViewController release];
    [fetchedResultsController release];
    [managedObjectContext release];
    [itemSearchDisplayController release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    [addButton release];

    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    
    // ----
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];  
	searchBar.delegate = self;  
	searchBar.showsCancelButton = YES;  
	[searchBar sizeToFit];  
    
	self.tableView.tableHeaderView = searchBar;  
	[searchBar release];  
    
	self.itemSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    [self.itemSearchDisplayController setDelegate:self];  
    [self.itemSearchDisplayController setSearchResultsDataSource:self];  
    [self.itemSearchDisplayController setSearchResultsDelegate:self];
    [self.itemSearchDisplayController release];  
    // ----

    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        abort();
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView setContentOffset:CGPointMake(0, 44) animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - TableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the managed object for the given index path
        NSManagedObjectContext *context = [fetchedResultsController managedObjectContext];
        [context deleteObject:[fetchedResultsController objectAtIndexPath:indexPath]];
        
        // Save the context.
        NSError *error = nil;
        if (![context save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"call");
    SearchItem *_selectedObject = [[self fetchedResultsController] objectAtIndexPath:indexPath];
    detailViewController.detailItem = _selectedObject;
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
    /*
     Set up the fetched results controller.
    */
    // Create the fetch request for the entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SearchItem" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"searchWord" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    [aFetchedResultsController release];
    [fetchRequest release];
    [sortDescriptor release];
    [sortDescriptors release];
    
    return fetchedResultsController;
}    

#pragma mark - Fetched results controller delegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

/*
// Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed. 
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // In the simplest, most efficient, case, reload the table view.
    [self.tableView reloadData];
}
 */

#pragma mark - Search bar delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
	NSLog(@"call");
	
    [searchBar setText:@""];
}

#pragma mark - Search display delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	NSLog(@"call");
	
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
	NSLog(@"call");
	
    NSString *_query = self.searchDisplayController.searchBar.text;
    
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
    
    NSFetchRequest *_fetchRequest = [[self fetchedResultsController] fetchRequest];
    
    NSPredicate *_predicate;
    if (_query && _query.length) {
        _predicate = [NSPredicate predicateWithFormat:@"searchWord contains[cd] %@", _query];
        [_fetchRequest setPredicate:_predicate];
    } else {
        [_fetchRequest setPredicate:nil];
    }
    
    NSError *_error = nil;
    if (![[self fetchedResultsController] performFetch:&_error]) {
        NSLog(@"Unresolved error %@, %@", _error, [_error userInfo]);
//        abort();
    }  
    
	[self.tableView reloadData];
}

#pragma mark - Event handler

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	NSLog(@"call");
	
    [super setEditing:(BOOL)editing animated:(BOOL)animated];
    [self.navigationItem.rightBarButtonItem setEnabled:!editing];
}

- (void)insertNewObject:(id)sender {
    NSIndexPath *currentSelection = [self.tableView indexPathForSelectedRow];
    if (currentSelection != nil) {
        [self.tableView deselectRowAtIndexPath:currentSelection animated:NO];
    }    
    
    NSManagedObjectContext *_context = [fetchedResultsController managedObjectContext];
    NSEntityDescription *_entity = [[fetchedResultsController fetchRequest] entity];
    SearchItem *_newManagedObject = [NSEntityDescription insertNewObjectForEntityForName:[_entity name] inManagedObjectContext:_context];
    
    [_newManagedObject setSearchEngine:[NSNumber numberWithInt:0]];
    [_newManagedObject setSearchWord:@""];
    [_newManagedObject setTimeStamp:[NSDate date]];
    
    // Save the context.
    NSError *_error = nil;
    if (![_context save:&_error]) {
        NSLog(@"Unresolved error %@, %@", _error, [_error userInfo]);
//        abort();
    }
    
    NSIndexPath *insertionPath = [fetchedResultsController indexPathForObject:_newManagedObject];
    [self.tableView selectRowAtIndexPath:insertionPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    
    [self goEditView:_newManagedObject];
    
    [self.tableView deselectRowAtIndexPath:insertionPath animated:YES];
}

- (void)editPressed:(id)sender {
    NSIndexPath *_indexPath = [self.tableView indexPathForCell:(UITableViewCell *)[sender superview]];
    SearchItem *_selectedObject = [[self fetchedResultsController] objectAtIndexPath:_indexPath];
    
    [self goEditView:_selectedObject];

    [self.tableView deselectRowAtIndexPath:_indexPath animated:YES];
}

#pragma mark - User defined fuction

- (void)goEditView:(SearchItem *)searchItem {
    EditViewController *_editViewController = [[EditViewController alloc] initWithNibName:@"EditView" bundle:nil];
    
    _editViewController.contentSizeForViewInPopover = self.view.bounds.size;
    self.contentSizeForViewInPopover = self.view.bounds.size;
    
    [_editViewController setTitle:@"Edit"];
    [_editViewController setSearchItem:searchItem];
    [self.navigationController pushViewController:_editViewController animated:YES];
    [_editViewController release];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    SearchItem *_managedObject = [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = _managedObject.searchWord;
    
    NSArray *_splitStr = [_managedObject.searchPhrase componentsSeparatedByString:@"="];
    cell.detailTextLabel.text = [_splitStr objectAtIndex:1];
    
    if ([_managedObject.searchEngine intValue] == 0) {
        cell.imageView.image = [UIImage imageNamed:@"google-icon.png"];
    } else if ([_managedObject.searchEngine intValue] == 1) {
        cell.imageView.image = [UIImage imageNamed:@"bing-icon.png"];
    } else {
        cell.imageView.image = [UIImage imageNamed:@"duck-icon.png"];
    }

    UIButton *_button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(0, 0, 24, 24);
    [_button setImage:[UIImage imageNamed:@"button-icon-gear.png"] forState:UIControlStateNormal];
    [_button setImage:[UIImage imageNamed:@"button-icon-gear.png"] forState:UIControlStateHighlighted];
    [_button addTarget:self action:@selector(editPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setAccessoryView:_button];
}

@end