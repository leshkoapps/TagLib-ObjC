//
//  TagReader.m
//  TagLib-ObjC
//
//  Created by Me on 01/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TagReader.h"

#include <fileref.h>
#include "aifffile.h"
#include "mpegfile.h"
#include "flacfile.h"
#include "id3v2tag.h"
#include "id3v2frame.h"
#include "id3v2header.h"
#include "attachedpictureframe.h"

NSString * const TagReaderDidSaveFileNotification = @"TagReaderDidSaveFileNotification";
NSString * const TagReaderFilePath = @"TagReaderFilePath";

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
    BOOL result = [self save] && [self save];
    NSDictionary *userInfo = @{TagReaderFilePath:_path?:@""};
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:TagReaderDidSaveFileNotification object:self userInfo:userInfo];
    });
    return result;
}

- (NSString *)title{
    if (_file.tag()){
        return NSStr(_file.tag()->title());
    }
    return nil;
}

- (void)setTitle:(NSString *)title{
    if(title==nil){
        title = @"";
    }
    if(_file.tag()){
        _file.tag()->setTitle(TLStr(title));
    }
}

- (NSData *)titleData{
    if (_file.tag()){
         NSData *titleData = [NSData dataWithBytes:_file.tag()->title().toCString(false) length:_file.tag()->title().length()];
        return titleData;
    }
    return nil;
}

- (NSString *)artist{
    if (_file.tag()){
        return NSStr(_file.tag()->artist());
    }
    return nil;
}

- (void)setArtist:(NSString *)artist{
    if(artist==nil){
        artist = @"";
    }
    if(_file.tag()){
        _file.tag()->setArtist(TLStr(artist));
    }
}

- (NSData *)artistData{
    if (_file.tag()){
        NSData *data = [NSData dataWithBytes:_file.tag()->artist().toCString(false) length:_file.tag()->artist().length()];
        return data;
    }
    return nil;
}

- (NSString *)album{
    if (_file.tag()){
        return NSStr(_file.tag()->album());
    }
    return nil;
}

- (void)setAlbum:(NSString *)album{
    if(album==nil){
        album = @"";
    }
    if(_file.tag()){
        _file.tag()->setAlbum(TLStr(album));
    }
}

- (NSData *)albumData{
    if (_file.tag()){
        NSData *data = [NSData dataWithBytes:_file.tag()->album().toCString(false) length:_file.tag()->album().length()];
        return data;
    }
    return nil;
}

- (NSNumber *)year{
    if (_file.tag()){
        return [NSNumber numberWithUnsignedInt:_file.tag()->year()];
    }
    return nil;
}

- (NSNumber *)duration{
    if(_file.audioProperties()){
        return @(_file.audioProperties()->length());
    }
    return nil;
}

- (NSNumber *)bitrate{
    if(_file.audioProperties()){
        return @(_file.audioProperties()->bitrate());
    }
    return nil;
}

- (NSNumber *)sampleRate{
    if(_file.audioProperties()){
        return @(_file.audioProperties()->sampleRate());
    }
    return nil;
}

- (NSNumber *)channels{
    if(_file.audioProperties()){
        return @(_file.audioProperties()->channels());
    }
    return nil;
}

- (void)setYear:(NSNumber *)year{
    if(year==nil){
        year = @(0);
    }
    if(_file.tag()){
        _file.tag()->setYear([year unsignedIntValue]);
    }
}

- (NSString *)comment{
    if (_file.tag()){
        return NSStr(_file.tag()->comment());
    }
    return nil;
}

- (void)setComment:(NSString *)comment{
    if(comment==nil){
        comment = @"";
    }
    if(_file.tag()){
        _file.tag()->setComment(TLStr(comment));
    }
}

- (NSData *)commentData{
    if (_file.tag()){
        NSData *data = [NSData dataWithBytes:_file.tag()->comment().toCString(false) length:_file.tag()->comment().length()];
        return data;
    }
    return nil;
}

- (NSNumber *)track{
    if (_file.tag()){
        return [NSNumber numberWithUnsignedInt:_file.tag()->track()];
    }
    return nil;
}

- (void)setTrack:(NSNumber *)track{
    if(track==nil){
        track = @(0);
    }
    if(_file.tag()){
        _file.tag()->setTrack([track unsignedIntValue]);
    }
}

- (NSString *)genre{
    if(_file.tag()){
        return NSStr(_file.tag()->genre());
    }
    return nil;
}

- (void)setGenre:(NSString *)genre{
    if(genre==nil){
        genre = @"";
    }
    if(_file.tag()){
        _file.tag()->setGenre(TLStr(genre));
    }
}

- (NSData *)genreData{
    if (_file.tag()){
        NSData *data = [NSData dataWithBytes:_file.tag()->genre().toCString(false) length:_file.tag()->genre().length()];
        return data;
    }
    return nil;
}

- (NSData *)albumArtData{
    
    MPEG::File *mpeg_file = dynamic_cast<MPEG::File *>(_file.file());
    if (mpeg_file != NULL) {
        ID3v2::Tag *tag = mpeg_file->ID3v2Tag();
        if (tag) {
            ID3v2::FrameList frameList = tag->frameListMap()["APIC"];
            ID3v2::AttachedPictureFrame *picture = NULL;
            if (!frameList.isEmpty() && NULL != (picture = dynamic_cast<ID3v2::AttachedPictureFrame *>(frameList.front()))) {
                TagLib::ByteVector bv = picture->picture();
                if(bv.size()>0){
                    return [NSData dataWithBytes:bv.data() length:bv.size()];
                }
            }
        }
    }
    
    RIFF::AIFF::File *aiff_file = dynamic_cast<RIFF::AIFF::File *>(_file.file());
    if (aiff_file != NULL) {
        /*!
         * Returns the Tag for this file.
         *
         * \note This always returns a valid pointer regardless of whether or not
         * the file on disk has an ID3v2 tag.  Use hasID3v2Tag() to check if the file
         * on disk actually has an ID3v2 tag.
         *
         * \see hasID3v2Tag()
         */
        if(aiff_file->hasID3v2Tag()){
            ID3v2::Tag *tag = aiff_file->tag();
            if (tag) {
                ID3v2::FrameList frameList = tag->frameListMap()["APIC"];
                ID3v2::AttachedPictureFrame *picture = NULL;
                if (!frameList.isEmpty() && NULL != (picture = dynamic_cast<ID3v2::AttachedPictureFrame *>(frameList.front()))) {
                    TagLib::ByteVector bv = picture->picture();
                    if(bv.size()>0){
                        return [NSData dataWithBytes:bv.data() length:bv.size()];
                    }
                }
            }
        }
    }
    
    FLAC::File *flac_file = dynamic_cast<FLAC::File *>(_file.file());
    if (flac_file != NULL) {
        List<FLAC::Picture *> theList = flac_file->pictureList();
        for (List<FLAC::Picture *>::Iterator it=theList.begin(); it != theList.end(); ++it){
            FLAC::Picture *thePicture = *it;
            if (thePicture->type() == FLAC::Picture::FrontCover){
                TagLib::ByteVector bv = thePicture->data();
                if(bv.size()>0){
                    return [NSData dataWithBytes:bv.data() length:bv.size()];
                }
            }
        }
    }
    return nil;
}

- (void)setAlbumArtData:(NSData *)albumArt{
    
    MPEG::File *mpeg_file = dynamic_cast<MPEG::File *>(_file.file());
    if (mpeg_file != NULL) {
        ID3v2::Tag *tag = mpeg_file->ID3v2Tag();
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
    
    RIFF::AIFF::File *aiff_file = dynamic_cast<RIFF::AIFF::File *>(_file.file());
    if (aiff_file != NULL) {
        ID3v2::Tag *tag = aiff_file->tag();
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
    
    //example https://github.com/taglib/taglib/issues/668
    //https://www.rubydoc.info/github/robinst/taglib-ruby/TagLib/FLAC/File
    
    FLAC::File *flac_file = dynamic_cast<FLAC::File *>(_file.file());
    if (flac_file != NULL) {
        
        List<FLAC::Picture *> theList = flac_file->pictureList();
        for (List<FLAC::Picture *>::Iterator it=theList.begin(); it != theList.end(); ++it){
            FLAC::Picture *thePicture = *it;
            if (thePicture->type() == FLAC::Picture::FrontCover){
                flac_file->removePicture(thePicture);
                break;
            }
        }
        
        if (albumArt != nil && [albumArt length] > 0) {
            TagLib::FLAC::Picture *picture = new TagLib::FLAC::Picture();
            picture->setType(TagLib::FLAC::Picture::FrontCover);
            picture->setMimeType(String("image/jpg"));
            TagLib::ByteVector bv = ByteVector((const char *)[albumArt bytes], (uint)[albumArt length]);
            picture->setData(bv);
            flac_file->addPicture(picture);
        }

    }
    
}

- (void)dealloc{
    _path = nil;
}

@end
