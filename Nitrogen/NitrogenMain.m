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
    NitrogenEmulatorViewController *emulatorViewController = (NitrogenEmulatorViewController *)[[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"emulatorView"];
    emulatorViewController.game = game;
    emulatorViewController.saveState = [game pathForSaveStateAtIndex:savedState];
    [NitrogenMain sharedInstance].currentEmulatorViewController = emulatorViewController;
    SASlideMenuRootViewController *rootViewController = (SASlideMenuRootViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    [rootViewController doSlideIn:nil];
    [rootViewController presentModalViewController:emulatorViewController animated:YES];
}

@end
