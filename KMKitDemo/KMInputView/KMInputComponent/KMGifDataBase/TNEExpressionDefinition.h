//
//  TNEExpressionDefinition.h
//  Toon
//
//  Created by wangpeirong on 15/12/9.
//  Copyright © 2015年 思源. All rights reserved.
//

#ifndef TNEExpressionDefinition_h
#define TNEExpressionDefinition_h

#define TNEFaceBagClass    @"TNEDBFaceBagModel"
#define TNEFaceShopClass   @"TNEFaceShopModel"
#define TNEEmojiClass      @"TNEDBEmojiModel"

/************* 表情包详情本地数据库字段 **********************/
/**
 *      名称              字段             类型       说明
 *
 *      主键ID            id              int       额外加的字段
 *      表情包ID          faceBagId       int
 *      表情包名称         name            text
 *      表情包价格         price           int
 *      推广语            slogan          text
 *      介绍              intro           text
 *      备注              mark            text
 *      排列顺序          orderBy          int
 *      表情包图ID        picId            int
 *      图片url           picUrl          text
 *      是否显示          isDownload       int      已下载的表情包，移除以后只改状态，不删除
 
 *      库存量             totals          int
 *      剩余量             remain          int
 *      上线时间           lineTime        text
 *      已售总额            amount         int
 
 *      备用字段1         attribute01      text
 *      备用字段2         attribute02      text
 *
 */

/************** 表情本地数据库字段 *********************/
/**
 *      名称              字段             类型       说明
 *
 *      主键ID            id              int       额外加的字段
 *      表情包ID          faceBagId        int
 *      表情名称           faceName        text
 *      表情ID            faceId           int
 *      表情描述           des             text
 *      图片ID            facePicId        int
 *      图片url           picUrl          text
 *      备用字段1         attribute01      text
 *      备用字段2         attribute02      text
 *
 */

#endif /* TNEExpressionDefinition_h */
