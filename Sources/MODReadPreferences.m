//
//  MODReadPreferences.m
//  mongo-objc-driver
//
//  Created by Jérôme Lebel on 11/06/2014.
//
//

#import "MOD_internal.h"

@implementation MODReadPreferences

@synthesize mongocReadPreferences = _mongocReadPreferences;

+ (MODReadPreferences *)readPreferencesWithReadMode:(MODReadPreferencesReadMode)readMode
{
    return [self readPreferencesWithReadMode:readMode tags:nil];
}

+ (MODReadPreferences *)readPreferencesWithReadMode:(MODReadPreferencesReadMode)readMode tags:(MODSortedMutableDictionary *)tags
{
    MODReadPreferences *readPreferences;
    
    readPreferences = [[self alloc] init];
    readPreferences.readMode = readMode;
    readPreferences.tags = tags;
    return readPreferences;
}

- (void)dealloc
{
    if (self.mongocReadPreferences) {
        mongoc_read_prefs_destroy(self.mongocReadPreferences);
    }
    [super dealloc];
}

- (MODReadPreferencesReadMode)readMode
{
    if (!self.mongocReadPreferences) {
        return MODReadPreferencesReadPrimaryMode;
    } else {
        return (MODReadPreferencesReadMode)mongoc_read_prefs_get_mode(self.mongocReadPreferences);
    }
}

- (void)setReadMode:(MODReadPreferencesReadMode)readMode
{
    if (self.mongocReadPreferences) {
        mongoc_read_prefs_set_mode(self.mongocReadPreferences, (mongoc_read_mode_t)readMode);
    } else {
        self.mongocReadPreferences = mongoc_read_prefs_new((mongoc_read_mode_t)readMode);
    }
}

- (MODSortedMutableDictionary *)tags
{
    if (!self.mongocReadPreferences) {
        return nil;
    } else {
        const bson_t *tags;
        
        tags = mongoc_read_prefs_get_tags(self.mongocReadPreferences);
        return [self.class objectFromBson:tags];
    }
}

- (void)setTags:(MODSortedMutableDictionary *)tags
{
    if (!self.mongocReadPreferences) {
        self.mongocReadPreferences = mongoc_read_prefs_new(MONGOC_READ_PRIMARY);
    }
    if (!tags) {
        mongoc_read_prefs_set_tags(self.mongocReadPreferences, NULL);
    } else {
        bson_t bsonTags = BSON_INITIALIZER;
        
        [MODClient appendObject:tags toBson:&bsonTags];
        mongoc_read_prefs_set_tags(self.mongocReadPreferences, &bsonTags);
        bson_destroy(&bsonTags);
    }
}

@end
