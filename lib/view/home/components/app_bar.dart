import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../theme/custom_app_theme.dart';
import '../../../utils/constants.dart';

PreferredSize? customAppBar({
  required bool isSearching,
  required Function toggleSearch,
  required TextEditingController searchController,
  required Function(String) onSearchChanged,
}) {
  return PreferredSize(
    preferredSize: const Size.fromHeight(70),
    child: AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: isSearching
          ? TextField(
        controller: searchController,
        onChanged: onSearchChanged,
        style: AppThemes.homeAppBar,
        decoration: const InputDecoration(
          hintText: "Search...",
          border: InputBorder.none,
          hintStyle: TextStyle(color: AppConstantsColor.unSelectedTextColor, fontSize: 15),
        ),
      )
          : const Text("Discover", style: AppThemes.homeAppBar),
      actions: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: IconButton(
            icon: Icon(isSearching ? Icons.close : CupertinoIcons.search, color: AppConstantsColor.darkTextColor),
            onPressed: () => toggleSearch(),
          ),
        ),
        if (!isSearching)
          Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 4),
            child: IconButton(
              icon: const FaIcon(CupertinoIcons.bell, color: AppConstantsColor.darkTextColor, size: 25),
              onPressed: () {},
            ),
          ),
      ],
    ),
  );
}
