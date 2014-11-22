//
//  iPadTableViewController.m
//  kasahorow - translator
//
//  Created by Hassan Ashraf on 17/11/2014.
//  Copyright (c) 2014 Hassan Ashraf. All rights reserved.
//

NSString * kJsonFileAddress1 = @"kasahorowLanguages";
NSString * kJsonObjectKey1 = @"array";
NSString * kLanguageTableViewHeading1 = @"kasahorow";
NSString * kLanguageNameKey1 = @"language";
NSString * kWebUrlKey1 = @"url";
NSString * kSegueIdentifier1 = @"showDetail";

#import "iPadTableViewController.h"

@interface iPadTableViewController ()
{
    NSMutableArray *_objects;
    NSMutableArray *_modelObjects;
}
@end

@implementation iPadTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",kLanguageTableViewHeading1 ];
    self.navigationItem.leftBarButtonItem = NULL;
    self.navigationItem.backBarButtonItem = NULL;

    NSData * fileContent = [self getContentsOfFile:kJsonFileAddress1];
    NSArray * languagesArray = [self getLanguagesArrayFromData:fileContent];
    [self updateModelArraysWith:languagesArray];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *object = _objects[indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
    
    // Configure the cell...
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        LanguageDetails *object = _modelObjects[indexPath.row];
        [self saveLanguageToUserDefaults:object];
        [self.navigationController popToRootViewControllerAnimated:YES];
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
    return [jsonObject objectForKey:kJsonObjectKey1];
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
        languageDetailObject.languageName = [LanguageDetails objectForKey:kLanguageNameKey1];
        languageDetailObject.languageWebAddress = [LanguageDetails objectForKey:kWebUrlKey1];
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
