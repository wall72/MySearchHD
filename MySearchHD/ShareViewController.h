//
//  ShareViewController.h
//  MySearchHD
//
//  Created by Changho Lee on 11. 6. 15..
//  Copyright 2011 타임교육. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@class DetailViewController;

@interface ShareViewController : UIViewController <MFMailComposeViewControllerDelegate> {
    
}

@property (nonatomic, assign) DetailViewController *detailViewController;

- (IBAction)goSafari:(id)sender;
- (IBAction)goEmail:(id)sender;

@end
