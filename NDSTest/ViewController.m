//
//  ViewController.m
//  NDSTest
//
//  Created by JiaXianhua on 15/6/11.
//  Copyright (c) 2015年 Nitrogen. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"

#import <NDS/NDS.h>
#import <NDS/NitrogenMain.h>
#import <NDS/NitrogenRightMenuViewController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)OpenNDS:(UIButton *)sender {
    NSArray *games = [NitrogenGame gamesAtPath:NitrogenMain.sharedInstance.documentsPath saveStateDirectoryPath:NitrogenMain.sharedInstance.batteryDir];
    if (games.count > 0) {
        NitrogenGame *game = games[0];
        [self OpenNDSMenu:game];
    }
}

- (void)OpenNDSMenu:(NitrogenGame *)game {
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"NDSResource" withExtension:@"bundle"]];
    
    NitrogenRightMenuViewController *rightMenu = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:bundle] instantiateViewControllerWithIdentifier:@"rightMenu"];
    rightMenu.game = game;
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = rightMenu;
}
@end
