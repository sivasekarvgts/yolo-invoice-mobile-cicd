import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yoloworks_invoice/app/styles/colors.dart';

import '../constants/images.dart';

class NetworkImageLoader extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;
  final bool isLoading;
  final useClientPlaceHolder;
  final BorderRadius borderRadius;

  const NetworkImageLoader({
    Key? key,
    required this.image,
    this.height,
    this.width,
    this.fit,
    this.useClientPlaceHolder = true,
    this.isLoading = false,
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isValidUrl = image.trim().isNotEmpty && Uri.tryParse(image)?.hasAbsolutePath == true;

    if (!isValidUrl) {
      debugPrint('⚠️ [NetworkImageLoader] Invalid image URL: "$image"');

      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          border: useClientPlaceHolder ? null : Border.all(color: AppColors.dividerGreyColor),
          color: useClientPlaceHolder ? null : AppColors.scaffoldBackground,
        ),
        child: Center(
          child: !useClientPlaceHolder
              ? SvgPicture.asset(Svgs.placeholder)
              : Image.asset(
            Images.emptyClientImage,
            fit: fit,
            width: width,
            height: height,
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: useClientPlaceHolder ? null : Border.all(color: AppColors.dividerGreyColor),
        color: useClientPlaceHolder ? null : AppColors.scaffoldBackground,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: CachedNetworkImage(
          imageUrl: image,
          fit: fit,
          height: height,
          width: width,
          cacheKey: image,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
            child: CircularProgressIndicator(
              value: downloadProgress.progress,
              color: Colors.white54,
              strokeWidth: 4.0,
            ),
          ),
          errorWidget: (context, url, error) {
            debugPrint('❌ [NetworkImageLoader] Failed to load image from "$url": $error');

            return Center(
              child: !useClientPlaceHolder
                  ? SvgPicture.asset(Svgs.placeholder)
                  : Image.asset(
                Images.emptyClientImage,
                fit: fit,
                width: width,
                height: height,
              ),
            );
          },
        ),
      ),
    );
  }
}

class BusinessIndividualImages {
  final List<String> business = [
    "https://yoloworks-bucket.s3.ap-south-1.amazonaws.com/dev/Avatar/Business/01.png",
    "https://yoloworks-bucket.s3.ap-south-1.amazonaws.com/dev/Avatar/Business/02.png",
    "https://yoloworks-bucket.s3.ap-south-1.amazonaws.com/dev/Avatar/Business/03.png",
    "https://yoloworks-bucket.s3.ap-south-1.amazonaws.com/dev/Avatar/Business/04.png",
    "https://yoloworks-bucket.s3.ap-south-1.amazonaws.com/dev/Avatar/Business/05.png",
    "https://yoloworks-bucket.s3.ap-south-1.amazonaws.com/dev/Avatar/Business/06.png",
    "https://yoloworks-bucket.s3.ap-south-1.amazonaws.com/dev/Avatar/Business/07.png"
  ];

  final List<String> individual = [
    "https://yoloworks-bucket.s3.ap-south-1.amazonaws.com/dev/Avatar/Individual/01.png",
    "https://yoloworks-bucket.s3.ap-south-1.amazonaws.com/dev/Avatar/Individual/02.png",
    "https://yoloworks-bucket.s3.ap-south-1.amazonaws.com/dev/Avatar/Individual/03.png",
    "https://yoloworks-bucket.s3.ap-south-1.amazonaws.com/dev/Avatar/Individual/04.png",
    "https://yoloworks-bucket.s3.ap-south-1.amazonaws.com/dev/Avatar/Individual/05.png",
    "https://yoloworks-bucket.s3.ap-south-1.amazonaws.com/dev/Avatar/Individual/06.png",
    "https://yoloworks-bucket.s3.ap-south-1.amazonaws.com/dev/Avatar/Individual/07.png"
  ];

  String get randomBusinessImage {
    final randomIndex = Random().nextInt(business.length);
    return business[randomIndex];
  }

  String get randomIndividualImage {
    final randomIndex = Random().nextInt(individual.length);
    return individual[randomIndex];
  }
}
