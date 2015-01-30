//
//  PeopleListViewController.m
//  BookClub
//
//  Created by Yi-Chin Sun on 1/28/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "PeopleListViewController.h"
#import "Person.h"

@interface PeopleListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property NSArray *peopleArray;
@property Person *user;

@end

@implementation PeopleListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadPeople];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    Person *person = [self.peopleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = person.name;
    if ([self.user.friends containsObject:person])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.peopleArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *selectedPerson = [self.peopleArray objectAtIndex:indexPath.row];
    if ([self.user.friends containsObject:selectedPerson])
    {
        [self.user removeFriendsObject:selectedPerson];
    }
    else
    {
        [self.user addFriendsObject:selectedPerson];
    }
    [self.context save:nil];
    [self.tableView reloadData];
}

- (void)loadPeople
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[Person description]];
    request.predicate = [NSPredicate predicateWithFormat:@"name != %@", @"User"];
    self.peopleArray = [self.context executeFetchRequest:request error:nil];

    //If there are no people in Core Data, read people in from JSON
    if (self.peopleArray.count == 0)
    {
        [self loadDataFromJSON];
    }

    request.predicate = [NSPredicate predicateWithFormat:@"name == %@", @"User"];
    NSArray *userArray = [self.context executeFetchRequest:request error:nil];
    self.user = [userArray firstObject];
    [self.tableView reloadData];
}

- (void)loadDataFromJSON
{
    NSMutableArray *tempArray = [NSMutableArray new];
    NSURL *url = [NSURL URLWithString:@"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/18/friends.json"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

    Person *user = [NSEntityDescription insertNewObjectForEntityForName:[Person description] inManagedObjectContext:self.context];
    user.name = @"User";
    for (NSString *personName in json)
    {
        Person *newPerson = [NSEntityDescription insertNewObjectForEntityForName:[Person description] inManagedObjectContext:self.context];
        newPerson.name = personName;
        [tempArray addObject:newPerson];
    }
    self.peopleArray = tempArray;
    [self.context save:nil];
}


@end
