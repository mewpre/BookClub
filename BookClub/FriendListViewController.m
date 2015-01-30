//
//  ViewController.m
//  BookClub
//
//  Created by Yi-Chin Sun on 1/28/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "FriendListViewController.h"
#import "PeopleListViewController.h"
#import "FriendDetailViewController.h"
#import "Person.h"
#import "AppDelegate.h"

@interface FriendListViewController () <UITableViewDataSource, UITableViewDelegate>

@property NSManagedObjectContext *context;
@property NSArray *friendsList;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FriendListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.context = [AppDelegate appDelegate].managedObjectContext;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadFriends];
}

- (void)loadFriends
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Person description]];
    request.predicate = [NSPredicate predicateWithFormat:@"name == %@", @"User"];
    NSArray *userArray = [self.context executeFetchRequest:request error:nil];
    self.user = [userArray firstObject];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *sortedFriends = [[self.user.friends allObjects] sortedArrayUsingDescriptors:@[sortDescriptor]];
    self.friendsList = sortedFriends;
    [self.tableView reloadData];
}

#pragma mark - Table View Delegate Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Person *friend = [self.friendsList objectAtIndex:indexPath.row];
    cell.textLabel.text = friend.name;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsList.count;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"addFriendsSegue"])
    {
        PeopleListViewController *pvc = segue.destinationViewController;
        pvc.context = self.context;
    }
    else if ([segue.identifier isEqualToString:@"friendDetailSegue"])
    {
        FriendDetailViewController *fvc = segue.destinationViewController;
        UITableViewCell *cell = sender;
        Person *selectedFriend = [self.friendsList objectAtIndex:[self.tableView indexPathForCell:cell].row];
        fvc.selectedFriend = selectedFriend;
    }
}



@end
