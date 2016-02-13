//
//  EditViewController.m
//  MySearchHD
//
//  Created by cliff on 11. 6. 13..
//  Copyright 2011 esed. All rights reserved.
//

#import "EditViewController.h"
#import "MySearchHDAppDelegate.h"
#import "DetailViewController.h"
#import "SearchItem.h"

@implementation EditViewController

@synthesize scrollView = _scrollView;
@synthesize searchEngineSegment = _searchEngineSegment;
@synthesize searchWordTextField = _searchWordTextField;
@synthesize exactWordTextField = _exactWordTextField;
@synthesize onemoreWordTextField = _onemoreWordTextField;
@synthesize unwantedWordTextField = _unwantedWordTextField;
@synthesize fileTypeSegment = _fileTypeSegment;
@synthesize searchItem = _searchItem;
@synthesize keyboardVisible = _keyboardVisible;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.keyboardVisible = NO;
        
        _appDelegate = (MySearchHDAppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)dealloc {
	[_scrollView release];
    [_searchEngineSegment release];
    [_searchWordTextField release];
    [_exactWordTextField release];
    [_onemoreWordTextField release];
    [_unwantedWordTextField release];
    [_fileTypeSegment release];
    [_searchItem release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    // Register Notification handlers
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];

//    UIBarButtonItem *_goButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button-icon-globe.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(goUrl:)];
//	[self.navigationItem setRightBarButtonItem:_goButtonItem];
//    [_goButtonItem release];

    UIBarButtonItem *_removeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(removeButtonPressed:)];
    [self.navigationItem setRightBarButtonItem:_removeButton];
    [_removeButton release];

    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    self.scrollView = nil;
    self.searchEngineSegment = nil;
    self.searchWordTextField = nil;
    self.exactWordTextField = nil;
    self.onemoreWordTextField = nil;
    self.unwantedWordTextField = nil;
    self.fileTypeSegment = nil;
    self.searchItem = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    _scrollViewFrame = self.view.frame;
    [self.scrollView setFrame:_scrollViewFrame];
	[self.scrollView setContentSize:self.view.bounds.size];
    [self.scrollView setScrollEnabled:NO];

    [self.searchEngineSegment setSelectedSegmentIndex:[self.searchItem.searchEngine intValue]];
    [self.searchWordTextField setText:self.searchItem.searchWord];
    [self.exactWordTextField setText:self.searchItem.exactWord];
    [self.onemoreWordTextField setText:self.searchItem.onemoreWord];
    [self.unwantedWordTextField setText:self.searchItem.unwantedWord];
    [self.fileTypeSegment setSelectedSegmentIndex:[self.searchItem.fileType intValue]];
    
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.searchWordTextField resignFirstResponder];
    [self.exactWordTextField resignFirstResponder];
    [self.onemoreWordTextField resignFirstResponder];
    [self.unwantedWordTextField resignFirstResponder];

    NSLog(@"self.searchItem = %@", self.searchItem);

    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.searchWordTextField) {
        [self.exactWordTextField becomeFirstResponder];
    } else if (textField == self.exactWordTextField) {
        [self.onemoreWordTextField becomeFirstResponder];
    } else if (textField == self.onemoreWordTextField) {
        [self.unwantedWordTextField becomeFirstResponder];
    }
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.searchWordTextField) {
        [self.searchItem setSearchWord:self.searchWordTextField.text];
    } else if (textField == self.exactWordTextField) {
        [self.searchItem setExactWord:self.exactWordTextField.text];
    } else if (textField == self.onemoreWordTextField) {
        [self.searchItem setOnemoreWord:self.onemoreWordTextField.text];
    } else {
        [self.searchItem setUnwantedWord:self.unwantedWordTextField.text];
    }
}

#pragma mark - Event handlers

- (void)keyboardDidShow:(NSNotification *)notif {
	if (_keyboardVisible) {
		NSLog(@"Keyboard is already visible. Ignore notification.");
		
		return;
	}
	
    UIInterfaceOrientation _currentOrientation = [_appDelegate.detailViewController interfaceOrientation];
    if (UIInterfaceOrientationIsLandscape(_currentOrientation)) {
        NSLog(@"Resizing smaller for keyboard.");
        
        NSDictionary *info = [notif userInfo];
        CGRect keyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue];
        CGRect keyboardBounds = [self.view convertRect:keyboardRect fromView:nil];
        
        CGRect frame = _scrollViewFrame;
        frame.size.height -= keyboardBounds.size.height;
        
        [self.scrollView setFrame:frame];
        [self.scrollView setScrollEnabled:YES];
    }
	
	_keyboardVisible = YES;	
}

- (void)keyboardDidHide:(NSNotification *)notif {
	if (!_keyboardVisible) {
		NSLog(@"Keyboard is already hidden. Ignore notification.");
		
		return;
	}
	
    UIInterfaceOrientation _currentOrientation = [_appDelegate.detailViewController interfaceOrientation];
    if (UIInterfaceOrientationIsLandscape(_currentOrientation)) {
        NSLog(@"Resizing bigger with no keyboard.");
        
        [self.scrollView setFrame:_scrollViewFrame];
        [self.scrollView setScrollEnabled:NO];
    }
    
	_keyboardVisible = NO;
}

- (IBAction)searchEngineChanged:(id)sender {
    [self.searchItem setSearchEngine:[NSNumber numberWithInt:self.searchEngineSegment.selectedSegmentIndex]];
}

- (IBAction)fileTypeChanged:(id)sender {
    [self.searchItem setFileType:[NSNumber numberWithInt:self.fileTypeSegment.selectedSegmentIndex]];
}

#pragma mark - User defined functions

- (void)goUrl:(id)sender {
    _appDelegate.detailViewController.detailItem = self.searchItem;
}

- (IBAction)removeButtonPressed:(id)sender {
    [_appDelegate.managedObjectContext deleteObject:self.searchItem];
    
//    [_appDelegate saveContext];

    [self.navigationController popViewControllerAnimated:YES];
}

@end
