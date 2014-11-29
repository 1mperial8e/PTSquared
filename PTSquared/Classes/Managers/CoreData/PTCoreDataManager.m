//
//
//  Created by Kirill on 9/10/14.
//  Copyright (c) 2014 Thinkmobiles. All rights reserved.
//

#import "PTCoreDataManager.h"
#import <CoreData/CoreData.h>

static NSString *const CDDataBaseName = @"PTSquaredDataBase";

@implementation PTCoreDataManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Singleton

+ (id)sharedManager
{
    static id coreDataManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        coreDataManager = [[self alloc] init];
    });
    return coreDataManager;
}

#pragma mark - Private

#pragma mark - CoreData

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:CDDataBaseName withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSString *appendingComponent = [NSString stringWithFormat:@"%@.sqlite", CDDataBaseName];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:appendingComponent];
    NSError *error;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.managedObjectModel];
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]){
        [self backupDBIfError:storeURL];
        NSLog(@"Problem with creating persistent store coordinator, backUp DB created");
    }
    return _persistentStoreCoordinator;
}


#pragma mark - Application Documents Directory

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSString *)nameForIncompatibleStore
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    return [NSString stringWithFormat:@"%@.sqlite", [dateFormatter stringFromDate:[NSDate date]]];
}

#pragma mark - Data Backup

- (void)backupDBIfError:(NSURL *)urlOfDB
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[urlOfDB path]]) {
        NSURL *corruptedURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[self nameForIncompatibleStore]];
        NSError *error;
        [fileManager moveItemAtURL:urlOfDB toURL:corruptedURL error:&error];
        [self showAlert];
    }
}

- (void)showAlert
{
    NSString *applicationName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *message = [NSString stringWithFormat:@"A serious application error occurred while %@ tried to read your data. Please contact support for help.", applicationName];
    [[[UIAlertView alloc] initWithTitle:@"Warning" message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - Public

- (void)saveContext
{
    NSError *saveError;
    if(![self.managedObjectContext save:&saveError]) {
        NSLog(@"\nCant save context in to DB due to error - %@.\nReason - %@.\n", saveError.localizedDescription, saveError.localizedFailureReason);
    }
}

#pragma mark - DataManagment

+ (void)fetchAscendingEntitiesWithName:(NSString *)entityName sortedByAttributeName:(NSString *)attributeName ascending:(BOOL)ascending success:(SuccessSearchResult)success failure:(ErorrResult)failure
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:entityName];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:attributeName ascending:ascending];
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *result = [[[PTCoreDataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error) {
        failure(error);
    } else {
        success(result);
    }
}

+ (void)fetchEntitiesWithName:(NSString *)entityName success:(SuccessSearchResult)success failure:(ErorrResult)failure
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityForSearch = [NSEntityDescription entityForName:entityName inManagedObjectContext:[[PTCoreDataManager sharedManager] managedObjectContext]];
    [fetchRequest setEntity:entityForSearch];
    
    NSError *error;
    NSArray *result = [[[PTCoreDataManager sharedManager] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (error) {
        failure(error);
    } else {
        success(result);
    }
}

@end
