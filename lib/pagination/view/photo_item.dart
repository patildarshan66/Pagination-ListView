import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pagination_list_view/additionalFiles/constants.dart';
import 'package:pagination_list_view/additionalFiles/global_functions_variables.dart';
import 'package:pagination_list_view/additionalFiles/routes.dart';
import 'package:pagination_list_view/additionalFiles/screen_arguments.dart';
import 'package:pagination_list_view/favoritePhotos/vm/vm_favorite_photos.dart';
import 'package:pagination_list_view/pagination/model/model_photo.dart';
import 'package:provider/provider.dart';

class PhotoItem extends StatelessWidget {
  const PhotoItem({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ModelPhoto>(context);
    final vmFav =Provider.of<VmFavoritePhotos>(context);
    bool isFav = vmFav.checkIsFavorite(data.id);
    return InkWell(
      onTap: (){
        Navigator.pushNamed(
          context,
          MyRoutes.photoDetailsView,
          arguments: ScreenArguments(modelPhoto: data)
        );
      },
      child: Container(
        padding: const EdgeInsets.all(smallPadding),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.deepOrangeAccent,
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: data.user.profileImage.small,
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
                      data.user.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(data.user.location ?? 'Unknown',
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
                    imageUrl: data.urls.regular,
                    placeholder: (context, url) => getLoader(context),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  right: 10,
                  bottom: 10,
                  child:
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8)),
                        alignment: Alignment.center,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if(isFav){
                              vmFav.removeFromFavoritePhotos(data.id);
                            }else{
                              vmFav.addFavoritePhotos(data);
                            }
                          },
                          icon:  Icon(
                            isFav ?Icons.favorite:  Icons.favorite_border,
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
    );
  }
}
