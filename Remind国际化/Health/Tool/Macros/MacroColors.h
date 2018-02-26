//
//  MacroColors.h
//  Health
//
//  Created by perfectbao on 17/3/13.
//  Copyright © 2017年 PerfectBao. All rights reserved.
//

#ifndef MacroColors_h
#define MacroColors_h

#define Color_Button [UIColor add_colorWithRed255:62 green255:163 blue255:254]

#define COLOR_000  [Tools hexStringToColor:@"183b7b"]
#define COLOR_001  [UIColor colorWithRed:28/255.0 green:159/255.0 blue:237/255.0 alpha:1]
#define COLOR_002  [UIColor whiteColor]
#define COLOR_003  [UIColor colorWithRed:129/255.0 green:183/255.0 blue:222/255.0 alpha:1]
//#define COLOR_003  [UIColor colorWithRed:128/255.0 green:180/255.0 blue:218/255.0 alpha:1]

#define CLEARCOLOR [UIColor clearColor]


#define FONTSIZE(X)     [UIFont systemFontOfSize:X]
#define FONT_12     [UIFont systemFontOfSize:12.f]
#define FONT_15     [UIFont systemFontOfSize:15.f]

#define IMGNAME(X)  [UIImage imageNamed:X]

#define LOCALIZED(X) NSLocalizedString(X,nil)


#endif /* MacroColors_h */
