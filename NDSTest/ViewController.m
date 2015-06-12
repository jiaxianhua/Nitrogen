//
//  ViewController.m
//  NDSTest
//
//  Created by JiaXianhua on 15/6/11.
//  Copyright (c) 2015年 Nitrogen. All rights reserved.
//

#import "ViewController.h"

#import "NDS.h"

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
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"NDSResource" withExtension:@"bundle"]];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:bundle];
    SASlideMenuRootViewController *vc = [sb instantiateViewControllerWithIdentifier:@"SASlideMenuRootViewController"];
    
    [self showViewController:vc sender:self];
}
@end
