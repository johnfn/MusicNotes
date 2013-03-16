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
@property (strong, nonatomic) ToneGeneratorViewController* toneGenerator;
@property (strong, nonatomic) ToneGeneratorViewController* toneGenerator2;
@end

@implementation PianoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // Custom initialization
    }
    return self;
}

- (ToneGeneratorViewController*)toneGenerator {
    if (!_toneGenerator) {
        _toneGenerator = [[ToneGeneratorViewController alloc] init];
    }
    
    return _toneGenerator;
}

- (ToneGeneratorViewController*)toneGenerator2 {
    if (!_toneGenerator2) {
        _toneGenerator2 = [[ToneGeneratorViewController alloc] init];
    }
    
    return _toneGenerator2;
}

- (IBAction)test:(UIButton *)sender {
    NSLog(@"%f", [sender frame].origin.y);
}

- (void)beepMetronome:(id)unused {
    NSLog(@"!");
}

- (void)startMetronomeWithBPM:(int)BPM {
    float perSecond = 60.0f/(float)BPM;
    NSTimer* timer = [NSTimer timerWithTimeInterval:perSecond target:self selector:@selector(beepMetronome:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSArray *sortedArray;
    sortedArray = [self.keys sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        CGFloat first  = [((UIButton*) a) frame].origin.y;
        CGFloat second = [((UIButton*) b) frame].origin.y;
        
        if (first > second) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    
    for (int i = 0; i < sortedArray.count; i++) {
        UIButton *btn = [sortedArray objectAtIndex:i];
        [btn setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
    }
    
    
    [self startMetronomeWithBPM:120];
    
    [self.toneGenerator setup:220];
    [self.toneGenerator togglePlay];
    
    [self.toneGenerator2 setup:440];
    [self.toneGenerator2 togglePlay];
    
    //[self setColorOfButtons:self.keys red:0 green:255 blue:0 alpha:1];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
