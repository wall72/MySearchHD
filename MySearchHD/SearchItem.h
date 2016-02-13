//
//  SearchItem.h
//  MySearchHD
//
//  Created by cliff on 11. 6. 13..
//  Copyright (c) 2011 esed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SearchItem : NSManagedObject {

}

@property (nonatomic, retain) NSNumber *searchEngine;
@property (nonatomic, retain) NSString *searchWord;
@property (nonatomic, retain) NSString *exactWord;
@property (nonatomic, retain) NSString *onemoreWord;
@property (nonatomic, retain) NSString *unwantedWord;
@property (nonatomic, retain) NSNumber *fileType;
@property (nonatomic, retain) NSDate *timeStamp;
@property (nonatomic, retain, readonly) NSString *searchPhrase;

@end
