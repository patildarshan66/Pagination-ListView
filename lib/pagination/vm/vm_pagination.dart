import 'package:flutter/cupertino.dart';
import 'package:pagination_list_view/additionalFiles/global_functions_variables.dart';
import 'package:pagination_list_view/apiClient/api_services.dart';
import 'package:pagination_list_view/apiClient/urls.dart';
import 'package:pagination_list_view/pagination/model/model_photo.dart';

class VmPagination with ChangeNotifier {
  List<ModelPhoto> photosList = []; //store photo models
  requestResponseState responseState =
      requestResponseState.loading; //for api store state

  int _pageNo = 1; //for track pages

  Future<void> getPhotosList({
    bool loadMore = false,
  }) async {
    try {
      if (!loadMore) {
        responseState = requestResponseState.loading; //loading state
        _pageNo = 1;
      }

      final url = ApiUrls.PHOTO_LIST_API + "$_pageNo";
      final res = await getRequest(url);

      if (loadMore) {
        //for loading other pages except page 1
        photosList.addAll(modelPhotoFromJson(res));
      } else {
        //for loading page page 1
        photosList = modelPhotoFromJson(res);
      }
      _pageNo++; //increment page number
      responseState = requestResponseState.dataReceived; //data received state
      notifyListeners(); //notify to all listeners of VmPagination
    } catch (error) {
      responseState = requestResponseState.error; //error state
      rethrow;
    }
  }

  Future<void> searchPhoto(String name,{
    bool loadMore = false,
  }) async {
    try {
      if (!loadMore) {
        responseState = requestResponseState.loading; //loading state
        _pageNo = 1;
      }

      final url = ApiUrls.SEARCH_PHOTO_API+"page=$_pageNo&query=$name";
      final res = await getRequest(url);
      final photoData = res['results']; //extract search result


      if (loadMore) {
        //for loading other pages except page 1
        photosList.addAll(modelPhotoFromJson(photoData));  //convert res map to modelPhoto list
      } else {
        //for loading page page 1
        photosList = modelPhotoFromJson(photoData);
      }
      _pageNo++; //increment page number
      responseState = requestResponseState.dataReceived; //data received state
      notifyListeners(); //notify to all listeners of VmPagination
    } catch (e) {
      responseState = requestResponseState.error;
      rethrow;
    }
  }
}
