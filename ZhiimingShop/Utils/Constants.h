//
//  Constants.h
//  lzyw
//
//  Created by 高亚妮 on 15/4/30.
//  Copyright (c) 2015年 gaoyani. All rights reserved.
//

#import <Foundation/Foundation.h>

enum PaymentUnit {
    PaymentUnitDay,
    PaymentUnitWeek,
    PaymentUnitMouth,
    PaymentUnitYear
};

enum InputDataBasic {
    InputDataName,
    InputDataInfo,
    InputDataNumber,
    InputDataConsume,
    InputDataProbability
};

enum InputDataEmployee {
    InputDataChief,
    InputDataCook,
    InputDataBackman,
    InputDataManager,
    InputDataForeman,
    InputDataCashier
};

enum InputDataOther {
    InputDataRent,
    InputDataFood,
    InputDataDrink,
    InputDataExtras
};

enum InputPageFrom {
    InputPageFromMenu,
    InputPageFromHistory,
    InputPageFromDraft
};

enum SeatUnit {
    SeatUnitPeople,
    SeatUnitTable
};

extern NSString* const historyFilePath;
extern NSString* const draftFilePath;

extern NSString* const userNameKey;
extern NSString* const basicInfoKey;
extern NSString* const employeeInfoKey;
extern NSString* const otherInfoKey;

extern NSString* const weekDayKey;
extern NSString* const mouthDayKey;
extern NSString* const yearMouthKey;
extern NSString* const seatUnitKey;

extern NSString* const succeed;
extern NSString* const errorMessage;
extern NSString* const message;
extern NSString* const alreadyLogin;
extern NSString* const loadComplate;

@interface Constants : NSObject

@end
