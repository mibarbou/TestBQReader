//
//  MBSBooksGridViewControllerCollectionViewController.h
//  TestBQ
//
//  Created by Michel Barbou Salvador on 16/12/15.
//  Copyright © 2015 MBS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBSBooksGridViewControllerCollectionViewController, MBSBook;

@protocol  MBSBooksGridCollectionViewControllerDelegate <NSObject>

- (void)didSelectBookInCollectionView:(MBSBook *)book;


@end

@interface MBSBooksGridViewControllerCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSMutableArray *books;
@property (nonatomic, weak) id<MBSBooksGridCollectionViewControllerDelegate> delegate;


- (id)initWithBooks:(NSMutableArray *)books layout:(UICollectionViewLayout*)layout;

@end
