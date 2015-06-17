//
//  Settings.m
//  Nitrogen
//
//  Created by Riley Testut on 7/5/13.
//  Copyright (c) 2014 Nitrogen. All rights reserved.
//

#import "NitrogenSettingsViewController.h"
#import "OLGhostAlertView.h"

@interface NitrogenSettingsViewController () {
    NSBundle *bundle;
}

@property (weak, nonatomic) IBOutlet UINavigationItem *settingsTitle;

@property (weak, nonatomic) IBOutlet UILabel *frameSkipLabel;
@property (weak, nonatomic) IBOutlet UILabel *disableSoundLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *frameSkipControl;
@property (weak, nonatomic) IBOutlet UISwitch *disableSoundSwitch;

@property (weak, nonatomic) IBOutlet UILabel *controlPadStyleLabel;
@property (weak, nonatomic) IBOutlet UILabel *controlPositionLabel;
@property (weak, nonatomic) IBOutlet UILabel *controlOpacityLabel;

@property (weak, nonatomic) IBOutlet UISegmentedControl *controlPadStyleControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *controlPositionControl;
@property (weak, nonatomic) IBOutlet UISlider *controlOpacitySlider;

@property (weak, nonatomic) IBOutlet UILabel *showFPSLabel;
@property (weak, nonatomic) IBOutlet UILabel *showPixelGridLabel;

@property (weak, nonatomic) IBOutlet UISwitch *showFPSSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *showPixelGridSwitch;

@property (weak, nonatomic) IBOutlet UILabel *synchSoundLabel;
@property (weak, nonatomic) IBOutlet UISwitch *synchSoundSwitch;

@property (weak, nonatomic) IBOutlet UISwitch *enableJITSwitch;

@property (weak, nonatomic) IBOutlet UILabel *vibrateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *vibrateSwitch;

@property (weak, nonatomic) IBOutlet UILabel *dropboxLabel;

@property (weak, nonatomic) IBOutlet UISwitch *dropboxSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *cellularSwitch;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;

- (IBAction)controlChanged:(id)sender;

@end

@implementation NitrogenSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:78.0/255.0 green:156.0/255.0 blue:206.0/255.0 alpha:1.0]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"NDSResource" withExtension:@"bundle"]];
    
    self.settingsTitle.title = NSLocalizedStringFromTableInBundle(@"SETTINGS", nil, bundle, nil);
    
    self.frameSkipLabel.text = NSLocalizedStringFromTableInBundle(@"FRAME_SKIP", nil, bundle, nil);
    self.disableSoundLabel.text = NSLocalizedStringFromTableInBundle(@"DISABLE_SOUND", nil, bundle, nil);
    self.showPixelGridLabel.text = NSLocalizedStringFromTableInBundle(@"OVERLAY_PIXEL_GRID", nil, bundle, nil);

    self.controlPadStyleLabel.text = NSLocalizedStringFromTableInBundle(@"CONTROL_PAD_STYLE", nil, bundle, nil);
    self.controlPositionLabel.text = NSLocalizedStringFromTableInBundle(@"CONTROL_POSITION_PORTRAIT", nil, bundle, nil);
    self.controlOpacityLabel.text = NSLocalizedStringFromTableInBundle(@"CONTROL_OPACITY_PORTRAIT", nil, bundle, nil);
    
    self.dropboxLabel.text = NSLocalizedStringFromTableInBundle(@"ENABLE_DROPBOX", nil, bundle, nil);
    self.accountLabel.text = NSLocalizedStringFromTableInBundle(@"NOT_LINKED", nil, bundle, nil);
    
    self.showFPSLabel.text = NSLocalizedStringFromTableInBundle(@"SHOW_FPS", nil, bundle, nil);
    self.vibrateLabel.text = NSLocalizedStringFromTableInBundle(@"VIBRATION", nil, bundle, nil);

    [self.frameSkipControl setTitle:NSLocalizedStringFromTableInBundle(@"AUTO", nil, bundle, nil) forSegmentAtIndex:5];

    [self.controlPadStyleControl setTitle:NSLocalizedStringFromTableInBundle(@"DPAD", nil, bundle, nil) forSegmentAtIndex:0];
    [self.controlPadStyleControl setTitle:NSLocalizedStringFromTableInBundle(@"JOYSTICK", nil, bundle, nil) forSegmentAtIndex:1];

    [self.controlPositionControl setTitle:NSLocalizedStringFromTableInBundle(@"TOP", nil, bundle, nil) forSegmentAtIndex:0];
    [self.controlPositionControl setTitle:NSLocalizedStringFromTableInBundle(@"BOTTOM", nil, bundle, nil) forSegmentAtIndex:1];
    
    
    UIView *hiddenSettingsTapView = [[UIView alloc] initWithFrame:CGRectMake(245, 0, 75, 44)];
    
    UIBarButtonItem *hiddenSettingsBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:hiddenSettingsTapView];
    self.navigationItem.rightBarButtonItem = hiddenSettingsBarButtonItem;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(revealHiddenSettings:)];
    tapGestureRecognizer.numberOfTapsRequired = 3;
    [hiddenSettingsTapView addGestureRecognizer:tapGestureRecognizer];
    
}

- (NSString *)tableView:(UITableView *)tableView  titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedStringFromTableInBundle(@"EMULATOR", nil, bundle, nil);
            break;
        case 1:
            sectionName = NSLocalizedStringFromTableInBundle(@"CONTROLS", nil, bundle, nil);
            break;
        case 2:
            sectionName = NSLocalizedStringFromTableInBundle(@"DEVELOPER", nil, bundle, nil);
            break;
        case 3:
            sectionName = NSLocalizedStringFromTableInBundle(@"EXPERIMENTAL", nil, bundle, nil);
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (NSString *)tableView:(UITableView *)tableView  titleForFooterInSection:(NSInteger)section
{
    NSString *sectionName;
    switch (section)
    {
        case 0:
            sectionName = NSLocalizedStringFromTableInBundle(@"OVERLAY_PIXEL_GRID_DETAIL", nil, bundle, nil);
            break;
        case 3:
            sectionName = NSLocalizedStringFromTableInBundle(@"ARMLJIT_DETAIL", nil, bundle, nil);
            break;
        default:
            sectionName = @"";
            break;
    }
    return sectionName;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)controlChanged:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (sender == self.frameSkipControl) {
        NSInteger frameSkip = self.frameSkipControl.selectedSegmentIndex;
        if (frameSkip == 5) frameSkip = -1;
        [defaults setInteger:frameSkip forKey:@"frameSkip"];
    } else if (sender == self.disableSoundSwitch) {
        [defaults setBool:self.disableSoundSwitch.on forKey:@"disableSound"];
    } else if (sender == self.synchSoundSwitch) {
        [defaults setBool:self.synchSoundSwitch.on forKey:@"synchSound"];
    } else if (sender == self.showPixelGridSwitch) {
        [defaults setBool:self.showPixelGridSwitch.on forKey:@"showPixelGrid"];
    } else if (sender == self.controlPadStyleControl) {
        [defaults setInteger:self.controlPadStyleControl.selectedSegmentIndex forKey:@"controlPadStyle"];
    } else if (sender == self.controlPositionControl) {
        [defaults setInteger:self.controlPositionControl.selectedSegmentIndex forKey:@"controlPosition"];
    } else if (sender == self.controlOpacitySlider) {
        [defaults setFloat:self.controlOpacitySlider.value forKey:@"controlOpacity"];
    } else if (sender == self.showFPSSwitch) {
        [defaults setBool:self.showFPSSwitch.on forKey:@"showFPS"];
    } else if (sender == self.enableJITSwitch) {
        [defaults setBool:self.enableJITSwitch.on forKey:@"enableLightningJIT"];
    } else if (sender == self.vibrateSwitch) {
        [defaults setBool:self.vibrateSwitch.on forKey:@"vibrate"];
    } else if (sender == self.dropboxSwitch) {
    } else if (sender == self.cellularSwitch) {
        [defaults setBool:self.cellularSwitch.on forKey:@"enableDropboxCellular"];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSInteger frameSkip = [defaults integerForKey:@"frameSkip"];
    self.frameSkipControl.selectedSegmentIndex = frameSkip < 0 ? 5 : frameSkip;
    self.disableSoundSwitch.on = [defaults boolForKey:@"disableSound"];
    
    self.controlPadStyleControl.selectedSegmentIndex = [defaults integerForKey:@"controlPadStyle"];
    self.controlPositionControl.selectedSegmentIndex = [defaults integerForKey:@"controlPosition"];
    self.controlOpacitySlider.value = [defaults floatForKey:@"controlOpacity"];
    
    self.showFPSSwitch.on = [defaults boolForKey:@"showFPS"];
    self.showPixelGridSwitch.on = [defaults boolForKey:@"showPixelGrid"];
    self.synchSoundSwitch.on = [defaults boolForKey:@"synchSound"];
    
    self.enableJITSwitch.on = [defaults boolForKey:@"enableLightningJIT"];
    self.vibrateSwitch.on = [defaults boolForKey:@"vibrate"];
    
    self.dropboxSwitch.on = [defaults boolForKey:@"enableDropbox"];
    self.cellularSwitch.on = [defaults boolForKey:@"enableDropboxCellular"];
    
    if ([defaults boolForKey:@"enableDropbox"] == true) {
        self.accountLabel.text = NSLocalizedStringFromTableInBundle(@"LINKED", nil, bundle, nil);
    }
}

- (void)appDidBecomeActive:(NSNotification *)notification
{
    self.dropboxSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"enableDropbox"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:@"enableDropbox"] == true) {
        self.accountLabel.text = NSLocalizedStringFromTableInBundle(@"LINKED", nil, bundle, nil);
    }
}

#pragma mark - Hidden Settings

- (void)revealHiddenSettings:(UITapGestureRecognizer *)tapGestureRecognizer
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"revealHiddenSettings"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.tableView reloadData];
}

#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"revealHiddenSettings"]) {
        return 5;
    }
    
    return 4;//4
}

@end
