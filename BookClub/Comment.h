//
//  Comment.h
//  BookClub
//
//  Created by Yi-Chin Sun on 1/28/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book;

@interface Comment : NSManagedObject

@property (nonatomic, retain) NSString * commentText;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) Book *commentedBook;

@end
