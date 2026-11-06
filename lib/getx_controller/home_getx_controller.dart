import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:souqna_anaqa/api/api_settings.dart';
import 'package:souqna_anaqa/models/banner_item.dart';
import 'package:souqna_anaqa/models/category.dart';
import 'package:souqna_anaqa/models/home.dart';
import 'package:souqna_anaqa/models/product.dart';
import 'package:souqna_anaqa/preferences/user_getstorage.dart';

/// محتوى الرئيسية يأتي من لوحة تحكم متجر لمسة عبر /home.
/// لا نعرض منتجات تجريبية حتى لا تسمح الواجهة بإضافة معرّفات غير موجودة للخادم.
class HomeGetxController extends GetxController {
  final isLoading = true.obs;
  final banners = <BannerItem>[].obs;
  final categories = <Category>[].obs;
  final featured = <Product>[].obs;
  final newest = <Product>[].obs;
  final bestSellers = <Product>[].obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHome();
  }

  Future<void> fetchHome() async {
    if (featured.isEmpty && newest.isEmpty) isLoading.value = true;
    errorMessage.value = '';
    final token = UserGetStorage().getToken();

    try {
      final response = await http
          .get(
            Uri.parse(ApiSettings.home),
            headers: {
              'Accept': 'application/json',
              'Accept-Language': 'ar',
              if (token.isNotEmpty) 'Authorization': 'Bearer $token',
            },
          )
          .timeout(ApiSettings.timeout);

      final decoded = jsonDecode(utf8.decode(response.bodyBytes));
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('استجابة الصفحة الرئيسية غير صالحة');
      }

      if (response.statusCode == 200 && decoded['success'] == true) {
        final homeData = HomeResponse.fromJson(decoded);
        banners.assignAll(homeData.banners ?? const <BannerItem>[]);
        categories.assignAll(homeData.categories ?? const <Category>[]);
        featured.assignAll(homeData.featured ?? const <Product>[]);
        newest.assignAll(homeData.newest ?? const <Product>[]);
        bestSellers.assignAll(homeData.bestSellers ?? const <Product>[]);

        if (categories.isEmpty && featured.isEmpty && newest.isEmpty) {
          errorMessage.value = 'لا توجد منتجات أو أقسام منشورة في المتجر حتى الآن';
        }
      } else {
        errorMessage.value = (decoded['message'] as String?) ??
            'تعذر جلب منتجات متجر لمسة';
      }
    } catch (_) {
      errorMessage.value = 'تعذر الاتصال بالخادم، تحقق من الإنترنت';
    } finally {
      isLoading.value = false;
    }
  }
}
