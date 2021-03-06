//
//  BooksCollectionViewCell.h
//  TestBQ
//
//  Created by Michel Barbou Salvador on 19/12/15.
//  Copyright © 2015 MBS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BooksCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;

@end
