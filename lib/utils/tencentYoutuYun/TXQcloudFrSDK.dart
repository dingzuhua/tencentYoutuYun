/**
 * 类：TXQcloudFrSDK
 * 描述：
 * 作者：dingzuhua
 * 创建时间：2019/4/10 17:20
 */
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:tencent_youtuyun/utils/tencentYoutuYun/Auth.dart';
import 'package:tencent_youtuyun/utils/tencentYoutuYun/Conf.dart';

class TXQcloudFrSDK {
  String API_END_POINT;
  String appid;
  String authorization;

  TXQcloudFrSDK()
      : API_END_POINT = Conf.instance().API_END_POINT,
        appid = Conf.instance().appId,
        authorization = Auth.appSign(1000000, '2309398913'); //替换

  static TXQcloudFrSDK sdk;

  //cardType  0-身份证正面  1-身份证背面
  static idcardOcrFaceIn(
      File image,
      int cardType,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['image'] = '${await TXQcloudFrSDK.imageBase64String(image)}';
    jsonData['card_type'] = cardType;

    TXQcloudFrSDK.sendRequest(
        jsonData, '/ocrapi/idcardocr', successBlock, failureBlock);
  }

  static imageBase64String(File image) async {
    var result = await FlutterImageCompress.compressWithFile(
      image.absolute.path,
      quality: 90,
    );
    return base64Encode(result);
  }

  static sendRequest(Map jsonData, String mothod,
      Function(Map response) successBlock, Function(dynamic) failureBlock) {
    Dio dio = new Dio(new Options(
        connectTimeout: 5000,
        receiveTimeout: 5000,
        baseUrl: sdk.API_END_POINT,
        headers: {'Authorization': sdk.authorization}));
    jsonData['app_id'] = '${sdk.appid}';
    Options op = new Options(contentType: ContentType.parse("text/json"));
    dio
        .post(mothod, data: json.encode(jsonData), options: op)
        .then((Response response) {
      Map responseJson = json.decode(response.data);
      if (responseJson['errorcode'] == 0) {
        successBlock(responseJson);
      } else {
        responseJson['errormsg'] = TXQcloudFrSDK.getMsgByCode(responseJson);
        failureBlock(responseJson);
      }
    }).catchError((error) {
      failureBlock(error);
    });
  }

  static String getMsgByCode(Map responseJson) {
    switch (responseJson['errorcode']) {
      case -5109:
        return "照片模糊";
      case -5103:
        return "OCR识别失败";
      case -5106:
        return "身份证边框不完整";
      case -5107:
        return "该图片不是身份证";
      case -5108:
        return "身份证信息不合规范";
        break;
      default:
        return "未知错误:${responseJson['errormsg']}";
        break;
    }
  }
}
