import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:pagination_list_view/pagination/model/model_photo.dart';
import 'package:pagination_list_view/additionalFiles/global_functions_variables.dart';


class VmFavoritePhotos with ChangeNotifier {

  Map<String,ModelPhoto> favoritePhotos = {}; //for store favorite photos
  requestResponseState responseState = requestResponseState.loading;  //for api store state

  bool checkIsFavorite(String id){
    bool isFavorite =false;
    if(favoritePhotos.containsKey(id)) isFavorite =true;
    return isFavorite;
  }

  Future<void> getFavoritePhotos(String userId)async{
    try{
      responseState = requestResponseState.loading;
      FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;
      var res = await fireStoreInstance.collection("users").doc(userId).collection('favoritePics').get();

    for (var element in res.docs) {
     final data =  ModelPhoto.fromJson(element.data());
     favoritePhotos.putIfAbsent(data.id, () => data);
    }
      responseState = requestResponseState.dataReceived;
      notifyListeners();
    }catch(e){
      responseState = requestResponseState.error;
      rethrow;
    }

  }

  Future<void> addFavoritePhotos(ModelPhoto data,String userId)async{
    try{
      responseState = requestResponseState.loading;
      FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;
      await fireStoreInstance.collection("users").doc(userId).collection('favoritePics').doc(data.id).set(data.toJson());
      favoritePhotos.putIfAbsent(data.id, () => data);
      responseState = requestResponseState.dataReceived;
      notifyListeners();
    }catch(e){
      responseState = requestResponseState.error;

      rethrow;
    }
  }

  Future<void> removeFromFavoritePhotos(String id,String userId)async {
    try{
     responseState = requestResponseState.loading;
      FirebaseFirestore fireStoreInstance = FirebaseFirestore.instance;
      await fireStoreInstance.collection("users").doc(userId).collection('favoritePics').doc(id).delete();
    favoritePhotos.remove(id);
    responseState = requestResponseState.dataReceived;
    notifyListeners();
    }catch(e){
       responseState = requestResponseState.error;
      rethrow;
    }
  }

}