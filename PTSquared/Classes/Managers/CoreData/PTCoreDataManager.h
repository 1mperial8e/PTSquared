//
//
//  Created by Kirill on 9/10/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef void(^SuccessSearchResult)(NSArray *result);
typedef void(^ErorrResult)(NSError *error);

@interface PTCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedManager;

+ (void)fetchAscendingEntitiesWithName:(NSString *)entityName sortedByAttributeName:(NSString *)attributeName ascending:(BOOL)ascending success:(SuccessSearchResult)success failure:(ErorrResult)failure;
+ (void)fetchEntitiesWithName:(NSString *)entityName success:(SuccessSearchResult)success failure:(ErorrResult)failure;

- (void)saveContext;

@end



