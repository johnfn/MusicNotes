//
//  Sequence.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/14/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "Sequence.h"
#import "Note.h"
#import "NotePlayer.h"

@interface Sequence()
@property (strong, nonatomic) NSMutableArray* notes;
@property (nonatomic) int sequenceWidth;
@end

@implementation Sequence

- (id)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (int)sequenceWidth {
    return _sequenceWidth;
}

- (NSMutableArray*)getAllNotesAtCol:(int)col {
    NSMutableArray* turnedOnNotes = [[NSMutableArray alloc] init];
    NSMutableArray* column = [self.notes objectAtIndex:col];
    
    for (int i = 0; i < column.count; i++) {
        Note* n = [column objectAtIndex:i];
        if (n.willPlay) {
            [turnedOnNotes addObject:n];
        }
    }
    
    return turnedOnNotes;
}

- (NSMutableArray*)getAllNotes {
    NSMutableArray* result = [[NSMutableArray alloc] init];
    for (int i = 0; i <= self.sequenceWidth; i++) {
        [result addObjectsFromArray:[self getAllNotesAtCol:i]];
    }

    return result;
}

- (NSMutableArray*)notes {
    if (!_notes) {
        _notes = [[NSMutableArray alloc] init];
        for (int col = 0; col < self.numColumns; col++) {
            NSMutableArray* currentColumn = [[NSMutableArray alloc] init];
            int semitoneDistance = 0;
            for (NSString* pitch in [Note validPitches]) {
                Note* note = [[Note alloc] init];
                note.frequency = [NotePlayer frequency:semitoneDistance];
                note.willPlay = false;
                note.column = col;
                
                [currentColumn addObject:note];
                
                // sequenceWidth will eventually have the x of the rightmost col with
                // a note in it.
                _sequenceWidth = col;
                semitoneDistance++;
            }
            
            [_notes addObject:currentColumn];
        }
    }
    
    return _notes;
}

- (int)numColumns {
    return 20;
}

- (Note*)getNoteAt:(int)x y:(int)y {
    return [[self.notes objectAtIndex:x] objectAtIndex:y];
}

- (void)clickOnNote:(int)x y:(int)y {
    Note* note = [self getNoteAt:x y:y];
    note.willPlay = !note.willPlay;
}

- (void)turnOnNote:(int)x y:(int)y {
    Note* note = [self getNoteAt:x y:y];
    note.willPlay = YES;

    if (y > self.sequenceWidth) {
        self.sequenceWidth = y;
    }
}

- (bool)inBounds:(int)x y:(int)y {
    NSMutableArray* firstCol = [self.notes objectAtIndex:0];
    return (x >= 0 && y >= 0 && x < self.notes.count && y < firstCol.count);
}


- (UIColor*)getNoteColor:(int)x y:(int)y {
    if (![self inBounds:x y:y]) {
        return [UIColor blackColor];
    }

    Note* note = [self getNoteAt:x y:y];
    if (note.playingNow) {
        return [UIColor redColor];
    }

    if (note.willPlay) {
        return [UIColor blueColor];
    } else {
        return [UIColor grayColor];
    }
}

@end
