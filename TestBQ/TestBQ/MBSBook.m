//
//  MBSBook.m
//  TestBQ
//
//  Created by Michel Barbou Salvador on 20/12/15.
//  Copyright © 2015 MBS. All rights reserved.
//

#import "MBSBook.h"

@implementation MBSBook

- (id)initWithFilename:(NSString*)filename modifiedDate:(NSDate*)modifiedDate fileSize:(NSString*)fileSize{
    
    if (self = [super init]) {
        
        _filename = filename;
        _modifiedDate = modifiedDate;
        _fileSize = fileSize;
        
    }
    
    return self;
}

@end
