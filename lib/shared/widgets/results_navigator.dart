import 'package:flutter/material.dart';

class DisplayResultsNavigator extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final String? username;
  final VoidCallback? onBackPressed;

  const DisplayResultsNavigator({
    super.key,
    this.isLoggedIn = true,
    this.username,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AppBar(
      backgroundColor: const Color(0xFF242F40),
      automaticallyImplyLeading: false,
      toolbarHeight: screenHeight * 0.08,
      title: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Tooltip(
                  message: 'Click to go back',
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context), // Goes back to previous screen
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Color(0xFFE5E5E5),
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}