//
//  MBSHomeViewController.m
//  TestBQ
//
//  Created by Michel Barbou Salvador on 15/12/15.
//  Copyright © 2015 MBS. All rights reserved.
//

#import "MBSHomeViewController.h"
#import <DropboxSDK/DropboxSDK.h>


@interface MBSHomeViewController ()

@end

@implementation MBSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
    }
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

@end
