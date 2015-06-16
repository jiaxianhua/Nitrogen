//
//  NitrogenMain.m
//  Nitrogen
//
//  Created by JiaXianhua on 15/6/11.
//  Copyright (c) 2015年 Nitrogen. All rights reserved.
//

#import "NitrogenMain.h"
#import "SSZipArchive.h"
#import "OLGhostAlertView.h"
#import "SASlideMenuRootViewController.h"

#ifndef kCFCoreFoundationVersionNumber_iOS_7_0
#define kCFCoreFoundationVersionNumber_iOS_7_0 847.20
#endif

static NitrogenMain *sharedInstance = nil;
@implementation NitrogenMain

+ (NitrogenMain *)sharedInstance
{
    if (sharedInstance == nil) {
        sharedInstance = [[NitrogenMain alloc] init];
    }
    
    return sharedInstance;
}

- (NSString *)batteryDir
{
    return [self.documentsPath stringByAppendingPathComponent:@"Battery"];
}

- (NSString *)documentsPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (void)startGame:(NitrogenGame *)game withSavedState:(NSInteger)savedState
{
    // TODO: check if resuming current game, also call EMU_closeRom maybe
    
    NSBundle *bundle = nil;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *appDirectory = [[NSBundle mainBundle] bundlePath];
    NSString *filePath = [appDirectory stringByAppendingPathComponent:@"NDSResource.bundle"];
    if([fileManager fileExistsAtPath:filePath]) {
        bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"NDSResource" withExtension:@"bundle"]];
    }
    
    NitrogenEmulatorViewController *emulatorViewController = (NitrogenEmulatorViewController *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:bundle] instantiateViewControllerWithIdentifier:@"emulatorView"];
    [emulatorViewController defaultsChanged:nil];
    emulatorViewController.game = game;
    emulatorViewController.saveState = [game pathForSaveStateAtIndex:savedState];
    [NitrogenMain sharedInstance].currentEmulatorViewController = emulatorViewController;
    
    UIViewController *vc = [self getCurrentRootViewController];
    SASlideMenuRootViewController *sasvc = (SASlideMenuRootViewController *)vc;
    if ([sasvc respondsToSelector:@selector(doSlideIn:)]) {
        [sasvc doSlideIn:nil];
    }
    
    int ios_version = [self get_ios_version_major];
    
    if (ios_version >= 8.0) {
        [vc showDetailViewController:emulatorViewController sender:self];
    }
    else {
        [vc presentViewController:emulatorViewController animated:YES completion:nil];
    }
}

- (int)get_ios_version_major {
    static int version = -1;
    
    if (version < 0)
        version = (int)[[[UIDevice currentDevice] systemVersion] floatValue];
    
    return version;
}

- (UIViewController *)getCurrentRootViewController {
    UIViewController *result;
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (topWindow.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows){
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    
    UIView *rootView = [topWindow subviews].firstObject;
    id nextResponder = [rootView nextResponder];
    
    if ([nextResponder isMemberOfClass:[UIViewController class]]){
        result = nextResponder;
    }
    else if ([nextResponder isMemberOfClass:[UITabBarController class]] | [nextResponder isMemberOfClass:[UINavigationController class]]){
        result = [self findViewController:nextResponder];
    }
    else if ([topWindow respondsToSelector:@selector(rootViewController)] && topWindow.rootViewController != nil){
        result = topWindow.rootViewController;
    }
    
    else{
        NSAssert(NO, @"找不到顶端VC");
    }
    return result;
}

- (UIViewController *)findViewController:(id)controller{
    if ([controller isMemberOfClass:[UINavigationController class]]) {
        return [self findViewController:[(UINavigationController *)controller visibleViewController]];
    }
    else if ([controller isMemberOfClass:[UITabBarController class]]){
        return [self findViewController:[(UITabBarController *)controller selectedViewController]];
    }
    else if ([controller isKindOfClass:[UIViewController class]]){
        return controller;
    }
    else{
        NSAssert(NO, @"找不到顶端VC");
        return nil;
    }
}

@end
