import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:souqna_anaqa/getx_controller/app_getx_controller.dart';
import 'package:souqna_anaqa/getx_controller/cart_getx_controller.dart';
import 'package:souqna_anaqa/getx_controller/favorites_getx_controller.dart';
import 'package:souqna_anaqa/getx_controller/home_getx_controller.dart';
import 'package:souqna_anaqa/getx_controller/order_getx_controller.dart';
import 'package:souqna_anaqa/getx_controller/user_profile_getx_controller.dart';
import 'package:souqna_anaqa/screen/lunch/lunch_screen.dart';
import 'package:souqna_anaqa/utils/app_colors.dart';
import 'package:souqna_anaqa/utils/responsive.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await initializeDateFormatting('ar');
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // نسجّل الكنترولرز قبل runApp لأن الثيم يقرأ لون المتجر من AppGetxController.
  InitialBinding().dependencies();

  runApp(const AnaqaApp());
}

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // الترتيب مهم: السلة والمفضلة قبل الحساب لأن الحساب يحدّثهما عند الدخول والخروج.
    Get.put(CartGetxController(), permanent: true);
    Get.put(FavoritesGetxController(), permanent: true);
    Get.put(OrderGetxController(), permanent: true);
    Get.put(UserProfileGetxController(), permanent: true);
    Get.put(AppGetxController(), permanent: true);

    Get.lazyPut(() => HomeGetxController(), fenix: true);
  }
}

class AnaqaApp extends StatelessWidget {
  const AnaqaApp({super.key, this.home = const LunchScreen()});

  /// الشاشة الأولى؛ اختبارات التخطيط تمرّر شاشات أخرى بنفس الثيم وتهيئة ScreenUtil.
  final Widget home;

  @override
  Widget build(BuildContext context) {
    // تهيئة ScreenUtil مرة واحدة هنا فقط.
    // designSize = 375×812 لأن إطارات فيجما بهذه الأبعاد المنطقية.
    // minTextAdapt: الخط يتبع الأصغر بين العرض والارتفاع فلا يتضخم في الوضع الأفقي.
    // splitScreenMode: يعامل الارتفاع القصير (تقسيم الشاشة/أفقي) كـ 700 على الأقل.
    return ScreenUtilInit(
      designSize: Responsive.designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      fontSizeResolver: Responsive.fontSize,
      builder: (context, _) {
        Responsive.capScale(context);
        return GetMaterialApp(
          title: 'لمسة | مكياج وعناية طبيعية',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.build(Get.find<AppGetxController>().primary.value),
          locale: const Locale('ar'),
          fallbackLocale: const Locale('ar'),
          supportedLocales: const [Locale('ar'), Locale('en')],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: home,
        );
      },
    );
  }
}
