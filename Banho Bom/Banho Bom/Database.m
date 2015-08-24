//
//  Database.m
//  Banho Bom
//
//  Created by Everson Trindade on 8/18/15.
//  Copyright (c) 2015 IFRN. All rights reserved.
//

#import "Database.h"

@interface Database ()

@end

@implementation Database

@synthesize myDatabase;
@synthesize databasePath;
@synthesize statusOfAddingToDB;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) createDataBase{
    
    // Get the documents directory
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = dirPaths[0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"BanhoBomDB.db"]];
    NSLog(@"DB Path: %@", databasePath);
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    const char *dbpath = [databasePath UTF8String];
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO) {
        if (sqlite3_open(dbpath, &myDatabase) == SQLITE_OK) {
            char *errMsg;
            
            NSString *createSQL = [NSString stringWithFormat: @"CREATE TABLE PRAIATABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT, CODIGOESTACAO TEXT, NOMEPRAIA TEXT, LATITUDE TEXT, LONGITUDE TEXT, STATUS TEXT)"];
            
            const char *create_stmt = [createSQL UTF8String];
            
            if (sqlite3_exec(myDatabase, create_stmt, NULL, NULL, &errMsg) != SQLITE_OK) {
                statusOfAddingToDB = @"Failed to create table";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Status" message:statusOfAddingToDB delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else {
                statusOfAddingToDB = @"Success in creating table";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Status" message:statusOfAddingToDB delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
            sqlite3_close(myDatabase);
        } else {
            statusOfAddingToDB = @"Failed to open/create database";
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DB Status" message:statusOfAddingToDB delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }else if ([filemgr fileExistsAtPath: databasePath ] == YES){
        if (sqlite3_open(dbpath, &myDatabase) == SQLITE_OK) {
            char *err;
            NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM PRAIATABLE"];
            const char *delete_stmt = [deleteSQL UTF8String];
            
            if (sqlite3_exec(myDatabase, delete_stmt, NULL, NULL, &err) == SQLITE_OK) {
                NSLog(@"DATABASE DELETED ;)");
                //[self createDataBase];
            }else{
                NSLog(@"DELETE DATABASE ERROR: %s", err);
            }
        }
    }
}
- (void) saveData:(NSString*)nomePraia addLat:(NSString*)latitude addLong:(NSString*)longitude addBaln:(NSString*)status addCodPraia:(NSString*)codEstacao{
    //sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &myDatabase) == SQLITE_OK) {
        
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO PRAIATABLE (CODIGOESTACAO, NOMEPRAIA, LATITUDE, LONGITUDE, STATUS) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", codEstacao, nomePraia, latitude, longitude, status];
        
        const char *insert_stmt = [insertSQL UTF8String];
        char *err;
        int code = sqlite3_exec(myDatabase, insert_stmt, NULL, NULL, &err);
        if (code != SQLITE_OK) {
            NSLog(@"SOMETHING IS WRONG: %s", err);
        }else{
            NSLog(@"Data Saved");
        }
        
    }else{
        NSLog(@"ERROR");
    }
    
}
-(NSMutableArray*) findData{
    NSMutableArray *praias = [[NSMutableArray alloc] init];
    NSMutableDictionary *dataStored = [[NSMutableDictionary alloc] init];
    
    NSString *codEstacao;
    NSString *nomePraia;
    NSString *lat;
    NSString *lon;
    NSString *status;
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &myDatabase) == SQLITE_OK) {
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT CODIGOESTACAO, NOMEPRAIA, LATITUDE, LONGITUDE, STATUS FROM PRAIATABLE"];
        const char *select_stmt = [selectSQL UTF8String];
        if (sqlite3_prepare_v2(myDatabase, select_stmt, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                codEstacao = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                nomePraia = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                lat = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                lon = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                status = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                
                //NSLog(@"TESTES: %@, %@, %@, %@, %@", codigo, nome, lat, lon, baln);
                
                [dataStored setObject:codEstacao forKey:@"codEstacao"];
                [dataStored setObject:nomePraia forKey:@"nomePraia"];
                [dataStored setObject:lat forKey:@"lat"];
                [dataStored setObject:lon forKey:@"lon"];
                [dataStored setObject:status forKey:@"status"];
                
                [praias addObject:[dataStored copy]];
            }
        }else{
            
            NSLog(@"SELECT ERROR");
        }
    }
    
    return praias;
}

@end
