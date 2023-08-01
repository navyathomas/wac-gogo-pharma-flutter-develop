import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/color_palette.dart';

class FontStyle {
  static const themeFont = "Lexend";

  ///10
  static TextStyle black10RegularH2 = TextStyle(
      fontSize: 10.sp,
      fontWeight: FontWeight.w400,
      height: 2,
      color: Colors.black);
  static TextStyle orange10RegularH2 = TextStyle(
      fontSize: 10.sp,
      height: 2,
      fontWeight: FontWeight.w400,
      color: HexColor('#FD7600'));
  static TextStyle white10Regular = TextStyle(
      fontSize: 10.sp, fontWeight: FontWeight.w400, color: Colors.white);
  static TextStyle black10Light = TextStyle(
      fontSize: 10.sp, fontWeight: FontWeight.w300, color: Colors.black);
  static TextStyle regular10_8A9CAC = TextStyle(
      fontSize: 10.sp, fontWeight: FontWeight.w400, color: HexColor('#8A9CAC'));
  static TextStyle blue10Regular_2680EB = TextStyle(
      fontSize: 10.sp, fontWeight: FontWeight.w400, color: HexColor('#2680EB'));
  static TextStyle grey_696969_10Regular = TextStyle(
      fontSize: 10.sp, fontWeight: FontWeight.w400, color: HexColor('#696969'));
  static TextStyle regular10Purple = TextStyle(
      fontSize: 10.sp, fontWeight: FontWeight.w400, color: HexColor('#764EA3'));

  ///11
  static TextStyle primary11Medium = TextStyle(
      fontSize: 11.sp, fontWeight: FontWeight.w600, color: HexColor('#00CBC0'));
  static TextStyle grey11Medium = TextStyle(
      fontSize: 11.sp, fontWeight: FontWeight.w500, color: HexColor('#696969'));
  static TextStyle litegrey11Regular = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: HexColor('#727272'),
  );
  static TextStyle litegrey11RegularLineThrough = TextStyle(
    fontSize: 11.sp,
    fontWeight: FontWeight.w400,
    color: HexColor('#727272'),
    decoration: TextDecoration.lineThrough,
  );
  static TextStyle red11Regular = TextStyle(
      fontSize: 11.sp, fontWeight: FontWeight.w400, color: HexColor('#FF6464'));
  static TextStyle slightDarkGrey11Regular = TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w400,
      color: ColorPalette.slightDarkGrey);
  static TextStyle blue11Medium_7787FF = TextStyle(
      fontSize: 11.sp, fontWeight: FontWeight.w500, color: HexColor('#7787FF'));
  static TextStyle regular11Red = TextStyle(
      fontSize: 11.sp, fontWeight: FontWeight.w400, color: HexColor("#FC6261"));
  static TextStyle regular11RedFF5 = TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w400,
      color: HexColor("##FF5F5F"));
  static TextStyle regular11_6E = TextStyle(
      fontSize: 11.sp, fontWeight: FontWeight.w400, color: HexColor("#6E6E6E"));
  static TextStyle grey11Medium_556879 = TextStyle(
      fontSize: 11.sp, fontWeight: FontWeight.w500, color: HexColor('#556879'));

  ///12
  static TextStyle black12Medium = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.black);
  static TextStyle white12Medium = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.white);
  static TextStyle grey12Medium_556879 = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w500, color: HexColor('#556879'));
  static TextStyle grey12Regular_556879 = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w400, color: HexColor('#556879'));
  static TextStyle dimGrey12Regular = TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: ColorPalette.dimGrey);
  static TextStyle shadeGrey12Regular = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w400, color: HexColor("#6E6E6E"));
  static TextStyle grey12Light_556879 = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w300, color: HexColor('#556879'));
  static TextStyle grey12Regular_504F4F = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w400, color: HexColor('#504F4F'));
  static TextStyle green12Regular = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w400, color: HexColor('#4FBC16'));
  static TextStyle grey12Regular_6969 = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w400, color: HexColor('#696969'));
  static TextStyle green12Medium_2AD16A = TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w500,
      color: HexColor('##2AD16A'));
  static TextStyle primary12Regular = TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      color: ColorPalette.primaryColor);
  static TextStyle red12Regular = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w400, color: HexColor('#FF6464'));
  static TextStyle grey12Regular_8A9CAC = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w400, color: HexColor('#8A9CAC'));
  static TextStyle medium12_556879 = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w500, color: HexColor('#556879'));
  static TextStyle liteBlack12Medium = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w500, color: HexColor('#2B2B2B'));
  static TextStyle green12RegularW300 = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w300, color: HexColor('#6CA200'));
  static TextStyle yellow12RegularW300 = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w300, color: HexColor('#F29800'));
  static TextStyle redErr12RegularW300 = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w300, color: HexColor('#FF5F5F'));
  static TextStyle regular12_6E6E6E = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w400, color: HexColor('#6E6E6E'));
  static TextStyle red12Medium = TextStyle(
      fontSize: 12.sp, fontWeight: FontWeight.w500, color: Colors.redAccent);

  ///13
  static TextStyle grey_6E6E6E_13Regular = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: HexColor('#6E6E6E'));
  static TextStyle grey_696969_13Regular = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: HexColor('#696969'));
  static TextStyle grey_8E8E8E_13Regular = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: HexColor('#8E8E8E'));
  static TextStyle grey_6E6E6E_13Medium = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w500, color: HexColor('#6E6E6E'));
  static TextStyle grey_556879_13Medium = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: HexColor('#556879'));
  static TextStyle grey_556879_13Strong = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w600, color: HexColor('#556879'));
  static TextStyle grey_345457_13Regular = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: HexColor('#345457'));
  static TextStyle white13Regular = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.white);
  static TextStyle black13Medium = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.black);
  static TextStyle green13Medium = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w500, color: HexColor('#4FBC16'));
  static TextStyle green13Regular_36BFB8 = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: HexColor('#36BFB8'));
  static TextStyle black13bold = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w700, color: Colors.black);
  static TextStyle liteblack13Medium = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w500, color: HexColor('#2B2B2B'));
  static TextStyle liteBlack13Regular = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: HexColor('#2B2B2B'));
  static TextStyle black13Regular = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.black);
  static TextStyle slightDarkGrey13Regular = TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      color: ColorPalette.slightDarkGrey);
  static TextStyle regular13_696969 = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: HexColor('#696969'));
  static TextStyle regular13_556879 = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: HexColor('#556879'));
  static TextStyle regular13_8A9CAC = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: HexColor('#8A9CAC'));
  static TextStyle grey13Regular_556879 = TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w400, color: HexColor('#556879'));
  static TextStyle grey13Regular_586876 = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: HexColor('#586876'));
  static TextStyle blue13Regular_2E78C3 = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: HexColor('#2E78C3'));
  static TextStyle grey13Regular_393939 = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: HexColor('#393939'));
  static TextStyle grey13Medium_8A9CAC = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w500, color: HexColor('#8A9CAC'));
  static TextStyle black13SemiBold_393939 = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w600, color: HexColor('#393939'));
  static TextStyle primary13Medium = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w500, color: HexColor('#00CBC0'));
  static TextStyle black13Medium_212121 = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w400, color: HexColor('#212121'));

  ///14
  static TextStyle primary14Medium = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w600, color: HexColor('#00CBC0'),fontFamily: themeFont);
  static TextStyle black14MediumW400 = TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w400,
    color: HexColor('#000000'),
  );
  static TextStyle grey14Medium = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: HexColor('#696969'));
  static TextStyle lightCreamGrey14Medium = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: HexColor('#C7C7C7'));
  static TextStyle grey14Regular_6E6E = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: HexColor('#6E6E6E'));
  static TextStyle green14Medium_36BFB8 = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#36BFB8'));
  static TextStyle primary14Regular = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: ColorPalette.primaryColor);
  static TextStyle slightDarkGrey14Regular = TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      color: ColorPalette.slightDarkGrey);
  static TextStyle green14Regular = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: HexColor('#4FBC16'));
  static TextStyle orange14Regular = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: HexColor('#FF5F5F'));

  static TextStyle black14Regular = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: HexColor('#000000'));
  static TextStyle black14RegularW500 = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#000000'));
  static TextStyle lightGreyBlack14Regular = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: HexColor('#696969'));
  static TextStyle yellow14Regular = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#FD7600'));
  static TextStyle black14Medium = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#000000'),fontFamily: themeFont);
  static TextStyle disable14TextMedium = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#DEDEDE'));
  static TextStyle black14SemiBold = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w600, color: HexColor('#000000'));
  static TextStyle grey14Regular_8A9CAC = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: HexColor('#8A9CAC'));
  static TextStyle blue14Medium = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#2680EB'));
  static TextStyle white13Medium = TextStyle(
      fontSize: 13.sp, fontWeight: FontWeight.w500, color: Colors.white);
  static TextStyle grey14Regular_464646 = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: HexColor('#464646'));
  static TextStyle grey14Medium_464646 = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#464646'));
  static TextStyle dimGrey14Regular = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#8A9CAC'));
  static TextStyle black14MediumStrong = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#2B2B2B'));

  // static TextStyle grey14Medium = TextStyle(
  //     fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#696969'));
  static TextStyle semiBold14Green = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w600, color: HexColor('#36BFB8'));
  static TextStyle medium14_282C3F = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#282C3F'));
  static TextStyle bold14Black = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.black);
  static TextStyle black14Normal = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: HexColor('#111111'));
  static TextStyle grey14Regular = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: HexColor('#8A9CAC'));
  static TextStyle green14Medium = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#00CBC0'));
  static TextStyle grey14regular = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: HexColor('#556879'));
  static TextStyle red14medium = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#F05656'));

  ///15
  static TextStyle black15Bold = TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w700, color: Colors.black);
  static TextStyle black15SemiBold = TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.black);
  static TextStyle white15Medium = TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w500, color: Colors.white);
  static TextStyle black15Medium = TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w500, color: Colors.black);
  static TextStyle black15Medium_2B = TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w500, color: HexColor('#2B2B2B'));
  static TextStyle black15Regular = TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w400, color: Colors.black);
  static TextStyle mildBlack15Medium = TextStyle(
      fontSize: 14.sp, fontWeight: FontWeight.w500, color: HexColor('#333333'));
  static TextStyle white15MediumW600 = TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w600, color: HexColor('#FFFFFF'));
  static TextStyle primary15SemiBold = TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w700,
      color: ColorPalette.primaryColor);
  static TextStyle dimGrey15SemiBold = TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w700,
      color: ColorPalette.dimGrey);
  static TextStyle dimGrey15Regular = TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w400,
      color: ColorPalette.dimGrey);
  static TextStyle grey15Regular69696 = TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w400, color: HexColor("#696969"));
  static TextStyle grey15Regular_556879 = TextStyle(
      fontSize: 15.sp, fontWeight: FontWeight.w400, color: HexColor('#556879'));
  static TextStyle grey15Regular8A9CACLine = TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w400,
      color: HexColor('#8A9CAC'),
      decoration: TextDecoration.lineThrough);

  ///16
  static TextStyle black16SemiBold_2B = TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w600, color: HexColor('#111111'));
  static TextStyle black16SemiBold = TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w600, color: HexColor('#2B2B2B'));
  static TextStyle black16Medium = TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w500, color: Colors.black);
  static TextStyle black16Bold = TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.bold, color: HexColor('#282C3F'));
  static TextStyle semiBold16_282C3F = TextStyle(
      fontSize: 16.sp, fontWeight: FontWeight.w600, color: HexColor('#282C3F'));

  ///17
  static TextStyle black17Regular = TextStyle(
      fontSize: 17.sp, fontWeight: FontWeight.w400, color: HexColor('#000000'));
  static TextStyle black17Regularw600 = TextStyle(
      fontSize: 17.sp, fontWeight: FontWeight.w600, color: HexColor('#000000'));

  ///18
  static TextStyle black18Bold = TextStyle(
      fontSize: 18.sp, fontWeight: FontWeight.bold, color: HexColor('#111111'));
  static TextStyle black18SemiBold = TextStyle(
      fontSize: 18.sp, fontWeight: FontWeight.w600, color: HexColor('#000000'));
  static TextStyle black18Regular = TextStyle(
      fontSize: 18.sp, fontWeight: FontWeight.w400, color: HexColor('#000000'));
  static TextStyle white18Regular = TextStyle(
      fontSize: 18.sp, fontWeight: FontWeight.w400, color: Colors.white);

  ///19
  static TextStyle white19Bold = TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w700,
    color: HexColor('#FFFFFF'),
  );
  static TextStyle black19Medium = TextStyle(
    fontSize: 19.sp,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );

  ///20
  static TextStyle black20Medium = TextStyle(
      fontSize: 18.sp, fontWeight: FontWeight.w500, color: HexColor('#000000'));
  static TextStyle black20SemiBold = TextStyle(
      fontSize: 20.sp, fontWeight: FontWeight.w600, color: HexColor('#111111'));

  ///30
  static TextStyle black30Regular = TextStyle(
      fontSize: 30.sp, fontWeight: FontWeight.w400, color: HexColor('#000000'));
}
