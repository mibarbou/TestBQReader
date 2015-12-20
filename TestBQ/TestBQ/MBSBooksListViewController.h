//
//  MBSBooksListViewController.h
//  TestBQ
//
//  Created by Michel Barbou Salvador on 16/12/15.
//  Copyright © 2015 MBS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBSBooksListViewController, MBSBook;

@protocol MBSBooksListViewControllerDelegate <NSObject>

- (void)didSelectBook:(MBSBook *)book;


@end

@interface MBSBooksListViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray *books;
@property (nonatomic, weak) id<MBSBooksListViewControllerDelegate> delegate;


- (id)initWithBooks:(NSMutableArray *)books;

@end
