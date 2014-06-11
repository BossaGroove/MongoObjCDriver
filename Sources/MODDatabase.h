//
//  MODDatabase.h
//  mongo-objc-driver
//
//  Created by Jérôme Lebel on 03/09/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MODClient;
@class MODDatabase;
@class MODCollection;
@class MODQuery;
@class MODSortedMutableDictionary;

@interface MODDatabase : NSObject
{
    MODClient                           *_client;
    NSString                            *_name;
    void                                *_mongocDatabase;
    MODCollection                       *_systemIndexesCollection;
    MODReadPreferences                  *_readPreferences;
}
@property (nonatomic, readonly, strong) MODClient *client;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, strong) MODCollection *systemIndexesCollection;
@property (nonatomic, readwrite, retain) MODReadPreferences *readPreferences;

- (MODQuery *)statsWithCallback:(void (^)(MODSortedMutableDictionary *databaseStats, MODQuery *mongoQuery))callback;
- (MODQuery *)fetchCollectionListWithCallback:(void (^)(NSArray *collectionList, MODQuery *mongoQuery))callback;

- (MODQuery *)createCollectionWithName:(NSString *)collectionName callback:(void (^)(MODQuery *mongoQuery))callback;
//- (MODQuery *)createCappedCollectionWithName:(NSString *)collectionName capSize:(int64_t)capSize callback:(void (^)(MODQuery *mongoQuery))callback;
- (MODQuery *)dropWithCallback:(void (^)(MODQuery *mongoQuery))callback;

- (MODCollection *)collectionForName:(NSString *)name;

@end
