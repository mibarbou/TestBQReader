//
//  MBSBooksGridViewControllerCollectionViewController.m
//  TestBQ
//
//  Created by Michel Barbou Salvador on 16/12/15.
//  Copyright © 2015 MBS. All rights reserved.
//

#import "MBSBooksGridViewControllerCollectionViewController.h"
#import "BooksCollectionViewCell.h"

@interface MBSBooksGridViewControllerCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *books;


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
    
    //leemos el nib
    UINib *nib = [UINib nibWithNibName:@"BooksCollectionViewCell" bundle:nil];
    // Lo registramos
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuseIdentifier];
    
    // Do any additional setup after loading the view.
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
    
    NSString *fileName = [self.books objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = fileName;
    
    
    return cell;
}

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}



@end
