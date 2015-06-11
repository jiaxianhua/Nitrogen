//
//  AppDelegate.m
//  Nitrogen
//
//  Created by Nitrogen on 6/9/13.
//  Copyright (c) 2014 Nitrogen. All rights reserved.
//

#import "AppDelegate.h"
#import "SSZipArchive.h"
#import "OLGhostAlertView.h"
#import "SASlideMenuRootViewController.h"

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

@implementation AppDelegate

+ (AppDelegate*)sharedInstance
{
    return [[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (kCFCoreFoundationVersionNumber >= kCFCoreFoundationVersionNumber_iOS_7_0) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    } else {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Defaults" ofType:@"plist"]]];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[[NSString stringWithFormat:@"%@", url] substringToIndex:2] isEqualToString: @"db"]) {
        return YES;
    } else if (url.isFileURL && [[NSFileManager defaultManager] fileExistsAtPath:url.path] && [url.path.stringByDeletingLastPathComponent.lastPathComponent isEqualToString:@"Inbox"]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        NSError *err = nil;
        if ([url.pathExtension.lowercaseString isEqualToString:@"zip"]) {
            // expand zip
            // create directory to expand
            NSString *dstDir = [NSTemporaryDirectory() stringByAppendingPathComponent:url.path.lastPathComponent];
            if ([fm createDirectoryAtPath:dstDir withIntermediateDirectories:YES attributes:nil error:&err] == NO) {
                NSLog(@"Could not create directory to expand zip: %@ %@", dstDir, err);
                [fm removeItemAtURL:url error:NULL];
                return NO;
            }
            
            // expand
            [SSZipArchive unzipFileAtPath:url.path toDestination:dstDir];
            
            // move .Nitrogen to documents and .dsv to battery
            for (NSString *path in [fm subpathsAtPath:dstDir]) {
                if ([path.pathExtension.lowercaseString isEqualToString:@"Nitrogen"]) {
                    NSLog(@"found ROM in zip: %@", path);
                    [fm moveItemAtPath:[dstDir stringByAppendingPathComponent:path] toPath:[self.documentsPath stringByAppendingPathComponent:path.lastPathComponent] error:NULL];
                } else if ([path.pathExtension.lowercaseString isEqualToString:@"dsv"]) {
                    NSLog(@"found save in zip: %@", path);
                    [fm moveItemAtPath:[dstDir stringByAppendingPathComponent:path] toPath:[self.batteryDir stringByAppendingPathComponent:path.lastPathComponent] error:NULL];
                }
            }
            
            // remove unzip dir
            [fm removeItemAtPath:dstDir error:NULL];
        } else if ([url.pathExtension.lowercaseString isEqualToString:@"Nitrogen"]) {
            // move to documents
            [fm moveItemAtPath:url.path toPath:[self.documentsPath stringByAppendingPathComponent:url.lastPathComponent] error:&err];
        }
        
        // remove inbox (shouldn't be needed)
        [fm removeItemAtPath:[self.documentsPath stringByAppendingPathComponent:@"Inbox"] error:NULL];
        
        return YES;
    }
    return NO;
}

- (NSString *)batteryDir
{
    return [self.documentsPath stringByAppendingPathComponent:@"Battery"];
}

- (NSString *)documentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSString *)appKey
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"dbAppKey"];
}

- (NSString *)appSecret
{
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"dbAppSecret"];
}

- (void)startGame:(NitrogenGame *)game withSavedState:(NSInteger)savedState
{
    // TODO: check if resuming current game, also call EMU_closeRom maybe
    NitrogenEmulatorViewController *emulatorViewController = (NitrogenEmulatorViewController *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"emulatorView"];
    emulatorViewController.game = game;
    emulatorViewController.saveState = [game pathForSaveStateAtIndex:savedState];
    [AppDelegate sharedInstance].currentEmulatorViewController = emulatorViewController;
    SASlideMenuRootViewController *rootViewController = (SASlideMenuRootViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController doSlideIn:nil];
    [rootViewController presentModalViewController:emulatorViewController animated:YES];
}


@end
