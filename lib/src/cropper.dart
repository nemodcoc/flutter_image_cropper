// Copyright 2013, the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'options.dart';

///
/// A convenient class wraps all api functions of **ImageCropper** plugin
///
class ImageCropper {
  static const MethodChannel _channel =
      const MethodChannel('plugins.hunghd.vn/image_cropper');

  ///
  /// Launch cropper UI for an image.
  ///
  ///
  /// **parameters:**
  ///
  /// * sourcePath: the absolute path of an image file.
  ///
  /// * maxWidth: maximum cropped image width.
  ///
  /// * maxHeight: maximum cropped image height.
  ///
  /// * aspectRatio: controls the aspect ratio of crop bounds. If this values is set,
  /// the cropper is locked and user can't change the aspect ratio of crop bounds.
  ///
  /// * aspectRatioPresets: controls the list of aspect ratios in the crop menu view.
  /// In Android, you can set the initialized aspect ratio when starting the cropper
  /// by setting the value of [AndroidUiSettings.initAspectRatio]. Default is a list of
  /// [CropAspectRatioPreset.original], [CropAspectRatioPreset.square],
  /// [CropAspectRatioPreset.ratio3x2], [CropAspectRatioPreset.ratio4x3] and
  /// [CropAspectRatioPreset.ratio16x9].
  ///
  /// * cropStyle: controls the style of crop bounds, it can be rectangle or
  /// circle style (default is [CropStyle.rectangle]).
  ///
  /// * compressFormat: the format of result image, png or jpg (default is [ImageCompressFormat.jpg])
  ///
  /// * compressQuality: the value [0 - 100] to control the quality of image compression
  ///
  /// * androidUiSettings: controls UI customization on Android. See [AndroidUiSettings].
  ///
  /// * iosUiSettings: controls UI customization on iOS. See [IOSUiSettings].
  ///
  ///
  /// **return:**
  ///
  /// A result file of the cropped image.
  ///
  /// Note: The result file is saved in NSTemporaryDirectory on iOS and application Cache directory
  /// on Android, so it can be lost later, you are responsible for storing it somewhere
  /// permanent (if needed).
  ///

 static Future<CroppedImage> CropImageWithCoordinates({
  @required String sourcePath,
  double ratioX,
  double ratioY,
  int maxWidth,
  int maxHeight,
  String toolbarTitle, // for only Android
  Color toolbarColor, // for only Android
  bool circleShape: false,
}) async {
  assert(sourcePath != null);

  if (maxWidth != null && maxWidth < 0) {
    throw new ArgumentError.value(maxWidth, 'maxWidth cannot be negative');
  }

  if (maxHeight != null && maxHeight < 0) {
    throw new ArgumentError.value(maxHeight, 'maxHeight cannot be negative');
  }

  final String resultPath =
      await _channel.invokeMethod('cropImage', <String, dynamic>{
    'source_path': sourcePath,
    'max_width': maxWidth,
    'max_height': maxHeight,
    'ratio_x': ratioX,
    'ratio_y': ratioY,
    'toolbar_title': toolbarTitle,
    'toolbar_color': toolbarColor?.value,
    'circle_shape': circleShape
  });

  if (resultPath == null) return null;

  var splitResult = resultPath.split("|\\|");

  return CroppedImage(
    path: splitResult[0],
    x: double.parse(splitResult[1]),
    y: double.parse(splitResult[2]),
    width: double.parse(splitResult[3]),
    height: double.parse(splitResult[4]),
  );
}

class CroppedImage {
  final String path;
  final double x, y, width, height;

  CroppedImage({this.path, this.x, this.y, this.width, this.height});
}
