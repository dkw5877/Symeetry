//
//  OpeningViewController.h
//  Symeetry
//
//  Created by Steve Toosevich on 4/26/14.
//  Copyright (c) 2014 Steve Toosevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpeningViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (instancetype)initWithNumber:(NSNumber *)number;

@end
