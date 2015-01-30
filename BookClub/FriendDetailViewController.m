//
//  FriendViewController.m
//  BookClub
//
//  Created by Yi-Chin Sun on 1/28/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "BookDetailViewController.h"
#import "AddBookViewController.h"
#import "Person.h"
#import "Book.h"

@interface FriendDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *recommendationLabel;
@property NSManagedObjectContext *context;

@property NSArray *bookListArray;

@end

@implementation FriendDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.context = [self.selectedFriend managedObjectContext];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadBookList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Book *book = [self.bookListArray objectAtIndex:indexPath.row];
    cell.textLabel.text = book.title;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookListArray.count;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"bookDetailSegue"])
    {
        BookDetailViewController *bvc = segue.destinationViewController;
        UITableViewCell *cell = sender;
        Book *book = [self.bookListArray objectAtIndex:[self.tableView indexPathForCell:cell].row];
        bvc.book = book;
    }
    else
    {
        AddBookViewController *avc = segue.destinationViewController;
        avc.selectedFriend = self.selectedFriend;
    }
}

// Helper Method
- (void)loadBookList
{
    self.bookListArray = [self.selectedFriend.suggestedBooks allObjects];
    self.navigationItem.title = self.selectedFriend.name;
    self.recommendationLabel.text = [NSString stringWithFormat:@"# of Suggested Books: %lu", (unsigned long)self.bookListArray.count];
    [self.tableView reloadData];
}

@end
