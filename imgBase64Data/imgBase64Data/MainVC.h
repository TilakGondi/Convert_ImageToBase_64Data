//
//  MainVC.h
//  imgBase64Data
//
//  Created by Tilak_G on 02/07/14.

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
