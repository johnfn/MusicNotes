//
//  Song.h
//  MusicNotes
//
//  Created by Grant Mathews on 3/17/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CoreNote;

@interface Song : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDate * modified;
@property (nonatomic, retain) NSSet *notes;
@end

@interface Song (CoreDataGeneratedAccessors)

- (void)addNotesObject:(CoreNote *)value;
- (void)removeNotesObject:(CoreNote *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

@end
