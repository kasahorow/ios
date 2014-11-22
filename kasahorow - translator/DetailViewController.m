//
//  DetailViewController.m
//  kasahorow - translator
//
//  Created by Hassan Ashraf on 04/11/2014.
//  Copyright (c) 2014 Hassan Ashraf. All rights reserved.
//


#import "LanguageDetails.h"
#import "DetailViewController.h"
#import "MasterViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@property BOOL doHideMasterView;
@end

@implementation DetailViewController
@synthesize customPopoverController;
#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    LanguageDetails * languageDetailObject = [[LanguageDetails alloc] init];
    if (self.detailItem)
    {
                self.webView.hidden = NO;
        languageDetailObject = _detailItem;
        self.startScreenButton.hidden = YES;
        //self.containerView.hidden = YES;
    }
    else if([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyForSavedLanguage])
    {
        self.webView.hidden = NO;
        languageDetailObject.languageWebAddress = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyForSavedLanguageWebUrl];
        languageDetailObject.languageName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyForSavedLanguage];
        self.startScreenButton.hidden = YES;
//                self.containerView.hidden = YES;
    }
    else
    {
        //self.webView.hidden = YES;
        self.startScreenButton.hidden = NO;
        self.webView.hidden = YES;
//        self.containerView.hidden = YES;
        
    }
    [self setupWebViewWith:languageDetailObject];
}


- (void) configureViewForStartScreen
{
    
}


// Setting up Web View Controller
- (void)setupWebViewWith:(LanguageDetails*)languageDetailObject
{
    //[self.webView scalesPageToFit];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:languageDetailObject.languageWebAddress]]];
    
//    [[self.webView layer] setBorderColor:
//     [[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1] CGColor]];
//    
//    [[self.webView layer] setBorderWidth:2.75];
//    [self fullScreenWebview];
}

//Setting up webview to stretch all over the screen
- (void) fullScreenWebview
{
//    CGSize screenSize = self.view.frame.size;
//    self.webView.frame = [[UIScreen mainScreen] bounds];
// //   self.webView.frame = CGRectMake(0, 0, screenSize.width+1400, screenSize.height+1200);
//    self.webView.center = CGPointMake(screenSize.width/2, screenSize.height/2);
//    NSLog(@"%f", self.webView.frame.size.height);
//    CGRect screen = [AppDelegate getScreenDimensions];
//    self.webView.frame = screen;
//    NSLog(@"%@", screen);
//    _webView.frame = CGRectMake(0, 0, self.view.frame.size.width, [[UIScreen mainScreen] bounds].size.height);
//    NSLog(@"%f", _webView.frame.size.height);
//    _webView.center = CGPointMake(_webView.frame.size.width/2, _webView.frame.size.height/2);
    
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    if([self checkIfUserIsComingForTheFirstTime])
    {
        [self configureViewForStartScreen];
    }
    
    [self configureView];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if([self checkIfUserIsComingForTheFirstTime])
    {
        [self configureViewForStartScreen];
    }
    
    [self configureView];
    
}

- (BOOL)checkIfUserIsComingForTheFirstTime
{
    return FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"kasahorow", @"kasahorow");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

-(BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
{
    return YES;
 
}

//-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//    if(toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
//    {
////        [self fullScreenWebview];
//        
//        CGRect temp =  CGRectMake(64,0, self.view.frame.size.height, self.view.frame.size.width-64);
////        NSLog(@"%a",temp);
////        NSLog(@"%a", self.view.bounds);
//        _webView.frame = temp;
//        
//    }
//    else if(toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
//    {
//        [self fullScreenWebview];
//    }
//}

- (IBAction)startScreenButton:(id)sender {
    
    
    
    
}
@end
