import 'package:flutter/material.dart';
import 'package:pagination_list_view/additionalFiles/constants.dart';
import 'package:pagination_list_view/authentication/vm/vm_authentication.dart';
import 'package:pagination_list_view/favoritePhotos/vm/vm_favorite_photos.dart';
import 'package:pagination_list_view/pagination/view/photo_item.dart';
import 'package:pagination_list_view/pagination/vm/vm_pagination.dart';
import 'package:provider/provider.dart';
import 'package:pagination_list_view/additionalFiles/global_functions_variables.dart';

class PaginationView extends StatefulWidget {
  const PaginationView({Key key}) : super(key: key);

  @override
  _PaginationViewState createState() => _PaginationViewState();
}

class _PaginationViewState extends State<PaginationView> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String _searchName;


// change loading state
  _changeLoadingState(bool status) {
    setState(
      () => _isLoading = status,
    );
  }

// calling photo list api
  _photoListApiCall({
    bool loadMore = false,
  }) async {
    try {
      if (loadMore) _changeLoadingState(true);
      Provider.of<VmPagination>(context, listen: false)
          .getPhotosList(loadMore: loadMore)
          .then(
        (_) {
          if (loadMore) _changeLoadingState(false);
        },
      );
    } catch (error) {
      if (loadMore) _changeLoadingState(false);
      showCustomSnackBar(context, error.toString(), color: Colors.red);
    }
  }

  // calling search photo list api
  _searchPhotoListApiCall({
    bool loadMore = false,
  }) async {
    try {
      if (loadMore) _changeLoadingState(true);
      Provider.of<VmPagination>(context, listen: false)
          .searchPhoto(_searchName,loadMore: loadMore)
          .then(
            (_) {
          if (loadMore) _changeLoadingState(false);
        },
      );
    } catch (error) {
      if (loadMore) _changeLoadingState(false);
      showCustomSnackBar(context, error.toString(), color: Colors.red);
    }
  }

  Future<void> _favoriteListApiCall() async {
    final userId =Provider.of<VmAuthentication>(context,listen: false).userId;
    await Provider.of<VmFavoritePhotos>(context,listen: false).getFavoritePhotos(userId);
  }

  @override
  void initState() {
    _favoriteListApiCall();
    _photoListApiCall(); //fetching data from server
    super.initState();

    // lazy loading (pagination scroll api calling)
    _scrollController.addListener(
      () {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          if(_searchName!=null && _searchName!=''){
            _searchPhotoListApiCall(loadMore: true); //called in case of search photo
          }else{
          _photoListApiCall(loadMore: true); //called in normal case
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<VmPagination>(
        builder: (_, vmPagination, child) {
          return vmPagination.responseState ==
                  requestResponseState.dataReceived //checking api call state
              ? RefreshIndicator(
                  onRefresh: () => _photoListApiCall(), //for pull refresh
                  child: Padding(
                    padding: const EdgeInsets.all(smallPadding),
                    child: Column(
                      children: [
                        _searchBar(),
                        vmPagination.photosList.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.only(top: 200),
                                child: Text('No photos available.'),
                              )
                            : _photoList(vmPagination),
                      ],
                    ),
                  ),
                )
              : getLoader(context); //initial loader
        },
      ),
    );
  }

  //search widget
 Widget _searchBar() {
    return TextField(
      onChanged: (value) {
        if (value != null && value != '') {
          _searchName =value;
          _searchPhotoListApiCall();
        } else {
          _searchName =null;
          _photoListApiCall();
        }
      },
      decoration: const InputDecoration(
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          hintText: 'Search photos here...'
      ),
    );
 }

 //photo list widget
 Widget _photoList(VmPagination vmPagination) {
    return Flexible(
      child: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount: vmPagination.photosList.length,
            itemBuilder: (ctx, i) {
              return ChangeNotifierProvider.value(
                value: vmPagination.photosList[i],
                child: const PhotoItem(),
              );
            },
            padding: const EdgeInsets.symmetric(
                vertical: 5),
          ),
          if (_isLoading) //for show pagination loader at bottom of screen
            Positioned(
              bottom: 0,
              left: 0,
              child: SizedBox(
                width:
                MediaQuery.of(context).size.width,
                child: getLoader(context,
                    color: Colors.purple),
              ),
            ),
        ],
      ),
    );
 }
}
