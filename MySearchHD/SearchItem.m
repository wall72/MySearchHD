//
//  SearchItem.m
//  MySearchHD
//
//  Created by cliff on 11. 6. 13..
//  Copyright (c) 2011 esed. All rights reserved.
//

#import "SearchItem.h"

@implementation SearchItem

@dynamic searchEngine;
@dynamic searchWord;
@dynamic exactWord;
@dynamic onemoreWord;
@dynamic unwantedWord;
@dynamic fileType;
@dynamic timeStamp;
@dynamic searchPhrase;

#pragma mark - Transient properties

- (NSString *)searchPhrase {
    NSString *_searchPhrase;
    
    NSLog(@"self = %@", self);
    
    //TODO: Valid check
    NSString *_searchParams = [NSString stringWithFormat:@"%@", self.searchWord];
    
    if (self.exactWord != nil && ![self.exactWord isEqualToString:@""]) {
        _searchParams = [_searchParams stringByAppendingFormat:@" \"%@\"", self.exactWord];
    }
    
    if (self.onemoreWord != nil && ![self.onemoreWord isEqualToString:@""]) {
        NSArray *_onemoreArray = [self.onemoreWord componentsSeparatedByString:@" "];
        
        NSLog(@"_onemoreArray = %@", _onemoreArray);
        
        if ([_onemoreArray count] == 1) {
            if ([self.searchEngine intValue] == 0) {
                _searchParams = [_searchParams stringByAppendingFormat:@" %@", [_onemoreArray objectAtIndex:0]];
            } else if ([self.searchEngine intValue] == 1) {
                _searchParams = [_searchParams stringByAppendingFormat:@" (%@)", [_onemoreArray objectAtIndex:0]];
            } else {
                _searchParams = [_searchParams stringByAppendingFormat:@" %@", [_onemoreArray objectAtIndex:0]];
            }
        } else {
            NSString *_orString = @"";
            
            for (int i = 0; i < [_onemoreArray count]; i++) {
                NSString *_orstr = [_onemoreArray objectAtIndex:i];
                
                if (i == [_onemoreArray count] - 1) {
                    _orString = [_orString stringByAppendingFormat:@" %@", _orstr];
                } else if (i == 0) {
                    _orString = [_orString stringByAppendingFormat:@"%@ OR", _orstr];
                } else {
                    _orString = [_orString stringByAppendingFormat:@" %@ OR", _orstr];
                }
            }    
            
            if ([self.searchEngine intValue] == 0) {
                _searchParams = [_searchParams stringByAppendingFormat:@" %@", _orString];
            } else if ([self.searchEngine intValue] == 1) {
                _searchParams = [_searchParams stringByAppendingFormat:@" (%@)", _orString];
            } else {
                _searchParams = [_searchParams stringByAppendingFormat:@" %@", _orString];
            }
        }
    }
    
    if (self.unwantedWord != nil && ![self.unwantedWord isEqualToString:@""]) {
        NSArray *_unwantedArray = [self.unwantedWord componentsSeparatedByString:@" "];
        
        NSLog(@"_unwantedArray = %@", _unwantedArray);
        
        for (int j = 0; j < [_unwantedArray count]; j++) {
            NSString *_unStr = [_unwantedArray objectAtIndex:j];
            
            if ([self.searchEngine intValue] == 0) {
                _searchParams = [_searchParams stringByAppendingFormat:@" -%@", _unStr];
            } else if ([self.searchEngine intValue] == 1) {
                _searchParams = [_searchParams stringByAppendingFormat:@" -(%@)", _unStr];
            } else {
                _searchParams = [_searchParams stringByAppendingFormat:@" -%@", _unStr];
            }
        }
    }

    switch ([self.fileType intValue]) {
        case 1:
            _searchParams = [_searchParams stringByAppendingString:@" filetype:pdf"];
            break;
        case 2:
            _searchParams = [_searchParams stringByAppendingString:@" filetype:xls"];
            break;
        case 3:
            _searchParams = [_searchParams stringByAppendingString:@" filetype:ppt"];
            break;
        case 4:
            _searchParams = [_searchParams stringByAppendingString:@" filetype:doc"];
            break;
            
        default:
            break;
    }
    
    if ([self.searchEngine intValue] == 0) {
        _searchPhrase = [NSString stringWithFormat:@"http://www.google.com/search?q=%@", _searchParams];
    } else if ([self.searchEngine intValue] == 1) {
        _searchPhrase = [NSString stringWithFormat:@"http://www.bing.com/search?q=%@", _searchParams];
    } else {
        _searchPhrase = [NSString stringWithFormat:@"http://duckduckgo.com/?q=%@", _searchParams];
    }
    
    return _searchPhrase;
}

@end
