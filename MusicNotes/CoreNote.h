//
//  CoreNote.h
//  MusicNotes
//
//  Created by Grant Mathews on 3/17/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Song;

@interface CoreNote : NSManagedObject

@property (nonatomic, retain) NSNumber * frequency;
@property (nonatomic, retain) NSNumber * column;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) Song *song;

@end
