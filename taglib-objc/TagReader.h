//
//  TagReader.h
//  TagLib-ObjC
//
//  Created by Me on 01/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * const TagReaderDidSaveFileNotification;
extern NSString * const TagReaderFilePath;

@interface TagReader : NSObject

- (instancetype)initWithFileAtPath:(NSString *)path;  //Designated initializer
- (void)loadFileAtPath:(NSString *)path;

- (BOOL)doubleSave; //Some filetypes require being saved twice (unknown reasons), if saving with - save doesn't work, try -doubleSave. 

@property (readonly) NSString *path;

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *artist;
@property (nonatomic) NSString *album;
@property (nonatomic) NSNumber *year;
@property (nonatomic) NSString *comment;
@property (nonatomic) NSNumber *track;
@property (nonatomic) NSString *genre;
@property (nonatomic) NSData *albumArtData;

@property (nonatomic,readonly) NSData *titleData;
@property (nonatomic,readonly) NSData *artistData;
@property (nonatomic,readonly) NSData *albumData;
@property (nonatomic,readonly) NSData *commentData;
@property (nonatomic,readonly) NSData *genreData;

@end
