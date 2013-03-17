//
//  SequencerView.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/14/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "SequencerView.h"
#import "Sequence.h"
#import "Note.h"
#import "NotePlayer.h"

@interface SequencerView()
@property (strong, nonatomic) Sequence *sequence;
@property (nonatomic) int noteWidth;
@property (nonatomic) int noteHeight;
@property (nonatomic) int notesWide;
@property (nonatomic) int notesHigh;

@property (nonatomic) bool isPlaying;
@property (nonatomic) int playbackBar;
@property (nonatomic, strong) NSTimer* playbackTimer;
@end

@implementation SequencerView
#define SECONDS_IN_MINUTE 60.0

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (int)notesWide {
    return 10;
}

- (int)notesHigh {
    return 13;
}

- (bool)isPlaying {
    return _isPlaying;
}

- (int)playbackBar {
    return _playbackBar;
}

- (int)BPM {
    return 120;
}

- (void)playSingleBar {
    // TODO: should also stop playing the previous notes.

    if (self.playbackBar > 0) {
        int lastBar = self.playbackBar - 1;
        NSMutableArray* lastNotes = [self.sequence getAllNotesAtCol:lastBar];

        for (Note* note in lastNotes) {
            note.playingNow = false;
            [NotePlayer playFrequency:note.frequency];
        }
    }
    
    NSMutableArray* notes = [self.sequence getAllNotesAtCol:self.playbackBar];

    for (Note* note in notes) {
        note.playingNow = true;
        [NotePlayer playFrequency:note.frequency];
    }
    
    self.playbackBar++;
    
    if (self.playbackBar > self.sequence.sequenceWidth) {
        [self.playbackTimer invalidate];
        [self reset];
    }

    [self setNeedsDisplay];
}

- (void)play {
    if (!self.isPlaying) {
        self.isPlaying = true;
        self.playbackBar = 0;
        
        self.playbackTimer = [NSTimer scheduledTimerWithTimeInterval:SECONDS_IN_MINUTE / self.BPM
                                         target:self
                                       selector:@selector(playSingleBar)
                                       userInfo:nil
                                        repeats:YES];
    }
}

- (void)reset {
    self.isPlaying = false;
    self.playbackBar = 0;
}

- (int)noteWidth {
    if (!_noteWidth) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat noteWidth = width / self.notesWide;
        
        _noteWidth = noteWidth;
    }
    
    return _noteWidth;
}

- (int)noteHeight {
    if (!_noteHeight) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat noteHeight = width / self.notesHigh;
        
        _noteHeight = noteHeight;
    }
    
    return _noteHeight;
    
}

- (Sequence*)sequence {
    if (!_sequence) {
        _sequence = [[Sequence alloc] init];
    }
    
    return _sequence;
}

- (void)receiveTap:(CGPoint)location {
    // Convert location into relative coordinates.
    int noteX = location.x / self.noteWidth;
    int noteY = location.y / self.noteHeight;
    
    [_sequence clickOnNote:noteX y:noteY];
    [self setNeedsDisplay];
}

- (void)loadData:(NSMutableArray *)data {
    for (int i = 0; i < data.count; i++) {
        NSMutableArray *column = [data objectAtIndex:i];
        for (int j = 0; j < column.count; j++) {
            int freq = [[column objectAtIndex:j] intValue];
            [self.sequence turnOnNote:i y:freq];
        }
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    for (int i = 0; i < self.notesWide; i++) {
        for (int j = 0; j < self.notesHigh; j++) {
            int noteX = i * self.noteWidth;
            int noteY = j * self.noteHeight;
            
            CGRect dest = CGRectMake(noteX, noteY, self.noteWidth, self.noteHeight);
            UIColor *color = [self.sequence getNoteColor:i y:j];
            
            [self drawNote:rect dest:dest color:color];
        }
    }
}

- (void)drawNote:(CGRect)rect dest:(CGRect)dest color:(UIColor*)color {
    struct CGColor *cgcolor = color.CGColor;
    
    // fill rect
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, cgcolor);
    CGContextFillRect(context, dest);
    
    // draw border
    CGRect strokeRect = CGRectInset(dest, 1.0, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextStrokeRect(context, strokeRect);
}

@end
