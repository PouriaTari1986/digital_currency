

import 'package:flutter/material.dart';
import 'package:training_a/models/crypto_model/user_model.dart';
import 'package:training_a/network/api_provider.dart';
import 'package:training_a/network/response_model.dart';

class RegisterProvider extends ChangeNotifier{
ApiProvider apiProvider = ApiProvider();

late dynamic dataFuture;
ResponseModel? registerStatus;
dynamic error;
dynamic response;
Future<void> callRegisterApi(dynamic name,email,password)async{
  registerStatus = ResponseModel.loading('is loading ....');
  notifyListeners();
  try{
    response = await apiProvider.callRegisterApi(name, email, password);
    if(response.statusCode == 201){
      dataFuture = UserModel.fromJson(response.data);
      registerStatus = ResponseModel.complete(dataFuture);
      notifyListeners();
    }else if(response.statusCode == 200) {
      dataFuture = UserModel.fromJson(response.data);
      registerStatus = ResponseModel.error(dataFuture);

    notifyListeners();
    }
  }catch(e){
    error = e.toString();
    registerStatus = ResponseModel.complete(e);
    notifyListeners();

  }
}
}