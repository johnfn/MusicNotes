//
//  Sequence.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/14/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "Sequence.h"
#import "Note.h"

@interface Sequence()
@property (strong, nonatomic) NSMutableArray* notes;
@end

@implementation Sequence

- (id)init {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

- (NSMutableArray*)notes {
    if (!_notes) {
        _notes = [[NSMutableArray alloc] init];
        int octave = 2;
        for (int col = 0; col < self.numColumns; col++) {
            NSMutableArray* currentColumn = [[NSMutableArray alloc] init];
            for (NSString* pitch in [Note validPitches]) {
                Note* note = [[Note alloc] init];
                note.pitch = pitch;
                note.octave = octave;
                note.willPlay = false;
                
                [currentColumn addObject:note];
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
}

- (bool)inBounds:(int)x y:(int)y {
    NSMutableArray* firstCol = [self.notes objectAtIndex:0];
    return (x >= 0 && y >= 0 && x < self.notes.count && y < firstCol.count);
}


- (UIColor*)getNoteColor:(int)x y:(int)y {
    NSLog(@"%d %d", x, y);
    
    if (![self inBounds:x y:y]) {
        NSLog(@"Out of bounds!");
        return [UIColor blackColor];
    }
    
    Note* note = [self getNoteAt:x y:y];
    if (note.willPlay) {
        return [UIColor blueColor];
    } else {
        return [UIColor grayColor];
    }
}

@end
