//
//  AppDelegate.m
//  Nitrogen
//
//  Created by Nitrogen on 6/9/13.
//  Copyright (c) 2014 Nitrogen. All rights reserved.
//

#import "AppDelegate.h"
#import "NitrogenMain.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"NDSResource.bundle/plist"]]];
    
    return YES;
}

@end
