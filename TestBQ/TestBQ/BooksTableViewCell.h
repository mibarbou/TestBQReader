//
//  BooksTableViewCell.h
//  TestBQ
//
//  Created by Michel Barbou Salvador on 20/12/15.
//  Copyright © 2015 MBS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BooksTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;

@end
