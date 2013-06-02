//
//  LazyLoadTableImagesAppDelegate.h
//  LazyLoadTableImages
//
//  Created by Kshitiz Ghimire on 2/28/11.
//  Copyright 2011 Javra Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LazyLoadTableImagesViewController;

@interface LazyLoadTableImagesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    LazyLoadTableImagesViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet LazyLoadTableImagesViewController *viewController;

@end

