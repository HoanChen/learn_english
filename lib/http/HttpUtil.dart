import 'package:dio/dio.dart';
import 'package:learn_english/bean/BeanFactory.dart';
import 'package:learn_english/bean/ResultBean.dart';
import 'package:learn_english/bean/ResultListBean.dart';
import 'package:learn_english/common/Constants.dart';
import 'package:learn_english/common/LoginInfoUtil.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;
  Dio _dio;

  HttpUtil._internal() {
    if (_dio == null) {
      _dio =
          Dio(BaseOptions(baseUrl: Constants.BASE_URL, connectTimeout: 15000));
      _dio.interceptors
          .add(LogInterceptor(requestBody: true, responseBody: true));
    }
  }

  static HttpUtil getInstance({String baseUrl}) {
    if (baseUrl != null) _instance._dio.options.baseUrl = baseUrl;
    return _instance;
  }

  Future<O> simpleGet<O>(api, {params, needToken = true}) =>
      request<O, O>(api, data: params, needToken: needToken);

  Future<R> get<R, O>(api, {params, needToken = true}) =>
      request<R, O>(api, data: params, needToken: needToken);

  Future<R> post<R, O>(api, data, {needToken = true}) =>
      request<R, O>(api, data: data, method: 'post', needToken: needToken);

  Future<R> put<R, O>(api, data, {needToken = true}) =>
      request<R, O>(api, data: data, method: 'put', needToken: needToken);

  // 支持Get Post
  Future<R> request<R, O>(String api, {data, method, needToken}) async {
    Options options;
    if (needToken || data is FormData) {
      options = Options();
      if (data is FormData) {
        options.contentType = Headers.formUrlEncodedContentType;
      }
      if (needToken) {
        options.headers
            .addAll({Constants.HEAD_TOKEN_KEY: LoginInfoUtil().getToken()});
      }
    }
    var response;
    DioError error;
    if (method == 'post') {
      response =
          await _dio.post(api, data: data, options: options).catchError((e) {
        error = e;
      });
    } else if (method == 'put') {
      response =
          await _dio.put(api, data: data, options: options).catchError((e) {
        error = e;
      });
    } else {
      response = await _dio
          .get(api, queryParameters: data, options: options)
          .catchError((e) {
        error = e;
      });
    }
    var json = response != null ? response.data : null;
    var r = R.toString();
    if (r == ResultBean.CLASS_NAME) {
      return ResultBean<O>.fromJson(json, error) as R;
    } else if (r == ResultListBean.CLASS_NAME) {
      return ResultListBean<O>.fromJson(json, error) as R;
    } else if (r == O.toString()) {
      if (error != null) {
        return throw error;
      } else {
        return BeanFactory.generateObject<R>(json);
      }
    } else {
      throw Exception('请在请求方法上设置正确泛型！');
    }
  }
}
