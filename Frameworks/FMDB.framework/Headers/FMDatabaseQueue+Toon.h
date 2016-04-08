//
//  FMDatabaseQueue+Toon.h
//  FMDB
//
//  Created by lanhy on 15/9/9.
//  Copyright (c) 2015年 chunxu. All rights reserved.
//

#import <FMDB/FMDB.h>

@interface FMDatabaseQueue (Toon)

-(NSInteger) dbVersion;

-(void) setDBVersion:(NSInteger) dbVersion;

@end
