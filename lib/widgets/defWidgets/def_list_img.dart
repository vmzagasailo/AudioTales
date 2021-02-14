import 'package:flutter/material.dart';
import 'package:audiotales/modelJSON/globalData.dart';

class DefImage extends StatelessWidget {
  final String url;
  final double demensions;
  final String ph;

  const DefImage(
      {Key key, this.url, this.demensions: imageSets, this.ph: imageUrlDefText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // RepaintBoundary needed because of gap between image and border
    // this is caused due to antialias algo
    return new RepaintBoundary(
      child: Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            color: desc_text,
            border: Border.all(
              color: desc_text,
              width: 5.0,
            ),
          ),
          child: (url != null)
              ? FadeInImage.assetNetwork(
                  placeholderScale: 2,
                  fit: BoxFit.cover,
                  height: demensions,
                  width: demensions,
                  placeholder: ph,
                  image: url,
                )
              : Image.asset(
                  ph,
                  fit: BoxFit.cover,
                  height: demensions,
                  width: demensions,
                )),
    );
  }
}
