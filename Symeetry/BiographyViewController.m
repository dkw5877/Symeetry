//
//  BiographyViewController.m
//  Symeetry
//
//  Created by Steve Toosevich on 4/29/14.
//  Copyright (c) 2014 Steve Toosevich. All rights reserved.
//

#import "BiographyViewController.h"

@interface BiographyViewController ()
@property (weak, nonatomic) IBOutlet UITextView *myBioTextView;
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@end
// test commit
@implementation BiographyViewController

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