import 'package:dio/dio.dart';

class ResultUtil {
  ///错误信息
  static errorMessage(DioError error) {
    switch (error.type) {
      // It occurs when url is opened timeout.
      case DioErrorType.CONNECT_TIMEOUT:
        return '连接超时';
      // It occurs when url is sent timeout.
      case DioErrorType.SEND_TIMEOUT:
        return '请求超时';
      //It occurs when receiving timeout.
      case DioErrorType.RECEIVE_TIMEOUT:
        return '响应超时';
      // When the server response, but with a incorrect status, such as 404, 503...
      case DioErrorType.RESPONSE:
        {
          if (error.response != null) {
            switch (error.response.statusCode) {
              case 401: //未携带token
                return "没有登录信息";
            }
          }
          return '请求失败';
        }
      // When the request is cancelled, dio will throw a error with this type.
      case DioErrorType.CANCEL:
        return '请求已取消';
      // Default error type, Some other Error. In this case, you can
      // use the DioError.error if it is not null.
      case DioErrorType.DEFAULT:
      default:
        return '未知异常';
    }
  }

  static String errorCode(DioError error) => '000000';
}
