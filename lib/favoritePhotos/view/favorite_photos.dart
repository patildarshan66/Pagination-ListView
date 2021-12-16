import 'package:flutter/material.dart';
import 'package:pagination_list_view/additionalFiles/constants.dart';
import 'package:pagination_list_view/additionalFiles/global_functions_variables.dart';
import 'package:pagination_list_view/additionalFiles/routes.dart';
import 'package:pagination_list_view/favoritePhotos/vm/vm_favorite_photos.dart';
import 'package:pagination_list_view/pagination/view/photo_item.dart';
import 'package:provider/provider.dart';

class FavoritePhotos extends StatefulWidget {
  const FavoritePhotos({Key key}) : super(key: key);

  @override
  _FavoritePhotosState createState() => _FavoritePhotosState();
}

class _FavoritePhotosState extends State<FavoritePhotos> {
  Future<void> _apiCall() async {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<VmFavoritePhotos>(
        builder: (_, vmFav, child) {
          return vmFav.responseState ==
                  requestResponseState.dataReceived //checking api call state
              ? RefreshIndicator(
                  onRefresh: () => _apiCall(), //for pull refresh
                  child: Padding(
                    padding: const EdgeInsets.all(smallPadding),
                    child: vmFav.favoritePhotos.values.toList().isEmpty
                        ? _getNoFavWidget()
                        : _getFavList(vmFav)
                  ),
                )
              : getLoader(context); //initial loader
        },
      ),
    );
  }

  // no favorite photos widget
  Widget _getNoFavWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.favorite_border, size: 70, color: Colors.red),
          const Text(
            "You don't have any favorite picture",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: mediumHeightWidth),
          const Text(
            'You can add an item to favorite by clicking on heart \nthat shows over a picture (right bottom)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey
            ),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                MyRoutes.mainPage,
              );
            },
            label: const Text('Add Favorites'),
            icon: const Icon(Icons.add_photo_alternate),
          )
        ],
      ),
    );
  }

  //favorite photos list widget
  Widget _getFavList(VmFavoritePhotos vmFav) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: Stack(
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemCount: vmFav.favoritePhotos.values
                    .toList()
                    .length,
                itemBuilder: (ctx, i) {
                  return ChangeNotifierProvider.value(
                    value: vmFav.favoritePhotos.values.toList()[i],
                    child: const PhotoItem(),
                  );
                },
                padding: const EdgeInsets.symmetric(
                    vertical: 5),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
