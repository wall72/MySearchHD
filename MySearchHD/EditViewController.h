//
//  EditViewController.h
//  MySearchHD
//
//  Created by cliff on 11. 6. 13..
//  Copyright 2011 esed. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MySearchHDAppDelegate;
@class SearchItem;

@interface EditViewController : UIViewController <UITextFieldDelegate> {

@private
    UIScrollView *_scrollView;
    UISegmentedControl *_searchEngineSegment;
    UITextField *_searchWordTextField;
    UITextField *_exactWordTextField;
    UITextField *_onemoreWordTextField;
    UITextField *_unwantedWordTextField;
    UISegmentedControl *_fileTypeSegment;
	CGRect _scrollViewFrame;
    BOOL _keyboardVisible;
    MySearchHDAppDelegate *_appDelegate;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *searchEngineSegment;
@property (nonatomic, retain) IBOutlet UITextField *searchWordTextField;
@property (nonatomic, retain) IBOutlet UITextField *exactWordTextField;
@property (nonatomic, retain) IBOutlet UITextField *onemoreWordTextField;
@property (nonatomic, retain) IBOutlet UITextField *unwantedWordTextField;
@property (nonatomic, retain) IBOutlet UISegmentedControl *fileTypeSegment;
@property (nonatomic, retain) SearchItem *searchItem;
@property (nonatomic, assign) BOOL keyboardVisible;

- (IBAction)searchEngineChanged:(id)sender;
- (IBAction)fileTypeChanged:(id)sender;

- (void)keyboardDidShow:(NSNotification *)notif;
- (void)keyboardDidHide:(NSNotification *)notif;

@end
