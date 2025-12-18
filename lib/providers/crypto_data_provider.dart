


import 'package:flutter/material.dart';
import 'package:training_a/models/crypto_model/all_crypto_model.dart';

import '../network/api_provider.dart';
import '../network/response_model.dart';

class CryptoDataProvider extends ChangeNotifier{
  ApiProvider apiProvider = ApiProvider();
  late AllCryptoModel dataFuture;
  late ResponseModel state;
  dynamic response;

  Future<void> getTopMarketCapData()async{
    state = ResponseModel.loading("is loading");

    try{
      response = await apiProvider.getTopMarketCapData();
      if(response.statusCode ==200){
        dataFuture = AllCryptoModel.fromJson(response.data);
        state = ResponseModel.complete(dataFuture);
      }else{

        state = ResponseModel.error("something wrong...");}
      notifyListeners();
    }catch(e){
      state = ResponseModel.error("please check your internet connection...");
      notifyListeners();
    }

    }

  Future<void> getAllMarketCapData()async{
    state = ResponseModel.loading("is loading");

    try{
      response = await apiProvider.getAllMarketCapData();
      if(response.statusCode ==200){
        dataFuture = AllCryptoModel.fromJson(response.data);
        state = ResponseModel.complete(dataFuture);
      }else{

        state = ResponseModel.error("something wrong...");}
      notifyListeners();
    }catch(e){
      state = ResponseModel.error("please check your internet connection...");
      notifyListeners();
    }

    }

  Future<void> getTopGainersData()async{
    state = ResponseModel.loading("is loading");

    try{
      response = await apiProvider.getTopGainersData();
      if(response.statusCode ==200){
        dataFuture = AllCryptoModel.fromJson(response.data);
        state = ResponseModel.complete(dataFuture);
      }else{

        state = ResponseModel.error("something wrong...");}
      notifyListeners();
    }catch(e){
      state = ResponseModel.error("please check your internet connection...");
      notifyListeners();
    }

    }

  Future<void> getTopLooserData()async{
    state = ResponseModel.loading("is loading");

    try{
      response = await apiProvider.getTopLosserData();
      if(response.statusCode ==200){
        dataFuture = AllCryptoModel.fromJson(response.data);
        state = ResponseModel.complete(dataFuture);
      }else{

        state = ResponseModel.error("something wrong...");}
      notifyListeners();
    }catch(e){
      state = ResponseModel.error("please check your internet connection...");
      notifyListeners();
    }

    }

}