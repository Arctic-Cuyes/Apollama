import 'package:flutter/material.dart';
import 'package:zona_hub/src/components/post/post.dart';
import 'package:zona_hub/src/views/map/marker_examples.dart';

class _MarkerBottomModal extends StatelessWidget {
  final CustomMarker marker;
  const _MarkerBottomModal({super.key, required this.marker});

  @override
  Widget build(BuildContext context) {
    var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return DraggableScrollableSheet(
      expand: false,
      maxChildSize: isPortrait ? 0.55 : 0.8,
      initialChildSize: 0.35,
      minChildSize: 0.2,
      builder: (context, scrollController) => SingleChildScrollView(
        controller: scrollController,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 8, right: 8),
          child: PostComponent(
            userID: "JlZxZOy4WNkTU8jni4FN", //Para probar
            userphoto:
                "https://i.pinimg.com/564x/3b/cd/8c/3bcd8c2ae805e65d52cd07c1c396dc8a.jpg",
            username: marker.title,
            imageUrl:
                "https://www.hogarmania.com/archivos/201910/mascota-perdida-XxXx80.jpg",
            postText: marker.address,
          ),
        ),
      ),
    );
  }
}

void showMarkerBottomSheet(BuildContext context, CustomMarker cMarker) {
  showModalBottomSheet<void>(
      context: context,
      useRootNavigator: false,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      barrierColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(
            top: 18,
          ),
          child: _MarkerBottomModal(
            marker: cMarker,
          ),
        );
      });
}
