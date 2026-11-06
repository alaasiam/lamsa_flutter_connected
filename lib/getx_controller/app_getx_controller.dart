import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:souqna_anaqa/api/api_settings.dart';
import 'package:souqna_anaqa/models/store_info.dart';
import 'package:souqna_anaqa/utils/app_colors.dart';
import 'package:souqna_anaqa/utils/helpers.dart';

/// معلومات المتجر (الاسم، الشعار، اللون، التوصيل) — تُحمّل مرة عند فتح التطبيق.
class AppGetxController extends GetxController {
  var isLoading = false.obs;
  var store = Rxn<StoreInfo>();
  var primary = const Color(0xFFC86D7D).obs;
  final RxString errorMessage = ''.obs;

  Future<bool> fetchStore() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final response = await http
          .get(
            Uri.parse(ApiSettings.store),
            headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
          )
          .timeout(ApiSettings.timeout);

      final body = jsonDecode(utf8.decode(response.bodyBytes));

      if (response.statusCode == 200 && body['success'] == true) {
        final info = StoreInfoResponse.fromJson(body).data!;
        if (info.primaryColor == const Color(0xFFEBC1B3)) {
          info.primaryColor = const Color(0xFFC86D7D);
        }
        // نحافظ على اسم المتجر وشعاره ولونه كما أُدخلت في لوحة التحكم.
        // الوصف القصير افتراضي فقط عندما لا يحدده صاحب المتجر.
        if (info.tagline == null || info.tagline!.trim().isEmpty) {
          info.tagline = 'جمالك بلمسة طبيعية';
        }
        store.value = info;
        Fmt.symbol = info.currencySymbol;
        if (info.primaryColor != primary.value) {
          primary.value = info.primaryColor;
          Get.changeTheme(AppTheme.build(info.primaryColor));
        }
        return true;
      } else {
        errorMessage.value = body['message'] ?? 'فشل في جلب بيانات المتجر';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'تعذر الاتصال بالخادم، تحقق من الإنترنت';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
