//
//  MBSHomeViewController.m
//  TestBQ
//
//  Created by Michel Barbou Salvador on 15/12/15.
//  Copyright © 2015 MBS. All rights reserved.
//

#import "MBSHomeViewController.h"
#import <DropboxSDK/DropboxSDK.h>
#import "MBSBooksGridViewControllerCollectionViewController.h"
#import "MBSBooksListViewController.h"


@interface MBSHomeViewController ()<DBRestClientDelegate>

@property (nonatomic, strong) DBRestClient *restClient;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (strong, nonatomic) MBSBooksGridViewControllerCollectionViewController *gridViewController;
@property (strong, nonatomic) MBSBooksListViewController *listViewController;

@property (strong, nonatomic) NSMutableArray *books;



@end

@implementation MBSHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startDBRestClient) name:@"DBLinkedNotification" object:nil];
    
    [self startDBRestClient];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - DBRestClientDelegate

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    
    self.books = [NSMutableArray array];
    
    if (metadata.isDirectory) {
        
//        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
//            NSLog(@"	%@", file.filename);
           
            if ([file.filename hasSuffix:@".epub"]) {
                
                NSLog(@"EBOOK: %@",file.filename);
                
                NSString *path;
                NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@/",file.filename]];
                
                
//                [self.restClient loadFile:file.path intoPath:path];
                
                
                NSLog(@"hash: %@",file.icon);
                
                [self.books addObject:file.filename];
               
            }
        }
    }
    
    [self setupListViewController];

    
}

- (void)restClient:(DBRestClient *)client
loadMetadataFailedWithError:(NSError *)error {
    NSLog(@"Error loading metadata: %@", error);
}

- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
    NSLog(@"File loaded into path: %@", localPath);

}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
    NSLog(@"There was an error loading the file: %@", error);
}

- (void)startDBRestClient {
    
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:self];
        
        
    } else {
        
        self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        self.restClient.delegate = self;
        
        [self.restClient loadMetadata:@"/"];
    }
}

- (void)setupListViewController {
    
    self.listViewController = [[MBSBooksListViewController alloc]initWithBooks:self.books];
    
    [self addChildViewController:self.listViewController];
    self.listViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.listViewController.view];
    
    [self.listViewController didMoveToParentViewController:self];
    
    
}


@end
