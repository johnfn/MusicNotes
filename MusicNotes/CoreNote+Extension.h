//
//  CoreNote+Extension.h
//  MusicNotes
//
//  Created by Grant Mathews on 3/17/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import "CoreNote.h"
#import "Note.h"

@interface CoreNote (Extension)

+ (CoreNote*)saveNote:(UIManagedDocument*)document note:(Note*)note;

@end
