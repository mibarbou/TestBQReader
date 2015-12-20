//
//  MBSBook.h
//  TestBQ
//
//  Created by Michel Barbou Salvador on 20/12/15.
//  Copyright © 2015 MBS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBSBook : NSObject

@property (strong, nonatomic) NSString *filename;
@property (strong, nonatomic) NSDate *modifiedDate;
@property (strong, nonatomic) NSString *fileSize;

- (id)initWithFilename:(NSString*)filename modifiedDate:(NSDate*)modifiedDate fileSize:(NSString*)fileSize;

@end
