//
//  SettingsViewController.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/17/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "SettingsViewController.h"
#import "Settings.h"

@interface SettingsViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *bpmLabel;
@property (weak, nonatomic) IBOutlet UISlider *bpmSliderObject;
@property (weak, nonatomic) IBOutlet UITextField *songName;
@end

@implementation SettingsViewController 

- (IBAction)bpmSlider:(UISlider *)sender {
    [self.bpmLabel setText:[NSString stringWithFormat:@"BPM: %d", (int) sender.value]];
    [Settings setBPM:(int)sender.value];
}

- (IBAction)changeSongTitle:(UITextField *)sender {
    NSLog(@"You changed the title!");
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.songName resignFirstResponder];
    return NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.songName setText:[Settings getTitle]];
    self.bpmSliderObject.value = [Settings getBPM];

    [self bpmSlider:self.bpmSliderObject];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.songName.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
