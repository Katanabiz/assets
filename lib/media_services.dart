import 'package:photo_manager/photo_manager.dart';

class MediaServices {
  Future loadAlbums(RequestType requestType) async {
    var permissionStatus = await PhotoManager.requestPermissionExtend();
    List<AssetPathEntity> albumList = [];

    if (permissionStatus.isAuth) {
      albumList = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      
      );
    } else {
      PhotoManager.openSetting();
    }
    return albumList;
  }

  Future loadAssets(AssetPathEntity selectedAlbum) async {
    try {
      if (selectedAlbum == null) {
        print("selectedAlbum is null");
        return null;
      }
      List<AssetEntity> assetList = await selectedAlbum.getAssetListRange(
          start: 0, end: selectedAlbum.assetCount);
      return assetList;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
