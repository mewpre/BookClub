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

@interface FriendListViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property NSManagedObjectContext *context;
@property NSArray *friendsList;
@property NSArray *filteredFriendsArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property BOOL isAscending;

@end

@implementation FriendListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.context = [AppDelegate appDelegate].managedObjectContext;
    self.isAscending = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadFriends];
}

- (void)sortFriends: (BOOL)isAscending
{
    NSSortDescriptor *sortByBookCount = [NSSortDescriptor sortDescriptorWithKey:@"suggestedBooks.@count" ascending:isAscending];
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
    NSArray *sortedFriends = [[self.user.friends allObjects] sortedArrayUsingDescriptors:@[sortByBookCount, sortByName]];
    self.friendsList = sortedFriends;
    [self.tableView reloadData];
}

- (void)loadFriends
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Person description]];
    request.predicate = [NSPredicate predicateWithFormat:@"name == %@", @"User"];
    NSArray *userArray = [self.context executeFetchRequest:request error:nil];
    self.user = [userArray firstObject];
    [self sortFriends: self.isAscending];
}

#pragma mark - Table View Delegate Methods
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *friend;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (self.searchBar.text.length != 0)
    {
        friend = [self.filteredFriendsArray objectAtIndex:indexPath.row];
    }
    else
    {
        friend = [self.friendsList objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = friend.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Number of suggested books: %lu", (unsigned long)friend.suggestedBooks.count];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchBar.text.length != 0)
    {
        return self.filteredFriendsArray.count;
    }
    else
    {
        return self.friendsList.count;
    }
}

- (IBAction)onSortButtonTapped:(id)sender
{
    self.isAscending = !self.isAscending;
    [self sortFriends:self.isAscending];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[c] %@",searchText];
    self.filteredFriendsArray = [NSMutableArray arrayWithArray:[self.friendsList filteredArrayUsingPredicate:predicate]];
    [self.tableView reloadData];
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
        Person *selectedFriend;
        if (self.searchBar.text.length != 0)
        {
            selectedFriend = [self.filteredFriendsArray objectAtIndex:[self.tableView indexPathForCell:cell].row];
        }
        else
        {
            selectedFriend = [self.friendsList objectAtIndex:[self.tableView indexPathForCell:cell].row];
        }
        fvc.selectedFriend = selectedFriend;
    }
}



@end
