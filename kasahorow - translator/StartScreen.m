//
//  StartScreen.m
//  kasahorow - translator
//
//  Created by Hassan Ashraf on 04/11/2014.
//  Copyright (c) 2014 Hassan Ashraf. All rights reserved.
//
#import "LanguageDetails.h"
//#import "Constants.h"
#import "StartScreen.h"

@interface StartScreen ()

@end

@implementation StartScreen

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    LanguageDetails * languageObject = [[LanguageDetails alloc] init];
    if([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyForSavedLanguage])
    {
        languageObject.languageName = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyForSavedLanguage];
        languageObject.languageWebAddress = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyForSavedLanguageWebUrl];
        [self.webView scalesPageToFit];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:languageObject.languageWebAddress]]];
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:TRUE];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultKeyForSavedLanguage])
    {
        CGFloat screenWidth = self.view.frame.size.width;
        CGFloat screenHeight = self.view.frame.size.height;
        self.webView.frame = CGRectMake(0, 0, screenWidth,  screenHeight*0.88);
        self.webView.center = CGPointMake(screenWidth/2, screenHeight*0.56);
        
//        [[self.webView layer] setBorderColor:
//         [[UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1] CGColor]];
//        [[self.webView layer] setBorderWidth:2.75];
        
//      self.LanguagesButton.backgroundColor = [UIColor colorWithRed:9 green:0 blue:0 alpha:1];
        self.LanguagesButton.center = CGPointMake(screenWidth/2, screenHeight * 0.1);
        self.LanguagesButton.hidden = YES;
        
        
    }
    else
    {
        self.titleBar.hidden = YES;

    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
