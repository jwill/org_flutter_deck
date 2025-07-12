import 'package:flutter/material.dart';

class StatefulImage extends StatefulWidget {
  final ImageProvider image;
  final double? width;
  final double? height;

  const StatefulImage({
    super.key,
    required this.image,
    this.width,
    this.height,
  });

  @override
  State<StatefulImage> createState() => _StatefulImageState();
}

class _StatefulImageState extends State<StatefulImage> {
  late ImageStream _imageStream;
  ImageInfo? _imageInfo;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imageStream = widget.image.resolve(createLocalImageConfiguration(context));
    _imageStream.addListener(ImageStreamListener(_updateImage));
  }

  @override
  void didUpdateWidget(StatefulImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _imageStream.removeListener(ImageStreamListener(_updateImage));
      _imageStream = widget.image.resolve(createLocalImageConfiguration(context));
      _imageStream.addListener(ImageStreamListener(_updateImage));
    }
  }

  void _updateImage(ImageInfo imageInfo, bool synchronousCall) {
    setState(() {
      _imageInfo = imageInfo;
    });
  }

  @override
  void dispose() {
    _imageStream.removeListener(ImageStreamListener(_updateImage));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_imageInfo != null) {
      return SizedBox(
        width: widget.width,
        height: widget.height,
        child: Image(image: widget.image),
      );
    } else {
      return const CircularProgressIndicator();
    }
  }
}
