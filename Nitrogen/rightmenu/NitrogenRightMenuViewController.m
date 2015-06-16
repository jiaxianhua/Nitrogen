//
//  NitrogenRightMenuViewController.m
//  Nitrogen
//
//  Created by David Chavez on 7/15/13.
//  Copyright (c) 2014 Nitrogen. All rights reserved.
//

#import "NitrogenRightMenuViewController.h"
#import "NitrogenMain.h"

@interface NitrogenRightMenuViewController ()

@end

@implementation NitrogenRightMenuViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.titleLabel.text = self.game.title;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    SASlideMenuRootViewController *rootViewController = (SASlideMenuRootViewController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    if ([rootViewController respondsToSelector:@selector(removeRightMenu)]) {
        [rootViewController removeRightMenu];
    }
}

#pragma mark - Table View data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1 + self.game.numberOfSaveStates;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell"];
    
    cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NDSResource.bundle/row"]];
    cell.selectedBackgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NDSResource.bundle/rowselected"]];
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"NDSResource.bundle/disclosure"]];
    
    NSBundle *bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"NDSResource" withExtension:@"bundle"]];
    
    // text
    cell.textLabel.text = NSLocalizedStringFromTableInBundle(@"LAUNCH_GAME", nil, bundle, nil);
    cell.detailTextLabel.text = NSLocalizedString(@"LAUNCH_GAME_DETAIL", nil);
    cell.detailTextLabel.text = NSLocalizedStringFromTableInBundle(@"LAUNCH_GAME_DETAIL", nil, bundle, nil);
    
    // detail
    if (indexPath.row > 0) {
        cell.textLabel.text = (indexPath.row == 1 && self.game.hasPauseState)
        ? NSLocalizedStringFromTableInBundle(@"LAUNCH_GAME_DETAIL", nil, bundle, nil)
        : [self.game nameOfSaveStateAtIndex:indexPath.row - 1];
        cell.detailTextLabel.text =
        [NSDateFormatter localizedStringFromDate:
         [self.game dateOfSaveStateAtIndex:indexPath.row -1]
                                       dateStyle:NSDateFormatterMediumStyle
                                       timeStyle:NSDateFormatterMediumStyle];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row > 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if ([self.game deleteSaveStateAtIndex:indexPath.row - 1]) [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        if (self.game.numberOfSaveStates == 0) [(SASlideMenuRootViewController*)self.parentViewController doSlideIn:nil];
    }
}

#pragma mark - Table View delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [NitrogenMain.sharedInstance startGame:self.game withSavedState:indexPath.row - 1];
}

@end
