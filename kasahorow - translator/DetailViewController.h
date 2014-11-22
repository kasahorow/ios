//
//  DetailViewController.h
//  kasahorow - translator
//
//  Created by Hassan Ashraf on 04/11/2014.
//  Copyright (c) 2014 Hassan Ashraf. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)startScreenButton:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *startScreenButton;

@property (nonatomic, retain) UIPopoverController *customPopoverController;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
