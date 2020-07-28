import 'package:dio/dio.dart';
import 'package:learn_english/bean/BeanFactory.dart';
import 'package:learn_english/bean/ResultBean.dart';
import 'package:learn_english/bean/ResultListBean.dart';
import 'package:learn_english/common/Constants.dart';

import 'TokenInterceptor.dart';

class HttpUtil {
  static final HttpUtil _instance = HttpUtil._internal();

  factory HttpUtil() => _instance;
  Dio _dio;

  HttpUtil._internal() {
    if (_dio == null) {
      _dio =
          Dio(BaseOptions(baseUrl: Constants.BASE_URL, connectTimeout: 15000));
      _dio.interceptors.add(TokenInterceptor());
      _dio.interceptors
          .add(LogInterceptor(requestBody: false, responseBody: true));
    }
  }

  static HttpUtil getInstance({String baseUrl}) {
    if (baseUrl != null) _instance._dio.options.baseUrl = baseUrl;
    return _instance;
  }

  Future<O> simpleGet<O>(api, {params}) => request<O, O>(api, data: params);

  Future<R> get<R, O>(api, {params}) => request<R, O>(api, data: params);

  Future<R> post<R, O>(api, data) =>
      request<R, O>(api, data: data, method: 'post');

  Future<R> put<R, O>(api, data) =>
      request<R, O>(api, data: data, method: 'put');

  CancelToken _cancelToken = CancelToken();

  Future<R> request<R, O>(String api, {data, method}) async {
    Options options;
    if (data is FormData) {
      Options options = Options();
      options.contentType = Headers.formUrlEncodedContentType;
    }
    var response;
    DioError error;
    if (method == 'post') {
      response = await _dio
          .post(api, data: data, options: options, cancelToken: _cancelToken)
          .catchError((e) {
        error = e;
      });
    } else if (method == 'put') {
      response = await _dio
          .put(api, data: data, options: options, cancelToken: _cancelToken)
          .catchError((e) {
        error = e;
      });
    } else {
      response = await _dio
          .get(api,
              queryParameters: data,
              options: options,
              cancelToken: _cancelToken)
          .catchError((e) {
        error = e;
      });
    }
    var resJson = response != null ? response.data : null;
    var r = R.toString();
    if (r == ResultBean.CLASS_NAME) {
      return ResultBean<O>.fromJson(resJson, error) as R;
    } else if (r == ResultListBean.CLASS_NAME) {
      return ResultListBean<O>.fromJson(resJson, error) as R;
    } else if (r == O.toString()) {
      if (error != null) {
        return throw error;
      } else {
        return BeanFactory.generateObject<R>(resJson);
      }
    } else {
      throw Exception('请在请求方法上设置正确泛型！');
    }
  }

  void cancel() {
    _cancelToken.cancel();
    _cancelToken = CancelToken();
  }

  void lock() => _dio.lock();

  void unlock() => _dio.unlock();

  Dio _tokenDio;

  Dio tokenDio() {
    if (_tokenDio == null) {
      _tokenDio =
          Dio(BaseOptions(baseUrl: Constants.BASE_URL, connectTimeout: 15000));
      _tokenDio.interceptors
          .add(LogInterceptor(requestBody: false, responseBody: true));
    }
    return _tokenDio;
  }
}
