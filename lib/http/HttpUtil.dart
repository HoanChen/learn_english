import 'package:dio/dio.dart';
import 'package:learn_english/bean/BeanFactory.dart';
import 'package:learn_english/bean/ResultBean.dart';
import 'package:learn_english/bean/ResultListBean.dart';
import 'package:learn_english/common/Constants.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;
  Dio _dio;
  HttpUtil._internal() {
    if (_dio == null) {
      _dio =
          Dio(BaseOptions(baseUrl: Constants.BASE_URL, connectTimeout: 15000));
      _dio.interceptors.add(LogInterceptor(responseBody: true));
    }
  }

  Future<O> simpleGet<O>(api, {params}) => request<O, O>(api, data: params);

  Future<R> get<R, O>(api, {params}) => request<R, O>(api, data: params);

  Future<R> post<R, O>(api, data) =>
      request<R, O>(api, data: data, method: 'post');

  Future<R> put<R, O>(api, data) =>
      request<R, O>(api, data: data, method: 'put');

  // 支持Get Post
  Future<R> request<R, O>(String api, {data, method}) async {
    var response;
    if (method == 'post') {
      response = await _dio.post(api,
          data: data,
          options: data is FormData
              ? Options(contentType: 'application/x-www-form-urlencoded')
              : null);
    } else if (method == 'put') {
      response = await _dio.put(api, data: data);
    } else {
      response = await _dio.get(api, queryParameters: data);
    }
    var r = R.toString();
    if (r == ResultBean.CLASS_NAME) {
      return ResultBean<O>.fromJson(response.data) as R;
    } else if (r == ResultListBean.CLASS_NAME) {
      return ResultListBean<O>.fromJson(response.data) as R;
    } else if (r == O.toString()) {
      return BeanFactory.generateObject<R>(response.data);
    } else {
      throw Exception('请在请求方法上设置正确泛型！');
    }
  }
}
