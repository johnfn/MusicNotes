//
//  SequencerViewController.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/14/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "SequencerViewController.h"
#import "SequencerView.h"
#import "Song+Extension.h"
#import "DocumentManager.h"

@interface SequencerViewController ()
@property (weak, nonatomic) IBOutlet SequencerView *scrollView;

@end

@implementation SequencerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.scrollView addGestureRecognizer:singleTap];
    [self.scrollView loadData:self.noteData];
}

- (IBAction)rotationAction:(UIRotationGestureRecognizer *)sender {
    [self.scrollView play];
}

- (IBAction)saveButton:(UIButton *)sender {
    [self.scrollView save];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint= [gesture locationInView:self.scrollView];
    [self.scrollView receiveTap:touchPoint];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
