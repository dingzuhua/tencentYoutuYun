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

  //人脸比对:使用优图数据源比对-----人脸核身相关接口
  //image:输入图片
  //idCardNumber:用户身份证号码
  //idCardName:用户身份证姓名
  static idcardfacecompare(
      File image,
      String idCardNumber,
      String idCardName,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['image'] = '${await TXQcloudFrSDK._imageBase64String(image)}';
    jsonData['idcard_number'] = idCardNumber;
    jsonData['idcard_name'] = idCardName;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/openliveapi/idcardfacecompare', successBlock, failureBlock);
  }

  //删除一个Person
  //personId:要删除的person ID
  static delPerson(
      String personId,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['person_id'] = personId;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/delperson', successBlock, failureBlock);
  }

  //获取一个face的相关特征信息
  //faceId:带查询的人脸ID
  static getFaceInfo(
      String faceId,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['face_id'] = faceId;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/getfaceinfo', successBlock, failureBlock);
  }

  //获取一个组person中所有face列表
  //personId:待查询的个体id
  static getFaceIds(
      String personId,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['person_id'] = personId;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/getfaceids', successBlock, failureBlock);
  }

  //获取一个AppId下所有group列表
  //groupId:待查询的组id
  static getPersonIds(
      String groupId,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['group_id'] = groupId;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/getpersonids', successBlock, failureBlock);
  }

  //获取一个AppId下所有group列表
  static getGroupIds(
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/getgroupids', successBlock, failureBlock);
  }

  //获取一个Person的信息, 包括name, id, tag, 相关的face, 以及groups等信息。
  //personId:待查询个体的ID
  static getInfo(
      String personId,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['person_id'] = personId;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/getinfo', successBlock, failureBlock);
  }

  //设置Person的name.
  //personId:要设置的person id
  //personName:新的name
  static setInfo(
      String personId,
      String personName,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['person_name'] = personName;
    jsonData['person_id'] = personId;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/setinfo', successBlock, failureBlock);
  }

  //删除一个person下的face，包括特征，属性和face_id.
  //faceIdArray:删除人脸id的列表
  //personId:待删除人脸的person ID
  static delFace(
      String personId,
      List faceIdArray,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['face_ids'] = faceIdArray;
    jsonData['person_id'] = personId;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/delface', successBlock, failureBlock);
  }

  //增加一个人脸Face.将一组Face加入到一个Person中。注意，一个Face只能被加入到一个Person中。一个Person最多允许包含100个Face。
  //images:人脸图片UIImage列表
  //personId:人脸Face的person id
  static addFace(
      String personId,
      List images,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    List baseImages = new List();
    for(int i=0;i<images.length;i++) {
      baseImages.add('${await TXQcloudFrSDK._imageBase64String(images[i])}');
    }
    jsonData['images'] = baseImages;
    jsonData['person_id'] = personId;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/addface', successBlock, failureBlock);
  }

  //创建一个Person，并将Person放置到group_ids指定的组当中
  //image:人脸图片
  //personId:指定创建的人脸
  //groupIds:加入的group列表
  static newPerson(
      File image,
      String personId,
      List groupIds,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['image'] = '${await TXQcloudFrSDK._imageBase64String(image)}';
    jsonData['person_id'] = personId;
    jsonData['group_ids'] = groupIds;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/newperson', successBlock, failureBlock);
  }

  //创建一个Person，并将Person放置到group_ids指定的组当中
  //image:人脸图片
  //personId:指定创建的人脸
  //groupIds:加入的group列表
  //personName:名字
  static newPersonWithName(
      File image,
      String personId,
      List groupIds,
      String personName,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['image'] = '${await TXQcloudFrSDK._imageBase64String(image)}';
    jsonData['person_id'] = personId;
    jsonData['group_ids'] = groupIds;
    jsonData['person_name'] = personName;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/newperson', successBlock, failureBlock);
  }


  //创建一个Person，并将Person放置到group_ids指定的组当中
  //image:人脸图片
  //personId:指定创建的人脸
  //groupIds:加入的group列表
  //personName:名字
  //personTag:备注
  static newPersonWithNameAndTag(
      File image,
      String personId,
      List groupIds,
      String personName,
      String personTag,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['image'] = '${await TXQcloudFrSDK._imageBase64String(image)}';
    jsonData['person_id'] = personId;
    jsonData['group_ids'] = groupIds;
    jsonData['person_name'] = personName;
    jsonData['tag'] = personTag;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/newperson', successBlock, failureBlock);
  }

  //人脸识别，对于一个待识别的人脸图片，在一个Group中识别出最相似的Top5 Person作为其身份返回，返回的Top5中按照相似度从大到小排列。
  //image:需要验证的人脸图片
  //groupId:人脸face组
  static faceIdentify(
      File image,
      String groupId,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['image'] = '${await TXQcloudFrSDK._imageBase64String(image)}';
    jsonData['group_id'] = groupId;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/faceidentify', successBlock, failureBlock);
  }

  //人脸验证，给定一个Face和一个Person，返回是否是同一个人的判断以及置信度。
  //imageA:需要验证的人脸图片
  //personId:验证的目标person
  static faceVerifyIn(
      File image,
      String personId,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['image'] = '${await TXQcloudFrSDK._imageBase64String(image)}';
    jsonData['person_id'] = personId;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/faceverify', successBlock, failureBlock);
  }

  //人脸对比， 计算两个Face的相似性以及五官相似度。
  //imageA:第一张人脸图片
  //imageB:第二张人脸图片
  static faceCompareIn(
      File imageA,
      File imageB,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['imageA'] = '${await TXQcloudFrSDK._imageBase64String(imageA)}';
    jsonData['imageB'] = '${await TXQcloudFrSDK._imageBase64String(imageB)}';

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/facecompare', successBlock, failureBlock);
  }

  //五官定位 image:人脸图片
  static faceShapeIn(
      File image,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['image'] = '${await TXQcloudFrSDK._imageBase64String(image)}';

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/faceshape', successBlock, failureBlock);
  }

  //人脸属性分析 检测给定图片(Image)中的所有人脸(Face)的位置和相应的面部属性。位置包括(x, y, w, h)，
  //面部属性包括性别(gender), 年龄(age), 表情(expression), 眼镜(glass)和姿态(pitch，roll，yaw).
  static detectFaceIn(
      File image,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['image'] = '${await TXQcloudFrSDK._imageBase64String(image)}';

    TXQcloudFrSDK._sendRequest(
        jsonData, '/api/detectface', successBlock, failureBlock);
  }

  //名片OCR识别 image：输入图片
  static namecardOcrFaceIn(
      File image,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['image'] = '${await TXQcloudFrSDK._imageBase64String(image)}';

    TXQcloudFrSDK._sendRequest(
        jsonData, '/ocrapi/namecardocr', successBlock, failureBlock);
  }

  //身份证OCR识别 image：输入图片 cardType  0-身份证正面  1-身份证背面
  static idcardOcrFaceIn(
      File image,
      int cardType,
      Function(Map response) successBlock,
      Function(dynamic) failureBlock) async {
    if (sdk == null) {
      sdk = TXQcloudFrSDK();
    }

    Map<String, dynamic> jsonData = new Map();
    jsonData['image'] = '${await TXQcloudFrSDK._imageBase64String(image)}';
    jsonData['card_type'] = cardType;

    TXQcloudFrSDK._sendRequest(
        jsonData, '/ocrapi/idcardocr', successBlock, failureBlock);
  }

  static _imageBase64String(File image) async {
    var result = await FlutterImageCompress.compressWithFile(
      image.absolute.path,
      quality: 90,
    );
    return base64Encode(result);
  }

  static _sendRequest(Map jsonData, String mothod,
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
