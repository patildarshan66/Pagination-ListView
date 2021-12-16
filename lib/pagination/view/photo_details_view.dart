import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pagination_list_view/additionalFiles/constants.dart';
import 'package:pagination_list_view/additionalFiles/global_functions_variables.dart';
import 'package:pagination_list_view/authentication/vm/vm_authentication.dart';
import 'package:pagination_list_view/favoritePhotos/vm/vm_favorite_photos.dart';
import 'package:pagination_list_view/pagination/model/model_photo.dart';
import 'package:provider/provider.dart';

class PhotoDetailsView extends StatelessWidget {
  final ModelPhoto photoData;
  const PhotoDetailsView(this.photoData, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vmFav = Provider.of<VmFavoritePhotos>(context);
    bool isFav = vmFav.checkIsFavorite(photoData.id);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(smallPadding),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.deepOrangeAccent,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: photoData.user.profileImage.small,
                          placeholder: (context, url) => getLoader(context),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          photoData.user.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(photoData.user.location ?? 'Unknown',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.42,
                      child: CachedNetworkImage(
                        imageUrl: photoData.urls.regular,
                        placeholder: (context, url) => getLoader(context),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            final userId =  Provider.of<VmAuthentication>(context,listen: false).userId;
                            if (isFav) {
                              vmFav.removeFromFavoritePhotos(photoData.id,userId);
                            } else {
                              vmFav.addFavoritePhotos(photoData,userId);
                            }
                          },
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: Colors.pink,
                            size: 35,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(smallPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text(
                  'Likes',
                  style: TextStyle(color: Colors.grey),
                ),
                Text(
                  numberFormate(photoData.likes),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: smallHeightWidth),
                Row(
                  children: [
                    Text("${photoData.user.name} ",
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    _getDescription(),
                  ],
                ),
                const SizedBox(height: smallHeightWidth),
                _getDateWidget(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _getDescription() {
    Widget widget;
    if (photoData.description != null) {
      widget = Text(photoData.description);
    }
    else if (photoData.altDescription != null) {
      widget = Text(photoData.altDescription);
    }else{
      widget =const Text('');
    }

    return widget;
  }

  Widget _getDateWidget() {
    return Row(
      children:  [
       const Icon(Icons.calendar_today,color: Colors.grey,size: 18,),
        Text("  Published on "+ formateDate(photoData.createdAt),style:const TextStyle(color: Colors.grey,fontWeight: FontWeight.w600),)
      ],
    );
  }
}
