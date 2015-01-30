//
//  AddBookViewController.m
//  BookClub
//
//  Created by Yi-Chin Sun on 1/28/15.
//  Copyright (c) 2015 Yi-Chin Sun. All rights reserved.
//

#import "AddBookViewController.h"
#import "Person.h"
#import "Book.h"

@interface AddBookViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *bookImageView;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldCollection;

@property NSManagedObjectContext *context;



@end

@implementation AddBookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    for (UITextField *field in self.textFieldCollection)
    {
        field.clearButtonMode = YES;
    }
    self.context = [self.selectedFriend managedObjectContext];
}

- (IBAction)onAddBookButtonTapped:(id)sender
{
    Book *book = [NSEntityDescription insertNewObjectForEntityForName:[Book description] inManagedObjectContext:self.context];

    for (UITextField *field in self.textFieldCollection)
    {
        switch (field.tag)
        {
            case 0:
                book.title = field.text;
                break;
            case 1:
                book.author = field.text;
                break;
            case 2:
                book.genre = field.text;
                break;
            default:
                break;
        }
    }

    [self.selectedFriend addSuggestedBooksObject:book];
    
    [self.context save:nil];
    [self clearTextFields];

}

- (IBAction)onChangeImageButtonTapped:(id)sender
{

}

- (void)clearTextFields
{
    for (UITextField *field in self.textFieldCollection)
    {
        field.text = @"";
    }
}

@end
