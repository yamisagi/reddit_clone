import 'package:flutter/material.dart';
import 'package:reddit_clone/theme/product_theme.dart';

class Constants {
  static const String logoPath = 'assets/images/logo.png';
  static const String backgroundPath = 'assets/images/background.png';
  static const String splashPath = 'assets/images/splashscreen.png';
  static const avatarDefault =
      'https://external-preview.redd.it/5kh5OreeLd85QsqYO1Xz_4XSLYwZntfjqou-8fyBFoE.png?auto=webp&s=dbdabd04c399ce9c761ff899f5d38656d1de87c2';

  static const String bannerDefault =
      'https://cdn.pixabay.com/photo/2017/03/25/17/55/colorful-2174045__480.png';

  static const createCommunity = 'Create Community';
  static const communityName = 'Community Name';
  static const communityNameHint = 'r/Cool_Community';
  static const noCommunities = 'No communities :/';

  static const IconData up = IconData(0xe800, fontFamily: 'RedditFont', fontPackage: null);
  static const IconData down = IconData(0xe801, fontFamily: 'RedditFont', fontPackage: null);

  static const awardsPath = 'assets/images/awards';

  static const awards = {
    'awesomeAns': '${Constants.awardsPath}/awesomeanswer.png',
    'gold': '${Constants.awardsPath}/gold.png',
    'platinum': '${Constants.awardsPath}/platinum.png',
    'helpful': '${Constants.awardsPath}/helpful.png',
    'plusone': '${Constants.awardsPath}/plusone.png',
    'rocket': '${Constants.awardsPath}/rocket.png',
    'thankyou': '${Constants.awardsPath}/thankyou.png',
    'til': '${Constants.awardsPath}/til.png',
  };
  // ----------------RADIUS&&STYLE----------------

  static final OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: ColorPallete.redColor,
      width: 2.0,
    ),
    borderRadius: BorderRadius.circular(30.0),
  );

  static final cardRadius = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(30.0),
  );

  static final buttonStyle = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20.0),
  );

  static const dottedBorder = Radius.circular(12);
  static final rectRadius = BorderRadius.circular(12);
  // ----------------PADDING && MARGIN----------------

  static const textFieldPadding = EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 0.0);
  static const regularPadding = EdgeInsets.all(16.0);
  static const smallPadding = EdgeInsets.all(8.0);
  static final postCardPadding =
      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0)
          .copyWith(right: 0.0);
  static const buttonPadding = EdgeInsets.symmetric(horizontal: 16.0);
}
