//
//  CoreNote+Extension.m
//  MusicNotes
//
//  Created by Grant Mathews on 3/17/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "CoreNote+Extension.h"

@implementation CoreNote (Extension)

+ (CoreNote*)saveNote:(UIManagedDocument *)document note:(Note*)note {
    NSManagedObjectContext *context = document.managedObjectContext;
    CoreNote* newNote = [NSEntityDescription insertNewObjectForEntityForName:@"CoreNote" inManagedObjectContext:context];

    newNote.frequency = [NSNumber numberWithInt:note.frequency];
    newNote.duration = @1;
    newNote.column = [NSNumber numberWithInt:note.column];
    
    return newNote;
}

@end
