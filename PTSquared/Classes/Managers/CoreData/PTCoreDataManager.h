//
//
//  Created by Kirill on 9/10/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTObjectDescription.h"
#import <CoreData/CoreData.h>

@interface PTCoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (id)sharedManager;

+ (void)removeFromDB:(PTObjectDescription *)deleteObjectDescription withManagedObject:(NSManagedObject *)managedObject;
+ (NSArray *)getAllEntities:(PTObjectDescription *)getObjectDescription;

@end



