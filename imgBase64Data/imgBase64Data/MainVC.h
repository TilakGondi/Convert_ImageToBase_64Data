//
//  MainVC.h
//  imgBase64Data
//
//  Created by DEV_IPHONE_01 on 02/07/14.
//  Copyright (c) 2014 rossitek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainVC : UIViewController<UITextViewDelegate,UINavigationControllerDelegate,UIPopoverControllerDelegate,UIPickerViewDelegate,UIImagePickerControllerDelegate>
{
    UIButton *btnPic;
    UITextView *base64DataTxt;
    UIPopoverController *popOverPhotoSelector;
    
}
@property (strong, nonatomic) UINavigationController *navController;
@property(nonatomic,strong)UIPopoverController *popOverController,*popOverPhotoSelector;
@end
