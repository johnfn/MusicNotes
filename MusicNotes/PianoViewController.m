//
//  PianoViewController.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/15/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "PianoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ToneGeneratorViewController.h"

@interface PianoViewController ()
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *keys;
@property (strong, nonatomic) NSMutableArray* tones;
@property (strong, nonatomic) ToneGeneratorViewController* metronomeGenerator;
@property (nonatomic) int beatNumber;
@end

@implementation PianoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _beatNumber = 0;
    }
    return self;
}

- (ToneGeneratorViewController*)metronomeGenerator {
    if (!_metronomeGenerator) {
        _metronomeGenerator = [[ToneGeneratorViewController alloc] init];
    }
    
    return _metronomeGenerator;
}

- (void)pressKey:(UIButton *)sender {
    int idx = [self.keys indexOfObject:sender];
    ToneGeneratorViewController* tone = [self.tones objectAtIndex:idx];
    NSLog(@"%@", tone);
    [tone togglePlay];
}

- (IBAction)test:(UIButton *)sender {
    NSLog(@"%f", [sender frame].origin.y);
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
    NSTimer* timer = [NSTimer timerWithTimeInterval:perSecond target:self selector:@selector(beepMetronome:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (double)frequency:(int)semitonesFromA {
    double power = semitonesFromA/12.0;
    double result = 220 * pow(2, power);
    
    return result;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
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
        [btn setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(pressKey:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [self startMetronomeWithBPM:120];
    
    [self.metronomeGenerator setup:440];
    
    int C = 3; // C is 3 semitones from A.
    // Create tones
    self.tones = [[NSMutableArray alloc] init];
    for (int i = 0; i < sortedArray.count; i++) {
        ToneGeneratorViewController *tone = [[ToneGeneratorViewController alloc] init];
        [tone setup:[self frequency:C + i]];
        [self.tones addObject:tone];
    }
    
    //[self.toneGenerator setup:220];
    //[self.toneGenerator togglePlay];
    
    //[self.toneGenerator2 setup:[self frequency:12]];
    //[self.toneGenerator2 togglePlay];
    
    //[self setColorOfButtons:self.keys red:0 green:255 blue:0 alpha:1];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
