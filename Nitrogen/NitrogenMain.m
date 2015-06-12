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
    
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    SASlideMenuRootViewController *sasvc = (SASlideMenuRootViewController *)vc;
    if ([sasvc respondsToSelector:@selector(doSlideIn:)]) {
        [sasvc doSlideIn:nil];
    }
    [vc showDetailViewController:emulatorViewController sender:nil];
}

@end
