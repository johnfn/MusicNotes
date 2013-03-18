//
//  PianoViewController.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/15/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "PianoViewController.h"
#import "NotePlayer.h"
#import "SequencerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ToneGeneratorViewController.h"
#import "Settings.h"

@interface PianoViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keys;
@property (strong, nonatomic) ToneGeneratorViewController* metronomeGenerator;
@property (strong, nonatomic) NSMutableArray* recordedSong; // Array of tones.
@property (nonatomic) bool startedRecording;
@property (strong, nonatomic) NSDate* recordingStartTime;
@property (nonatomic) int BPM;
@property (strong, nonatomic) NSTimer* metronomeTimer;
@end

@implementation PianoViewController

#define SECONDS_IN_MINUTE 60.0

// C is 3 semitones above A.
#define C 3

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _startedRecording = false;
    }
    return self;
}

- (int)BPM {
    return [Settings getBPM];
}

- (NSMutableArray*)recordedSong {
    if (!_recordedSong) {
        _recordedSong = [[NSMutableArray alloc] init];
    }
    
    return _recordedSong;
}

- (ToneGeneratorViewController*)metronomeGenerator {
    if (!_metronomeGenerator) {
        _metronomeGenerator = [[ToneGeneratorViewController alloc] init];
    }
    
    return _metronomeGenerator;
}

- (void)pressKey:(UIButton *)sender {
    if (!_startedRecording) {
        self.recordingStartTime = [NSDate date];
    }
    _startedRecording = true;
    
    int toneIdx = [self.keys indexOfObject:sender];
    
    [NotePlayer playFrequency:[NotePlayer frequency:toneIdx]];
    
    double timeInterval = fabs([self.recordingStartTime timeIntervalSinceNow]);
    int beats = round(timeInterval * (double) self.BPM / SECONDS_IN_MINUTE);
    
    while (self.recordedSong.count <= beats) {
        [self.recordedSong addObject:[[NSMutableArray alloc] init]];
    }

    NSMutableArray *arr = [self.recordedSong objectAtIndex:beats];
    [arr addObject:[NSNumber numberWithInt:toneIdx]];
}

- (void)releaseKey:(UIButton*)sender {
    int toneIdx = [self.keys indexOfObject:sender];
    [NotePlayer stopFrequency:[NotePlayer frequency:toneIdx]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    SequencerViewController *newController = (SequencerViewController*)segue.destinationViewController;
    
    newController.noteData = self.recordedSong;
    [self.metronomeTimer invalidate];
}


- (IBAction)test:(UIButton *)sender {
}

- (void)finishMetronomeBeep {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.metronomeGenerator togglePlay];
    });
}

- (void)beepMetronome:(id)unused {
    [self.metronomeGenerator togglePlay];
    [self performSelector:@selector(finishMetronomeBeep) withObject:nil afterDelay:.1];
}

- (void)startMetronomeWithBPM:(int)BPM {
    float perSecond = 60.0f/(float)BPM;
    self.metronomeTimer = [NSTimer timerWithTimeInterval:perSecond target:self selector:@selector(beepMetronome:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.metronomeTimer forMode:NSRunLoopCommonModes];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    NSArray *sortedArray = [self.keys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        CGFloat first  = [((UIButton*) a) frame].origin.y;
        CGFloat second = [((UIButton*) b) frame].origin.y;
        
        if (first > second) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    self.keys = sortedArray;
    
    for (int i = 0; i < sortedArray.count; i++) {
        UIButton *btn = [sortedArray objectAtIndex:i];
        
        [btn addTarget:self action:@selector(pressKey:) forControlEvents:UIControlEventTouchDown];
        //[btn addTarget:self action:@selector(pressKey:) forControlEvents:UIControlEventTouchDragEnter];
        [btn addTarget:self action:@selector(releaseKey:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(releaseKey:) forControlEvents:UIControlEventTouchUpOutside];
        //[btn addTarget:self action:@selector(releaseKey:) forControlEvents:UIControlEventTouchDragExit];
    }

    _startedRecording = false;
    _recordedSong = nil;
    _recordingStartTime = nil;
    
    [self startMetronomeWithBPM:self.BPM];
    
    [self.metronomeGenerator setup:440];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
