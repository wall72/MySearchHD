//
//  ShareViewController.m
//  MySearchHD
//
//  Created by cliff on 11. 6. 15..
//  Copyright 2011 esed. All rights reserved.
//

#import "ShareViewController.h"
#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ShareViewController ()
@end

@implementation ShareViewController

@synthesize detailViewController = _detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc {
    [_detailViewController release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    self.detailViewController = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Event handler

- (IBAction)goSafari:(id)sender {
    NSLog(@"URL= %@", [[self.detailViewController.webView request] URL]);
    [[UIApplication sharedApplication] openURL:[[self.detailViewController.webView request] URL]];
    
    [self.detailViewController.popoverController2 dismissPopoverAnimated:YES];
}

- (IBAction)goEmail:(id)sender {
    NSLog(@"call");
    
    UIGraphicsBeginImageContextWithOptions(self.detailViewController.webView.bounds.size, NO, 0.0);
    [[self.detailViewController.webView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *_image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    // 메일화면 표시
    MFMailComposeViewController *_mailComposer = [[[MFMailComposeViewController alloc] init] autorelease];
    [_mailComposer setMailComposeDelegate:self];
    [_mailComposer setSubject:@"MySearchHD"];
    [_mailComposer setMessageBody:[[[self.detailViewController.webView request] URL] absoluteString] isHTML:NO];
    [_mailComposer addAttachmentData:UIImageJPEGRepresentation(_image, 1.0) mimeType:@"application/jpeg" fileName:@"MySearchHD.jpg"];
    [self presentModalViewController:_mailComposer animated:YES];
    
    [self.detailViewController.popoverController2 dismissPopoverAnimated:YES];
}

@end
