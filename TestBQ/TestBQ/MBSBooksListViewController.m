//
//  MBSBooksListViewController.m
//  TestBQ
//
//  Created by Michel Barbou Salvador on 16/12/15.
//  Copyright © 2015 MBS. All rights reserved.
//

#import "MBSBooksListViewController.h"
#import "MBSBook.h"
#import "BooksTableViewCell.h"

@interface MBSBooksListViewController ()


@end

@implementation MBSBooksListViewController

- (id)initWithBooks:(NSMutableArray *)books {
    
    if (self = [super init]) {
        
        _books = books;
    }
    
    return self;
}

static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //Register nib for custom Item cell
    UINib *nib = [UINib nibWithNibName:@"BooksTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.books.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    BooksTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell==nil) {
        cell=[[BooksTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        
    }
    
    MBSBook *book = [self.books objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = book.filename;
    cell.sizeLabel.text = book.fileSize;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YY"];
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:book.modifiedDate]];
    
    return cell;
}


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    MBSBook *selectedBook = [self.books objectAtIndex:indexPath.row];
    
    [self.delegate didSelectBook:selectedBook];
    
}


@end
