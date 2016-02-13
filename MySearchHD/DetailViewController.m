//
//  DetailViewController.m
//  MySearchHD
//
//  Created by cliff on 11. 6. 13..
//  Copyright 2011 esed. All rights reserved.
//

#import "DetailViewController.h"
#import "MySearchHDAppDelegate.h"
#import "RootViewController.h"
#import "ShareViewController.h"
#import "SearchItem.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)initialView;
- (void)configureView;
- (void)gotoUrl;
- (void)setToolbarButton;
@end

@implementation DetailViewController

@synthesize toolbar = _toolbar;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;
@synthesize refreshButton = _refreshButton;
@synthesize safariButton = _safariButton;
@synthesize activityIndicator = _activityIndicator;
@synthesize titleLabel = _titleLabel;
@synthesize webView = _webView;
@synthesize popoverController = _myPopoverController;
@synthesize popoverController2 = _myPopoverController2;
@synthesize rootViewController = _rootViewController;
@synthesize detailItem = _detailItem;
@synthesize url = _url;

#pragma mark - Memory management

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)awakeFromNib {
    _appDelegate = (MySearchHDAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [_toolbar release];
    [_backButton release];
    [_forwardButton release];
    [_refreshButton release];
    [_safariButton release];
    [_activityIndicator release];
    [_titleLabel release];
    [_webView release];
    [_myPopoverController release];
    [_myPopoverController2 release];
    [_detailItem release];
    [_url release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.titleLabel setText:@"MySearchHD"];
    [self.titleLabel setTextColor:[UIColor grayColor]];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:20.0]];
    [self.titleLabel setTextAlignment:UITextAlignmentCenter];
    [self.titleLabel setShadowColor:[UIColor whiteColor]];
    [self.titleLabel setShadowOffset:CGSizeMake(0, 1)];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    UIBarButtonItem *_titleView = [[UIBarButtonItem alloc] initWithCustomView:self.titleLabel];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *_indicatorView = [[UIBarButtonItem alloc] initWithCustomView:self.activityIndicator];
    
    UIBarButtonItem *_flexBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:_titleView atIndex:3];
    [items insertObject:_flexBar atIndex:4];
    [items insertObject:_indicatorView atIndex:5];
    [self.toolbar setItems:items animated:YES];
    [_indicatorView release];
    [_flexBar release];
    [_titleView release];
    [items release];
    
    [self initialView];
}

- (void)viewDidUnload {
	[super viewDidUnload];

    self.toolbar = nil;
    self.backButton = nil;
    self.forwardButton = nil;
    self.refreshButton = nil;
    self.safariButton = nil;
    self.activityIndicator = nil;
    self.titleLabel = nil;
    self.webView = nil;
	self.popoverController = nil;
	self.popoverController2 = nil;
    self.detailItem = nil;
    self.url = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.backButton setEnabled:NO];
    [self.forwardButton setEnabled:NO];
    [self.refreshButton setEnabled:NO];
    [self.safariButton setEnabled:NO];

    [super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    CGRect _frame = self.webView.frame;
    _frame.size.width = self.view.frame.size.width;
    _frame.size.height = self.view.frame.size.height - self.toolbar.frame.size.height;
    
    [self.webView setFrame:_frame];
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc {
    NSLog(@"call");

    barButtonItem.title = @"Search Items";
    
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    
    self.popoverController = pc;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    NSLog(@"call");

    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    
    self.popoverController = nil;
}

- (void)splitViewController:(UISplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController {
    if (self.popoverController2) {
        if ([self.popoverController2 isPopoverVisible]) {
            [self.popoverController2 dismissPopoverAnimated:YES];
        }
    }
}

#pragma mark - WebView delegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator setHidden:NO];
	[self.activityIndicator startAnimating];

    UIApplication *_app = [UIApplication sharedApplication];
    [_app setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self.activityIndicator stopAnimating];
    [self.activityIndicator setHidden:YES];

    UIApplication *_app = [UIApplication sharedApplication];
    [_app setNetworkActivityIndicatorVisible:NO];
    
    [self setToolbarButton];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	[self.activityIndicator stopAnimating];
    [self.activityIndicator setHidden:YES];
    
    UIApplication *_app = [UIApplication sharedApplication];
    [_app setNetworkActivityIndicatorVisible:NO];
    
    [self setToolbarButton];
}

#pragma mark - Properties

- (void)setDetailItem:(SearchItem *)managedObject {
	if (_detailItem != managedObject) {
		[_detailItem release];
		_detailItem = [managedObject retain];
	}
    
    // Update the view.
    [self configureView];

    if (self.popoverController != nil) {
        [self.popoverController dismissPopoverAnimated:YES];
    }		
}

#pragma mark - Event handlers

- (IBAction)goBack:(id)sender {
	[self.webView goBack];
}

- (IBAction)goFoward:(id)sender {
	[self.webView goForward];
}

- (IBAction)Refresh:(id)sender {
    [self.webView reload];
}

- (IBAction)popShare:(id)sender {
    NSLog(@"call");

    if (self.popoverController) {
        if ([self.popoverController isPopoverVisible]) {
            [self.popoverController dismissPopoverAnimated:YES];
        }
    }
    
    if (self.popoverController2) {
        if ([self.popoverController2 isPopoverVisible]) {
            [self.popoverController2 dismissPopoverAnimated:YES];
        } else {
            [self.popoverController2 presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    } else {
        ShareViewController *_shareViewController = [[[ShareViewController alloc] initWithNibName:@"ShareView" bundle:nil] autorelease];
        [_shareViewController setDetailViewController:self];
        
        self.popoverController2 = [[[UIPopoverController alloc] initWithContentViewController:_shareViewController] autorelease];
        [self.popoverController2 setDelegate:nil];
        [self.popoverController2 setPopoverContentSize:_shareViewController.view.frame.size];
        [self.popoverController2 presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
}

#pragma mark - User defined functions

- (void)initialView {
	NSString *_urlString = @"http://mobileappsesed.blogspot.com/2011/07/mysearchpad-coming-soon.html";
    
    if (![[self.url absoluteString] isEqualToString:_urlString]) {
        self.url = [NSURL URLWithString:_urlString];
        [self gotoUrl];
    }
}

- (void)configureView {
	NSString *_urlString = [self.detailItem.searchPhrase stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"self.url = %@", [self.url absoluteString]);
    NSLog(@"_urlString = %@", _urlString);
    
    [self.titleLabel setText:self.detailItem.searchWord];
    
    if (![[self.url absoluteString] isEqualToString:_urlString]) {
        self.url = [NSURL URLWithString:_urlString];
        [self gotoUrl];
    }
}

- (void)gotoUrl {
    NSLog(@"URL = %@", self.url);

	NSURLRequest *_requestObj = [NSURLRequest requestWithURL:self.url];
	
	[self.webView loadRequest:_requestObj];
}

- (void)setToolbarButton {
    [self.backButton setEnabled:[self.webView canGoBack]];    
    [self.forwardButton setEnabled:[self.webView canGoForward]];
    
    if (self.url != nil) {
        [self.refreshButton setEnabled:YES];
        [self.safariButton setEnabled:YES];
    }
}

@end
