//
//  DocumentManager.h
//  MusicNotes
//
//  Created by Grant Mathews on 3/17/13.
//  Copyright (c) 2013 johnfn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DocumentManager : NSObject
+ (void)withDocumentDo:(void(^)(UIManagedDocument*))block;
@end
