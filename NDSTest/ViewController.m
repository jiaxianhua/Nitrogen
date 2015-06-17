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
#import <NDS/NitrogenSettingsViewController.h>

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
    [self.navigationController pushViewController:rightMenu animated:YES];
    rightMenu.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(settingGame)];
}

- (void)settingGame {
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"NDSResource" withExtension:@"bundle"]];
    
    NitrogenSettingsViewController *nsvc = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:bundle] instantiateViewControllerWithIdentifier:@"NitrogenSettingsViewController"];
    [self.navigationController pushViewController:nsvc animated:YES];
}
@end
