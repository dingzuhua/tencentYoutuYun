/**
 * 类：Conf
 * 描述：
 * 作者：dingzuhua
 * 创建时间：2019/4/10 15:38
 */

class Conf {
  String appId;
  String secretId;
  String secretKey;
  String userId;
  String API_END_POINT;
  String API_VIP_END_POINT;

  Conf() {
    this.appId = '10136451';//替换
    this.secretId = 'AKIDz5DPcrkQi0JhDi4nKqLNRcm4WxNo9qKo';//替换
    this.secretKey = 'jO6mR6kSAreSF1uJ2thUH7w27BEGKLLJ';//替换
    this.API_END_POINT = 'http://api.youtu.qq.com/youtu';
    this.API_VIP_END_POINT = 'https://vip-api.youtu.qq.com/youtu';
  }

  static Conf _singleton;

  static Conf instance() {
    if (_singleton != null) {
      return _singleton;
    } else {
      _singleton = Conf();
    }
    return _singleton;
  }
}
