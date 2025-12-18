
import 'package:flutter/material.dart';
import 'package:training_a/network/response_model.dart';

import '../models/crypto_model/all_crypto_model.dart';
import '../network/api_provider.dart';

class MarketViewProvider extends ChangeNotifier{
  ApiProvider apiProvider = ApiProvider();
  late AllCryptoModel dataFuture;
  late ResponseModel state;
  dynamic response;

  Future<void> getCryptoData()async{
    state = ResponseModel.loading("is loading....");
    notifyListeners();
    try{
      response = await apiProvider.getAllMarketCapData();
      if(response.statusCode == 200){
        dataFuture = AllCryptoModel.fromJson(response.data);
        state = ResponseModel.complete(dataFuture);
      }else{
        state = ResponseModel.error("something wrong...");
      }
      notifyListeners();
  }catch(e){
      state = ResponseModel.error("please check your internet connection");
      notifyListeners();
    }
    }
}