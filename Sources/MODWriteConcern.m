//
//  MODWriteConcern.m
//  MongoObjCDriver
//
//  Created by Jérôme Lebel on 27/08/2014.
//
//

#import "MongoObjCDriver-private.h"

@interface MODWriteConcern ()
@property (nonatomic, assign, readwrite) BOOL fileSync;
@property (nonatomic, assign, readwrite) BOOL journal;
@property (nonatomic, assign, readwrite) int32_t w;
@property (nonatomic, assign, readwrite) int32_t wtimeout;
@property (nonatomic, strong, readwrite) NSString *wtag;

@end

@implementation MODWriteConcern

+ (instancetype)writeConcernWithMongocWriteConcern:(const mongoc_write_concern_t *)mongocWriteConcern
{
    return MOD_AUTORELEASE([[self alloc] initWithMongocWriteConcern:mongocWriteConcern]);
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mongocWriteConcern = mongoc_write_concern_new();
    }
    return self;
}

- (instancetype)initWithFileSync:(BOOL)fileSync journal:(BOOL)journal w:(int32_t)w wtimeout:(int32_t)wtimeout wtag:(NSString *)wtag
{
    if (self = [self init]) {
        self.fileSync = fileSync;
        self.journal = journal;
        self.w = w;
        self.wtimeout = wtimeout;
        self.wtag = wtag;
    }
    return self;
}

- (instancetype)initWithMongocWriteConcern:(const mongoc_write_concern_t *)mongocWriteConcern
{
    self = [self init];
    if (self) {
        mongoc_write_concern_destroy(self.mongocWriteConcern);
        self.mongocWriteConcern = mongoc_write_concern_copy(mongocWriteConcern);
    }
    return self;
}

- (void)dealloc
{
    mongoc_write_concern_destroy(self.mongocWriteConcern);
    MOD_SUPER_DEALLOC();
}

- (BOOL)journal
{
    return mongoc_write_concern_get_journal(self.mongocWriteConcern);
}

- (void)setJournal:(BOOL)journal
{
    mongoc_write_concern_set_journal(self.mongocWriteConcern, journal);
}

- (int32_t)w
{
    return mongoc_write_concern_get_w(self.mongocWriteConcern);
}

- (void)setW:(int32_t)w
{
    mongoc_write_concern_set_w(self.mongocWriteConcern, w);
}

- (int32_t)wtimeout
{
    return mongoc_write_concern_get_wtimeout(self.mongocWriteConcern);
}

- (void)setWtimeout:(int32_t)wtimeout
{
    mongoc_write_concern_set_wtimeout(self.mongocWriteConcern, wtimeout);
}

- (NSString *)wtag
{
    const char *wtagUTF8String = mongoc_write_concern_get_wtag(self.mongocWriteConcern);
    if (wtagUTF8String) {
        return [NSString stringWithUTF8String:wtagUTF8String];
    } else {
        return nil;
    }
}

- (void)setWtag:(NSString *)wtag
{
    mongoc_write_concern_set_wtag(self.mongocWriteConcern, wtag.UTF8String);
}

@end
