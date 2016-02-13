//
//  DetailViewController.h
//  MySearchHD
//
//  Created by cliff on 11. 6. 13..
//  Copyright 2011 esed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class MySearchHDAppDelegate;
@class RootViewController;
@class SearchItem;

@interface DetailViewController : UIViewController <UIPopoverControllerDelegate, UISplitViewControllerDelegate, UIWebViewDelegate> {

@private
    MySearchHDAppDelegate *_appDelegate;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *forwardButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *refreshButton;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *safariButton;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIWebView *webView;
@property (nonatomic, retain) UIPopoverController *popoverController2;
@property (nonatomic, assign) IBOutlet RootViewController *rootViewController;
@property (nonatomic, retain) SearchItem *detailItem;
@property (nonatomic, retain) NSURL *url;

- (IBAction)goBack:(id)sender;
- (IBAction)goFoward:(id)sender;
- (IBAction)Refresh:(id)sender;
- (IBAction)popShare:(id)sender;

@end
