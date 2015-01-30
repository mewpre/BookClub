//
//  Person.h
//  BookClub
//
//  Created by Yi-Chin Sun on 1/28/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Book, Person;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * isFriend;
@property (nonatomic, retain) NSSet *friends;
@property (nonatomic, retain) NSSet *suggestedBooks;
@end

@interface Person (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(Person *)value;
- (void)removeFriendsObject:(Person *)value;
- (void)addFriends:(NSSet *)values;
- (void)removeFriends:(NSSet *)values;

- (void)addSuggestedBooksObject:(Book *)value;
- (void)removeSuggestedBooksObject:(Book *)value;
- (void)addSuggestedBooks:(NSSet *)values;
- (void)removeSuggestedBooks:(NSSet *)values;

@end
