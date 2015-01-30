//
//  BookViewController.m
//  BookClub
//
//  Created by Yi-Chin Sun on 1/28/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "BookDetailViewController.h"
#import "Book.h"
#import "Comment.h"

#define kDateKey @"dateSaved"

@interface BookDetailViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UILabel *genreLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property NSArray *commentsArray;
@property NSManagedObjectContext *context;
@end

@implementation BookDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.book.title;
    self.authorLabel.text = [NSString stringWithFormat:@"Author: %@", self.book.author];
    self.genreLabel.text = [NSString stringWithFormat:@"Genre: %@", self.book.genre];
    self.context = [self.book managedObjectContext];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadComments];
}

- (void)loadComments
{
    self.commentsArray = [self.book.comments allObjects];
    [self.tableView reloadData];
}

- (IBAction)onAddButtonTapped:(id)sender
{
    UIAlertController *alertcontroller = [UIAlertController alertControllerWithTitle:@"Write a comment:" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertcontroller addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        nil;
    }];

    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"Okay"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   UITextField *textField = alertcontroller.textFields.firstObject;
                                   Comment *comment = [NSEntityDescription insertNewObjectForEntityForName:[Comment description] inManagedObjectContext:self.context
                                                       ];
                                   comment.commentText = textField.text;
                                   comment.date = [NSDate date];
                                   [self.book addCommentsObject:comment];
                                   [self.context save:nil];
                                   [self loadComments];
                               }];

    [alertcontroller addAction:okAction];
    [self presentViewController:alertcontroller animated:YES completion:^{
        nil;
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Comment *comment = [self.commentsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = comment.commentText;
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MMM dd, yyyy h:mm a"];
    NSString *dateString = [NSString stringWithFormat:@"Posted: %@",[formatter stringFromDate:comment.date]];
    cell.detailTextLabel.text = dateString;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentsArray.count;
}



@end
