//
//  Song+Extension.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/17/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "Song+Extension.h"
#import "CoreNote+Extension.h"
#import "Note.h"
#import "NotePlayer.h"

@implementation Song (Extension)

+ (void)saveSequence:(UIManagedDocument *)document seq:(Sequence *)sequence {
    NSManagedObjectContext *context = document.managedObjectContext;
    Song* newSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:context];

    newSong.title = @"HerpDerpSong";
    newSong.modified = [NSDate date];

    NSMutableArray* notes = [sequence getAllNotes];
    
    for (Note* note in notes) {
        CoreNote* coreNote = [CoreNote saveNote:document note:note];
        [newSong addNotesObject:coreNote];
    }
}

+ (NSArray*)allSongs:(UIManagedDocument *)document {
    NSManagedObjectContext *context = document.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Song"];
    [request setReturnsObjectsAsFaults:NO];
    NSError *error;
    NSArray *songs = [context executeFetchRequest:request error:&error];

    return songs;
}

- (NSMutableArray*)toNoteData {
    NSMutableArray* result = [[NSMutableArray alloc] init];

    for (CoreNote* note in self.notes) {
        while (result.count <= [note.column intValue]) {
            [result addObject:[[NSMutableArray alloc] init]];
        }

        NSMutableArray *col = [result objectAtIndex:[note.column intValue]];
        NSNumber *number = [NSNumber numberWithInt:[NotePlayer semitonesFromC:[note.frequency intValue]]];
        [col addObject:number];
    }

    return result;
}

@end
