//
//  SettingsViewController.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/17/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "SettingsViewController.h"
#import "Settings.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bpmLabel;

@end

@implementation SettingsViewController

- (IBAction)bpmSlider:(UISlider *)sender {
    [self.bpmLabel setText:[NSString stringWithFormat:@"BPM: %d", (int) sender.value]];
    [Settings setBPM:(int)sender.value];
}

- (IBAction)changeSongTitle:(UITextField *)sender {
    [Settings setTitle:sender.text];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
