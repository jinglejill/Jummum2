//
//  Note.h
//  Jummum
//
//  Created by Thidaporn Kijkamjai on 20/2/2561 BE.
//  Copyright © 2561 Appxelent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject
@property (nonatomic) NSInteger noteID;
@property (retain, nonatomic) NSString * name;
@property (retain, nonatomic) NSString * nameEn;
@property (nonatomic) float price;
@property (nonatomic) NSInteger noteTypeID;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger orderNo;
@property (nonatomic) NSInteger status;
@property (retain, nonatomic) NSString * modifiedUser;
@property (retain, nonatomic) NSDate * modifiedDate;

@property (nonatomic) NSInteger branchID;


- (NSDictionary *)dictionary;
-(Note *)initWithName:(NSString *)name nameEn:(NSString *)nameEn price:(float)price noteTypeID:(NSInteger)noteTypeID type:(NSInteger)type orderNo:(NSInteger)orderNo status:(NSInteger)status;
+(NSInteger)getNextID;
+(void)addObject:(Note *)note;
+(void)removeObject:(Note *)note;
+(void)addList:(NSMutableArray *)noteList;
+(void)removeList:(NSMutableArray *)noteList;
+(Note *)getNote:(NSInteger)noteID;
-(BOOL)editNote:(Note *)editingNote;
+(Note *)copyFrom:(Note *)fromNote to:(Note *)toNote;
+(void)setSharedData:(NSMutableArray *)dataList;
+(NSMutableArray *)getNoteList;
+(NSMutableArray *)getNoteListWithStatus:(NSInteger)status noteList:(NSMutableArray *)noteList;
+(NSMutableArray *)getNoteListWithNoteTypeID:(NSInteger)noteTypeID type:(NSInteger)type noteList:(NSMutableArray *)noteList;
+(NSMutableArray *)getNoteListWithNoteTypeID:(NSInteger)noteTypeID noteList:(NSMutableArray *)noteList;
+(Note *)getNote:(NSInteger)noteID branchID:(NSInteger)branchID;
//+(NSString *)getNoteIDListInText:(NSString *)noteIDListInText branchID:(NSInteger)branchID;
@end
