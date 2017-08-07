//
//  TagReader.m
//  TagLib-ObjC
//
//  Created by Me on 01/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TagReader.h"

#include <fileref.h>
#include "mpegfile.h"
#include "id3v2tag.h"
#include "id3v2frame.h"
#include "id3v2header.h"
#include "attachedpictureframe.h"

using namespace TagLib;

static inline NSString *NSStr(TagLib::String _string)
{
    if (_string.isNull() == false) {
        return [NSString stringWithUTF8String:_string.toCString(true)];
    } else {
        return nil;
    }
}
static inline TagLib::String TLStr(NSString *_string)
{
    return TagLib::String([_string UTF8String], TagLib::String::UTF8);
}

@interface TagReader ()
{
    FileRef _file;
}

@end

@implementation TagReader
@synthesize path=_path;

- (instancetype)initWithFileAtPath:(NSString *)path{
    NSCParameterAssert([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil]);
    if([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:nil]==NO){
        return nil;
    }
    self = [super init];
    if (self) {
        [self loadFileAtPath:path];
    }
    return self;
}

- (instancetype)init{
    return [self initWithFileAtPath:nil];
}

- (void)loadFileAtPath:(NSString *)path{
    _path = [path copy];
    if (_path != nil) {
        _file = FileRef([path UTF8String]);
    } else {
        _file = FileRef();
    }
}

- (BOOL)save{
    return (BOOL)_file.save();
}

- (BOOL)doubleSave{
    return [self save] && [self save];
}

- (NSString *)title{
    NSParameterAssert(_file.tag());
    if (_file.tag()){
        return NSStr(_file.tag()->title());
    }
    return nil;
}

- (void)setTitle:(NSString *)title{
    NSParameterAssert(_file.tag());
    if(title==nil){
        title = @"";
    }
    if(_file.tag()){
        _file.tag()->setTitle(TLStr(title));
    }
}

- (NSData *)titleData{
    NSParameterAssert(_file.tag());
    if (_file.tag()){
         NSData *titleData = [NSData dataWithBytes:_file.tag()->title().toCString(false) length:_file.tag()->title().length()];
        return titleData;
    }
    return nil;
}

- (NSString *)artist{
    NSParameterAssert(_file.tag());
    if (_file.tag()){
        return NSStr(_file.tag()->artist());
    }
    return nil;
}

- (void)setArtist:(NSString *)artist{
    NSParameterAssert(_file.tag());
    if(artist==nil){
        artist = @"";
    }
    if(_file.tag()){
        _file.tag()->setArtist(TLStr(artist));
    }
}

- (NSData *)artistData{
    NSParameterAssert(_file.tag());
    if (_file.tag()){
        NSData *data = [NSData dataWithBytes:_file.tag()->artist().toCString(false) length:_file.tag()->artist().length()];
        return data;
    }
    return nil;
}

- (NSString *)album{
    NSParameterAssert(_file.tag());
    if (_file.tag()){
        return NSStr(_file.tag()->album());
    }
    return nil;
}

- (void)setAlbum:(NSString *)album{
    NSParameterAssert(_file.tag());
    if(album==nil){
        album = @"";
    }
    if(_file.tag()){
        _file.tag()->setAlbum(TLStr(album));
    }
}

- (NSData *)albumData{
    NSParameterAssert(_file.tag());
    if (_file.tag()){
        NSData *data = [NSData dataWithBytes:_file.tag()->album().toCString(false) length:_file.tag()->album().length()];
        return data;
    }
    return nil;
}

- (NSNumber *)year{
     NSParameterAssert(_file.tag());
    if (_file.tag()){
        return [NSNumber numberWithUnsignedInt:_file.tag()->year()];
    }
    return nil;
}

- (void)setYear:(NSNumber *)year{
    NSParameterAssert(_file.tag());
    if(year==nil){
        year = @(0);
    }
    if(_file.tag()){
        _file.tag()->setYear([year unsignedIntValue]);
    }
}

- (NSString *)comment{
    NSParameterAssert(_file.tag());
    if (_file.tag()){
        return NSStr(_file.tag()->comment());
    }
    return nil;
}

- (void)setComment:(NSString *)comment{
    NSParameterAssert(_file.tag());
    if(comment==nil){
        comment = @"";
    }
    if(_file.tag()){
        _file.tag()->setComment(TLStr(comment));
    }
}

- (NSData *)commentData{
    NSParameterAssert(_file.tag());
    if (_file.tag()){
        NSData *data = [NSData dataWithBytes:_file.tag()->comment().toCString(false) length:_file.tag()->comment().length()];
        return data;
    }
    return nil;
}

- (NSNumber *)track{
    NSParameterAssert(_file.tag());
    if (_file.tag()){
        return [NSNumber numberWithUnsignedInt:_file.tag()->track()];
    }
    return nil;
}

- (void)setTrack:(NSNumber *)track{
     NSParameterAssert(_file.tag());
    if(track==nil){
        track = @(0);
    }
    if(_file.tag()){
        _file.tag()->setTrack([track unsignedIntValue]);
    }
}

- (NSString *)genre{
    NSParameterAssert(_file.tag());
    if(_file.tag()){
        return NSStr(_file.tag()->genre());
    }
    return nil;
}

- (void)setGenre:(NSString *)genre{
    NSParameterAssert(_file.tag());
    if(genre==nil){
        genre = @"";
    }
    if(_file.tag()){
        _file.tag()->setGenre(TLStr(genre));
    }
}

- (NSData *)genreData{
    NSParameterAssert(_file.tag());
    if (_file.tag()){
        NSData *data = [NSData dataWithBytes:_file.tag()->genre().toCString(false) length:_file.tag()->genre().length()];
        return data;
    }
    return nil;
}

- (NSData *)albumArt{
    MPEG::File *file = dynamic_cast<MPEG::File *>(_file.file());
    if (file != NULL) {
        ID3v2::Tag *tag = file->ID3v2Tag();
        if (tag) {
            ID3v2::FrameList frameList = tag->frameListMap()["APIC"];
            ID3v2::AttachedPictureFrame *picture = NULL;
            if (!frameList.isEmpty() && NULL != (picture = dynamic_cast<ID3v2::AttachedPictureFrame *>(frameList.front()))) {
                TagLib::ByteVector bv = picture->picture();
                return [NSData dataWithBytes:bv.data() length:bv.size()];
            }
        }
    }
    return nil;
}
- (void)setAlbumArt:(NSData *)albumArt{
    MPEG::File *file = dynamic_cast<MPEG::File *>(_file.file());
    if (file != NULL) {
        ID3v2::Tag *tag = file->ID3v2Tag();
        if (tag) {
            tag->removeFrames("APIC");
            if (albumArt != nil && [albumArt length] > 0) {
                ID3v2::AttachedPictureFrame *picture = new ID3v2::AttachedPictureFrame();
                TagLib::ByteVector bv = ByteVector((const char *)[albumArt bytes], (uint)[albumArt length]);
                picture->setPicture(bv);
                picture->setMimeType(String("image/jpg"));
                picture->setType(ID3v2::AttachedPictureFrame::FrontCover);
                
                tag->addFrame(picture);
            }
        }
    }
}

- (void)dealloc{
    _path = nil;
}

@end
