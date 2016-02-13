//
//  RootViewController.h
//  MySearchHD
//
//  Created by cliff on 11. 6. 13..
//  Copyright 2011 esed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class DetailViewController;

@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {

}

@property (nonatomic, retain) IBOutlet DetailViewController *detailViewController;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) UISearchDisplayController *itemSearchDisplayController;

- (void)insertNewObject:(id)sender;

@end
