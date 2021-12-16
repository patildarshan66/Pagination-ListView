import 'package:flutter/cupertino.dart';
import 'package:pagination_list_view/pagination/model/model_photo.dart';
import 'package:pagination_list_view/additionalFiles/global_functions_variables.dart';


class VmFavoritePhotos with ChangeNotifier {

  Map<String,ModelPhoto> favoritePhotos = {}; //for store favorite photos
  requestResponseState responseState = requestResponseState.dataReceived;  //for api store state

  bool checkIsFavorite(String id){
    bool isFavorite =false;
    if(favoritePhotos.containsKey(id)) isFavorite =true;
    return isFavorite;
  }

  Future<void> getFavoritePhotos(){

  }

  Future<void> addFavoritePhotos(ModelPhoto data)async{
    try{
      favoritePhotos.putIfAbsent(data.id, () => data);
      notifyListeners();
    }catch(e){
      rethrow;
    }
  }

  Future<void> removeFromFavoritePhotos(String id)async {
    try{
    favoritePhotos.remove(id);
    notifyListeners();
    }catch(e){
      rethrow;
    }
  }

}