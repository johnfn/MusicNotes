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
#import "Song+Extension.h"
#import "DocumentManager.h"
#import "Settings.h"

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
    return 15;
}

- (bool)isPlaying {
    return _isPlaying;
}

- (int)playbackBar {
    return _playbackBar;
}

- (int)BPM {
    return [Settings getBPM];
}

- (void)playSingleBar {
    if (self.rewinding) return;

    if (self.playbackBar > 0) {
        int lastBar = self.playbackBar - 1;
        NSMutableArray* lastNotes = [self.sequence getAllNotesAtCol:lastBar];

        for (Note* note in lastNotes) {
            note.playingNow = false;
            [NotePlayer stopFrequency:note.frequency];
        }

        [self.sequence highlightCol:lastBar on:false];
    }
    
    NSMutableArray* notes = [self.sequence getAllNotesAtCol:self.playbackBar];

    for (Note* note in notes) {
        note.playingNow = true;
        [NotePlayer playFrequency:note.frequency];
    }
    [self.sequence highlightCol:self.playbackBar on:true];

    self.playbackBar++;
    
    if (self.playbackBar > self.sequence.sequenceWidth) {
        [self.playbackTimer invalidate];
        [self reset];
    }

    [self setNeedsDisplay];
}

- (bool)playing {
    return self.isPlaying;
}

- (void)save {
    [DocumentManager withDocumentDo:^(UIManagedDocument* document){
        [Song saveSequence:document seq:self.sequence];
    }];
}

- (void)finishRewinding {
    self.rewinding = false;
    
    if (self.playbackBar < 0 || self.playbackBar >= self.notesWide) {
        self.playbackBar = 0;
    }
}

- (void)rewind:(int)dir {
    if (self.playbackBar + dir >= 0 && self.playbackBar + dir < self.notesWide) {
        [self.sequence highlightCol:self.playbackBar on:false];
        self.playbackBar += dir;
        [self.sequence highlightCol:self.playbackBar on:true];

        [self setNeedsDisplay];
    }
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
        CGFloat height = [UIScreen mainScreen].bounds.size.width - 50;
        CGFloat noteHeight = height / self.notesHigh;
        
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

- (void)clear {
    _sequence = nil;
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
    
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"%d", self.notesHigh);
    
    for (int i = 0; i < self.notesWide; i++) {
        for (int j = 0; j < self.notesHigh; j++) {
            int noteX = i * self.noteWidth;
            int noteY = j * self.noteHeight;
            
            CGRect dest = CGRectMake(noteX, noteY, self.noteWidth, self.noteHeight);
            UIColor *color = [self.sequence getNoteColor:i y:j];
            
            [self drawNote:rect dest:dest color:color];
        }
    }
    
    [self setNeedsDisplay];
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
