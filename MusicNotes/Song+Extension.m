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
#import "Settings.h"

@implementation Song (Extension)

+ (NSArray*)allSongsWithName:(UIManagedDocument*)document name:(NSString*)name {
    NSManagedObjectContext *context = document.managedObjectContext;
    
    // This fetching code was inspired by the following StackOverflow link.
    // http://stackoverflow.com/questions/1438587/fetch-object-by-property-in-core-data

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Song" inManagedObjectContext:context];
    [request setEntity:entity];
    // retrive the objects with a given value for a certain property
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"title == %@", name];
    [request setPredicate:predicate];

    NSError *error = nil;
    NSArray *result = [context executeFetchRequest:request error:&error];

    return result;
}

+ (void)saveSequence:(UIManagedDocument *)document seq:(Sequence *)sequence {
    NSManagedObjectContext *context = document.managedObjectContext;
    // Attempt to find an older instance of the current song.
    // If we succeed, remove it.
    NSArray *result = [Song allSongsWithName:document name:[Settings getTitle]];
    NSError *error = nil;

    // Remove all old objects. (There should only be one.)
    for (NSManagedObject *oldSong in result) {
        [context deleteObject:oldSong];
    }

    Song* newSong = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:context];

    newSong.title = [Settings getTitle];
    newSong.modified = [NSDate date];
    newSong.bpm = [NSNumber numberWithInt:[Settings getBPM]];

    NSMutableArray* notes = [sequence getAllNotes];
    
    for (Note* note in notes) {
        CoreNote* coreNote = [CoreNote saveNote:document note:note];
        [newSong addNotesObject:coreNote];
    }

    // This is just for debugging purposes.
    [context save:&error];
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
