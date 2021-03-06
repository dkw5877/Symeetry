//
//  CameraViewController.m
//  Symeetry
//
//  Created by Steve Toosevich on 4/26/14.
//  Copyright (c) 2014 Steve Toosevich. All rights reserved.
//

#import "CameraViewController.h"
#import "PhotoViewController.h"

@interface CameraViewController ()



@end

@implementation CameraViewController

+(instancetype)sharedCameraViewController {
    static CameraViewController *manager = nil;
    if (!manager)
    {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        manager = [storyboard instantiateViewControllerWithIdentifier:@"CameraViewController"];
    }
    return manager;
}
- (IBAction)onAddPhotoButtonPressed:(id)sender
{
    self.addPhotoButton.enabled = NO;
}

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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)onCamuraButtonPressed:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UIViewController* photoViewController = [storyboard instantiateViewControllerWithIdentifier:@"PhotoViewController"];
    photoViewController.editing = NO;
    [self presentViewController:photoViewController animated:YES completion:nil];
    //CameraSetOnBoardingModalSegue
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
