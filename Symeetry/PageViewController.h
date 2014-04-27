//
//  PageViewController.h
//  Symeetry
//
//  Created by Steve Toosevich on 4/26/14.
//  Copyright (c) 2014 Steve Toosevich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageViewController : UIPageViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

- (id)initWithViewControllers:(NSArray *)viewControllers transitionStyle:(UIPageViewControllerTransitionStyle)style;
- (id)initWithViewControllerClassNames:(NSArray *)classNames transitionStyle:(UIPageViewControllerTransitionStyle)style;

@end
