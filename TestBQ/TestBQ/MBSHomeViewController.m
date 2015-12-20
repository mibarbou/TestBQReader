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
#import "MBSBook.h"
#import "MBSePubReaderViewController.h"




@interface MBSHomeViewController ()<DBRestClientDelegate, UIActionSheetDelegate, MBSBooksListViewControllerDelegate, MBSBooksGridCollectionViewControllerDelegate>

@property (nonatomic, strong) DBRestClient *restClient;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) UIBarButtonItem *orderByButton;

@property (strong, nonatomic) MBSBooksGridViewControllerCollectionViewController *gridViewController;
@property (strong, nonatomic) MBSBooksListViewController *listViewController;

@property (strong, nonatomic) NSMutableArray *books;


@end

@implementation MBSHomeViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Your eBooks";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.segmentedControl];
    
    self.orderByButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(orderBy)];
    self.orderByButton.title = @"order by";
    self.navigationItem.rightBarButtonItem = self.orderByButton;
    
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

#pragma mark - SegmentedContro Action

- (IBAction)segmentedControlValueChanged:(UISegmentedControl*)sender {
   
    
    if (sender.selectedSegmentIndex == 0) {
        
        [self.gridViewController.view removeFromSuperview];
        [self.gridViewController removeFromParentViewController];
        self.gridViewController = nil;
        [self setupListViewController];
   
    } else {
        
        [self.listViewController.view removeFromSuperview];
        [self.listViewController removeFromParentViewController];
        self.listViewController = nil;
        [self setupGridViewController];

    }
  
}

#pragma mark - Ordering related methods

- (void)orderBy {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Order your books by:" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Date" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self sortBooksListByProperty:@"modifiedDate" ascendingOrder:NO];
        
        
    } ]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Name" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self sortBooksListByProperty:@"filename" ascendingOrder:YES];
        
        
    } ]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Size" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self sortBooksListByProperty:@"fileSize" ascendingOrder:NO];
        
        
    } ]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        
    } ]];
    
    // show action sheet
    actionSheet.popoverPresentationController.barButtonItem = self.orderByButton;
    actionSheet.popoverPresentationController.sourceView = self.view;
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

-(void)sortBooksListByProperty:(NSString*)propertyName ascendingOrder:(BOOL)ascendingOrder{
    
    NSSortDescriptor *firstDescriptor = [NSSortDescriptor sortDescriptorWithKey:propertyName ascending:ascendingOrder];
    NSArray *sortsDescriptors = [NSArray arrayWithObjects:firstDescriptor, nil];
    NSArray *sortedArray = [self.books sortedArrayUsingDescriptors:sortsDescriptors];
    self.books = sortedArray.mutableCopy;
    
    
    if ([[[self childViewControllers]lastObject]isKindOfClass:[MBSBooksListViewController class]]) {
        
        self.listViewController.books = self.books;
        [self.listViewController.tableView reloadData];
        
    } else {
        
        self.gridViewController.books = self.books;
        [self.gridViewController.collectionView reloadData];
    }
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
                
                NSString *path  = [NSTemporaryDirectory() stringByAppendingPathComponent:file.filename];
                NSFileManager *fileManager = [NSFileManager defaultManager];
               
                
                if ([fileManager fileExistsAtPath:path]) {
                    // epub file is already in temp directory
             
                } else {
                    
                    [self.restClient loadFile:file.path intoPath:path];
                }
                
                MBSBook *book = [[MBSBook alloc]initWithFilename:file.filename
                                                    modifiedDate:file.lastModifiedDate
                                                        fileSize:file.humanReadableSize];
                
                [self.books addObject:book];
         
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

#pragma mark - MBSBooksListViewControllerDelegate

- (void)didSelectBook:(MBSBook *)book {
    
    NSString *path  = [NSTemporaryDirectory() stringByAppendingPathComponent:book.filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    if ([fileManager fileExistsAtPath:path]) {
        // epub file is already in temp directory
        
        MBSePubReaderViewController *ePubVC = [[MBSePubReaderViewController alloc]initWithBook:book];
        [self.navigationController pushViewController:ePubVC animated:YES];
        
    } else {
        // show alert
        UIAlertController *popAlert = [UIAlertController alertControllerWithTitle:@"Attention"
                                                                          message:[NSString stringWithFormat:@"The selected book with filename -- %@ -- hasn't been download it yet, wait a moment and try again",book.filename]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
        [popAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        } ]];
        
        [self presentViewController:popAlert animated:YES completion:nil];
    }
   
}

#pragma mark - MBSBooksGridCollectionViewControllerDelegate

-(void)didSelectBookInCollectionView:(MBSBook *)book {
    
    NSString *path  = [NSTemporaryDirectory() stringByAppendingPathComponent:book.filename];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    if ([fileManager fileExistsAtPath:path]) {
        // epub file is already in temp directory
        
        MBSePubReaderViewController *ePubVC = [[MBSePubReaderViewController alloc]initWithBook:book];
        [self.navigationController pushViewController:ePubVC animated:YES];
        
    } else {
        // show alert
        UIAlertController *popAlert = [UIAlertController alertControllerWithTitle:@"Attention"
                                                                          message:[NSString stringWithFormat:@"The selected book with filename -- %@ -- hasn't been download it yet, wait a moment and try again",book.filename]
                                                                   preferredStyle:UIAlertControllerStyleAlert];
        [popAlert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            
        } ]];
        
        [self presentViewController:popAlert animated:YES completion:nil];
        
    }

}


#pragma mark - SettingUp childViewControllers Methods

- (void)setupListViewController {
    
    self.listViewController = [[MBSBooksListViewController alloc]initWithBooks:self.books];
    self.listViewController.delegate = self;
    [self addChildViewController:self.listViewController];
    self.listViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.listViewController.view];
    
    [self.listViewController didMoveToParentViewController:self];
 
}

- (void)setupGridViewController {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(150, 200);
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 4;
    layout.minimumLineSpacing = 14;
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
//    layout.headerReferenceSize = CGSizeMake(30, 30);
    
    self.gridViewController = [[MBSBooksGridViewControllerCollectionViewController alloc]initWithBooks:self.books layout:layout];
    self.gridViewController.delegate = self;
    [self addChildViewController:self.gridViewController];
    self.gridViewController.view.frame = self.contentView.bounds;
    [self.contentView addSubview:self.gridViewController.view];
    
    [self.gridViewController didMoveToParentViewController:self];
    
    
}


@end
