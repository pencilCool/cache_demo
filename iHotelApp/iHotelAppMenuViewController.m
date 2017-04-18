//
//  iHotelAppMenuViewController.m
//  iHotelApp
//
//  Created by Mugunth on 28/6/12.
//  Copyright (c) 2012 Steinlogic. All rights reserved.
//

#import "iHotelAppMenuViewController.h"
#import "MenuItem.h"
#import "iHotelAppAppDelegate.h"
#define THRESHOLD 13.0

@interface iHotelAppMenuViewController ()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *menuItems;
@end

@implementation iHotelAppMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
      self.menuItems = @[].copy;
  }
  return self;
}

- (void)viewDidLoad
{
  self.title = NSLocalizedString(@"Menu", @"");
    
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
    
    
 
}

-(void) viewWillAppear:(BOOL)animated {
  
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                          NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory
                             stringByAppendingPathComponent:@"MenuItems.archive"];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:cachesDirectory]) {
        
        [fileManager createDirectoryAtPath:cachesDirectory withIntermediateDirectories:YES attributes:nil error:NULL];
    }
    
    NSMutableArray *cachedItems = [NSKeyedUnarchiver
                                   unarchiveObjectWithFile:archivePath];
    
    if(cachedItems == nil)
    {
        self.menuItems = [AppDelegate.engine localMenuItems];
    }
    else
    {
        self.menuItems = cachedItems;
    }
    
    NSTimeInterval stalenessLevel = [[[[NSFileManager defaultManager]
                                       attributesOfItemAtPath:archivePath error:nil]
                                      fileModificationDate] timeIntervalSinceNow];
    if(stalenessLevel > THRESHOLD)
    {
        self.menuItems = [AppDelegate.engine localMenuItems];
         [self.tableView reloadData];
    }
    else
    {
        
        [AppDelegate.engine fetchMenuItemsOnSucceeded:^(NSMutableArray *listOfModelBaseObjects) {
            self.menuItems = listOfModelBaseObjects;
            [self.tableView reloadData];
        } onError:^(NSError *engineError) {
            [UIAlertView showWithError:engineError];
        }];
    }

  [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
                                                         NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    NSString *archivePath = [cachesDirectory stringByAppendingPathComponent:@"MenuItems.archive"];
    [NSKeyedArchiver archiveRootObject:self.menuItems toFile:archivePath];
    
    [super viewWillDisappear:animated];
}




- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
  return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  // Return the number of sections.
  return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  // Return the number of rows in the section.
  return [self.menuItems count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
      static NSString *CellIdentifier = @"Cell";
      
      UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
      if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
      }
      
      // Configure the cell...
      MenuItem *item = [self.menuItems objectAtIndex:indexPath.row];
      cell.textLabel.text = item.title;
     cell.detailTextLabel.text = item.intro;
      cell.selectionStyle = UITableViewCellSelectionStyleNone;
      return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  // Navigation logic may go here. Create and push another view controller.
	
}

@end
