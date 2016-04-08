//
// Created by Lijing on 16/1/8.
// Copyright (c) 2016 思源. All rights reserved.
//

#import "KMInputMenuView.h"
#import "KMSegmentedView.h"
#import "KMSegmentedData.h"
#import "KMInputDefinition.h"
#import "KMStatusHelper.h"


@implementation KMInputMenuView {

}

- (void)initSegmentedView:(KMSegmentedView *)segmentedView {
    segmentedView.isShowSplitBorder = NO;
    segmentedView.bottomLineHeight = 0;
    segmentedView.itemBackgroundColor = [UIColor clearColor];
    segmentedView.selectedItemBackgroundColor = [UIColor clearColor];
    segmentedView.currentSelectedIndex = -1;
    segmentedView.enablSelectCurrentItem = YES;
}


- (void)initDataSource {
    NSArray *imgArr = @[
            @"chat_bottom_PTT_nor",
            @"chat_bottom_PTV_nor",
            @"chat_bottom_photo_nor",
            @"chat_bottom_emotion_nor",
            @"chat_bottom_more_nor",
    ];
    NSArray *imgArrSel = @[
            @"chat_bottom_PTT_press",
            @"chat_bottom_PTV_press",
            @"chat_bottom_photo_press",
            @"chat_bottom_emotion_press",
            @"chat_bottom_more_press",
    ];

    self.dataSource = [@[
            ({
                KMSegmentedData *optionData = [[KMSegmentedData alloc] init];
                optionData.value = [NSString stringWithFormat:@"%li", (long)KMInputViewTypeVoiceInputView];
                optionData.image= [KMStatusHelper imageNamed:imgArr[0]];
                optionData.selectedImage= [KMStatusHelper imageNamed:imgArrSel[0]];
                optionData;
            }),
            ({
                KMSegmentedData *optionData = [[KMSegmentedData alloc] init];
                optionData.value = [NSString stringWithFormat:@"%li", (long)KMInputViewTypeVideoInputView];
                optionData.image= [KMStatusHelper imageNamed:imgArr[1]];
                optionData.selectedImage= [KMStatusHelper imageNamed:imgArrSel[1]];
                optionData;
            }),
            ({
                KMSegmentedData *optionData = [[KMSegmentedData alloc] init];
                optionData.value = [NSString stringWithFormat:@"%li", (long)KMInputViewTypePictureInputView];
                optionData.image= [KMStatusHelper imageNamed:imgArr[2]];
                optionData.selectedImage= [KMStatusHelper imageNamed:imgArrSel[2]];
                optionData;
            }),
            ({
                KMSegmentedData *optionData = [[KMSegmentedData alloc] init];
                optionData.value = [NSString stringWithFormat:@"%li", (long)KMInputViewTypeEmotionInputView];
                optionData.image= [KMStatusHelper imageNamed:imgArr[3]];
                optionData.selectedImage= [KMStatusHelper imageNamed:imgArrSel[3]];
                optionData;
            }),
            ({
                KMSegmentedData *optionData = [[KMSegmentedData alloc] init];
                optionData.value = [NSString stringWithFormat:@"%li", (long)KMInputViewTypeMoreInputView];
                optionData.image= [KMStatusHelper imageNamed:imgArr[4]];
                optionData.selectedImage= [KMStatusHelper imageNamed:imgArrSel[4]];
                optionData;
            })] mutableCopy];
}
@end