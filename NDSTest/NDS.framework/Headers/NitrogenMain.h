//
//  NitrogenMain.h
//  Nitrogen
//
//  Created by JiaXianhua on 15/6/11.
//  Copyright (c) 2015年 Nitrogen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NitrogenEmulatorViewController.h"
#import "NitrogenGame.h"

@interface NitrogenMain : NSObject

@property (strong, nonatomic) NitrogenGame *currentGame;
@property (strong, nonatomic) NitrogenEmulatorViewController *currentEmulatorViewController;

+ (NitrogenMain *)sharedInstance;

- (NSString *)batteryDir;
- (NSString *)documentsPath;

- (void)startGame:(NitrogenGame *)game withSavedState:(NSInteger)savedState;


@end
