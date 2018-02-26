//
//  HUDUtils.m
//  omayhr
//
//  Created by user on 13-8-12.
//  Copyright (c) 2013年 zhiduan. All rights reserved.
//

#import "HUDUtils.h"
#import "MBProgressHUD.h"

static MBProgressHUD *toastHUD, *txtHUD, *progressHUD;

@implementation HUDUtils

+ (MBProgressHUD *)getProgressHUD {
    if (!progressHUD) {
            progressHUD = [[MBProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication].delegate window] ];
    }
    return progressHUD;
}

+ (MBProgressHUD *)getToastHUD {
    if (!toastHUD) {
        toastHUD = [[MBProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication].delegate window] ];
    }
    return toastHUD;
}

+ (MBProgressHUD *)getTxtHUD {
    if (!txtHUD) {
        txtHUD = [[MBProgressHUD alloc] initWithWindow:[[UIApplication sharedApplication].delegate window] ];
    }
    return txtHUD;
}

+ (UIView *)showHUDTxt:(NSString *)txt {
    MBProgressHUD *toast = [HUDUtils getTxtHUD];
    toast.mode = MBProgressHUDModeText;
    [toast setDimBackground:NO];
    [toast removeFromSuperview];
    [[[UIApplication sharedApplication].delegate window]  addSubview:toast];
    toast.detailsLabelText = txt;
    [toast show:NO];
    return toast;
}

+ (UIView *)showHUDToast:(NSString *)title {
    MBProgressHUD *toast = [HUDUtils getToastHUD];
    toast.mode = MBProgressHUDModeText;
    [toast setDimBackground:NO];
    [toast removeFromSuperview];
    [[[UIApplication sharedApplication].delegate window] addSubview:toast];
    toast.detailsLabelText = title;
    [toast showAnimated:YES whileExecutingBlock:^{
        [NSThread sleepForTimeInterval:0.8];
    } completionBlock:^{
        [toast removeFromSuperview];
    }];
    return toast;
}

+ (UIView *)showHUDProgress:(NSString *)title {
    MBProgressHUD *dialog = [HUDUtils getProgressHUD];
    dialog.mode = MBProgressHUDModeIndeterminate;
    [dialog setDimBackground:NO];
    [dialog removeFromSuperview];
    [[[UIApplication sharedApplication].delegate window]  addSubview:dialog];
    if (title) {
        dialog.labelText = title;
    } else {
        dialog.labelText = @"加载中...";
    }
    [dialog show:YES];
    return dialog;
}

+ (void)dismiss {
    [[HUDUtils getProgressHUD] removeFromSuperview];
}

+ (void)txtDismiss {
    [[HUDUtils getTxtHUD] removeFromSuperview];
}

+ (NSString *)getErrorMessage:(NSString *)code {
    NSString *error = NSLocalizedStringFromTable(code ? code : @"sys10001", @"Error", nil);
    char code0 = [error characterAtIndex:0];
    return code0 > 'a' && code0 < 'z' ? NSLocalizedStringFromTable(@"sys10001", @"Error", nil) : error;
}
@end