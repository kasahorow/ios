//
//  MasterViewController.m
//  kasahorow - translator
//
//  Created by Hassan Ashraf on 04/11/2014.
//  Copyright (c) 2014 Hassan Ashraf. All rights reserved.
//

//NSString * kJsonFileAddress = @"/Users/hassanashraf/Documents/Work/Clients/Afia/kasahorow - translator/kasahorow - translator/kasahorowLanguages.json";

NSString * kJsonFileAddress = @"kasahorowLanguages";
NSString * kJsonObjectKey = @"array";
NSString * kLanguageTableViewHeading = @"kasahorow";
NSString * kLanguageNameKey = @"language";
NSString * kWebUrlKey = @"url";
NSString * kSegueIdentifier = @"showDetail";


#import "MasterViewController.h"
#import "LanguageDetails.h"
#import "DetailViewController.h"
//#import "Constants.h"
@interface MasterViewController () {
    NSMutableArray *_objects;
    NSMutableArray *_modelObjects;
    Constants *constantsObject;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        if ([self respondsToSelector:@selector(preferredContentSize)]) {
            self.preferredContentSize = CGSizeMake(320.0, 600.0);
        }
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = kLanguageTableViewHeading;
    
    NSData * fileContent = [self getContentsOfFile:kJsonFileAddress];
    NSArray * languagesArray = [self getLanguagesArrayFromData:fileContent];
    [self updateModelArraysWith:languagesArray];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDate *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        LanguageDetails *object = _modelObjects[indexPath.row];
        self.detailViewController.detailItem = object;
        [self saveLanguageToUserDefaults:object];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:kSegueIdentifier])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        LanguageDetails *languageObject = _modelObjects[indexPath.row];
        [[segue destinationViewController] setDetailItem:languageObject];
            
        //Saving the Language in NSUserDefaults for remembering it the next time, application opens.
        [self saveLanguageToUserDefaults:languageObject];
        
    }
}

#pragma Kasahorow App Functions

- (NSData*)getContentsOfFile:(NSString*)jsonFileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fileAddress = [[NSBundle mainBundle] pathForResource:jsonFileName ofType:@"json"];
    if ([fileManager fileExistsAtPath: fileAddress] == YES)
    {
        NSData *data = [fileManager contentsAtPath: fileAddress];
        return data;
    }
    
    // Return NULL if file does not exists
    return NULL;
}

- (NSArray *)getLanguagesArrayFromData:(NSData*)jsonData
{
    NSError* error;
    NSDictionary * jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    return [jsonObject objectForKey:kJsonObjectKey];
}

- (void)updateModelArraysWith:(NSArray*)languagesArray
{
    if (!_objects)
    {
        _objects = [[NSMutableArray alloc] init];
    }
    if(!_modelObjects)
    {
        _modelObjects = [[NSMutableArray alloc] init];
    }

    for(int i=0 ; i < languagesArray.count ; i++)
    {
        LanguageDetails * languageDetailObject =  [[LanguageDetails alloc] init];
        NSDictionary * LanguageDetails = [languagesArray objectAtIndex:i];
        languageDetailObject.languageName = [LanguageDetails objectForKey:kLanguageNameKey];
        languageDetailObject.languageWebAddress = [LanguageDetails objectForKey:kWebUrlKey];
        [_objects insertObject:languageDetailObject.languageName atIndex:0];
        [_modelObjects insertObject:languageDetailObject atIndex:0];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];

        // Adding Table View Rows
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)saveLanguageToUserDefaults:(LanguageDetails*)languageObject
{
    //Saving the Language in NSUserDefaults for remembering it the next time, application opens.
    [[NSUserDefaults standardUserDefaults] setObject:languageObject.languageName forKey:kUserDefaultKeyForSavedLanguage];
    [[NSUserDefaults standardUserDefaults] setObject:languageObject.languageWebAddress forKey:kUserDefaultKeyForSavedLanguageWebUrl];
}

@end
