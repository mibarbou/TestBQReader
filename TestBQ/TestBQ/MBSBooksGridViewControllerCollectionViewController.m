//
//  MBSBooksGridViewControllerCollectionViewController.m
//  TestBQ
//
//  Created by Michel Barbou Salvador on 16/12/15.
//  Copyright © 2015 MBS. All rights reserved.
//

#import "MBSBooksGridViewControllerCollectionViewController.h"
#import "BooksCollectionViewCell.h"
#import "MBSBook.h"

@interface MBSBooksGridViewControllerCollectionViewController ()


@end

@implementation MBSBooksGridViewControllerCollectionViewController

- (id)initWithBooks:(NSMutableArray *)books layout:(UICollectionViewLayout*)layout{

    if (self = [super initWithCollectionViewLayout:layout]) {
        
        _books = books;
    }
    
    return self;
}

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //Register nib for custom Item cell
    UINib *nib = [UINib nibWithNibName:@"BooksCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.books.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    BooksCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    MBSBook *book = [self.books objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = book.filename;
    cell.sizeLabel.text = book.fileSize;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd/MM/YY"];
    
    cell.dateLabel.text = [NSString stringWithFormat:@"%@",[formatter stringFromDate:book.modifiedDate]];
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MBSBook *selectedBook = [self.books objectAtIndex:indexPath.row];
    
    [self.delegate didSelectBookInCollectionView:selectedBook];
}



@end
