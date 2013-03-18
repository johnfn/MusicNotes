//
//  SequencerViewController.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/14/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "Settings.h"
#import "SequencerViewController.h"
#import "SequencerView.h"
#import "Song+Extension.h"
#import "DocumentManager.h"

@interface SequencerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet SequencerView *scrollView;
@property (nonatomic) bool unsavedChanges;
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

- (void)setUnsavedChanges:(bool)unsavedChanges {
    if (unsavedChanges) {
        [self.saveButton setTitle:@"Save*" forState:UIControlStateNormal];
    } else {
        [self.saveButton setTitle:@"Save" forState:UIControlStateNormal];
    }
    
    _unsavedChanges = unsavedChanges;
}

- (void)viewDidLoad
{
}

- (IBAction)rotationAction:(UIRotationGestureRecognizer *)sender {
    static CGFloat gestureLength = 0.0;

    if (sender.state == UIGestureRecognizerStateBegan) {
        gestureLength = 0.0;
        self.scrollView.rewinding = true;
    } else {
        gestureLength += sender.velocity;

        if (gestureLength > 10 && ![self.scrollView playing]) {
            [self.scrollView play];
            gestureLength -= 10;
        }
                                    
        if (gestureLength < -10) {
            gestureLength += 10;
            [self.scrollView rewind:1];
        }

        if (gestureLength > 10) {
            gestureLength -= 10;
            [self.scrollView rewind:-1];
        }

        if (sender.state == UIGestureRecognizerStateEnded) {
            [self.scrollView finishRewinding];
        }
    }
}

- (IBAction)saveButton:(UIButton *)sender {
    self.unsavedChanges = false;
    [self.scrollView save];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.scrollView addGestureRecognizer:singleTap];

    [self.scrollView clear];

    self.unsavedChanges = false;

    // Load overdub data, if there is any.
    if (self.noteData) {
        [self.scrollView loadData:self.noteData];
        self.noteData = nil;
        self.unsavedChanges = true;
    }
    
    [DocumentManager withDocumentDo:^(UIManagedDocument* document){
        NSArray *songs = [Song allSongsWithName:document name:[Settings getTitle]];
        if (songs.count > 0) {
            [self.scrollView loadData:[songs[0] toNoteData]];
        }
    }];

}

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture {
    CGPoint touchPoint= [gesture locationInView:self.scrollView];
    [self.scrollView receiveTap:touchPoint];

    // Admittedly this is a bit extreme.
    self.unsavedChanges = true;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
