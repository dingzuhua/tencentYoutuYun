import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
/**
 * 类：Auth
 * 描述：
 * 作者：dingzuhua
 * 创建时间：2019/4/10 15:45
 */
import 'package:tencent_youtuyun/utils/tencentYoutuYun/Conf.dart';

class Auth {
  static const int USER_ID_MAX_LEN = 64;
  static const int URL_MAX_LEN = 1024;
  static const int PLAIN_TEXT_MAX_LEN = 4096;
  static const int CIPER_TEXT_MAX_LEN = 1024;

  static String appSign(int expired, String userId) {
    if (Conf.instance().secretId.length <= 0 ||
        Conf.instance().secretKey.length <= 0) {
      print('错误:secrettid 或 secretKey为空!');
      return null;
    }
    if (Conf.instance().userId != null &&
        Conf.instance().userId.length > USER_ID_MAX_LEN) {
      print('错误:userId超过了长度限制!');
      return null;
    }

    int now = (new DateTime.now().millisecondsSinceEpoch / 1000).round();
    int rdm = Random().nextInt(10) % 1000000000;
    String origin =
        'a=${Conf.instance().appId}&k=${Conf.instance().secretId}&e=${expired + now}&t=${now}&r=${rdm}&u=${int.parse(Conf.instance().userId == null ? '0' : Conf.instance().userId)}&f=';
    List<int> data = Auth.hmacsha1(origin, Conf.instance().secretKey);
    List<int> all = new List.from(data);
    all.addAll(utf8.encode(origin));
    return base64Encode(all);
  }

  static List<int> hmacsha1(String data, String key) {
    var vkey = ascii.encode(key);
    var vdata = ascii.encode(data);

    var hmacSha1 = new Hmac(sha1, vkey);
    var digest = hmacSha1.convert(vdata);
    return digest.bytes;
  }
}
