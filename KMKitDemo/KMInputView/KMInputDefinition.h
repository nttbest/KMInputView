//
// Created by Lijing on 16/1/8.
// Copyright (c) 2016 思源. All rights reserved.
//

typedef NS_ENUM(NSInteger, KMInputViewType) {
    KMInputViewTypeNull                         = 1000 << 0,
    KMInputViewTypeText                         = 1000 << 1,
    KMInputViewTypeVoiceInputView               = 1000 << 2,
    KMInputViewTypeVideoInputView               = 1000 << 3,
    KMInputViewTypePictureInputView             = 1000 << 4,
    KMInputViewTypeEmotionInputView             = 1000 << 5,
    KMInputViewTypeMoreInputView                = 1000 << 6
};