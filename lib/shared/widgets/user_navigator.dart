import 'package:flutter/material.dart';
import '../../config/routes.dart';

class UserNavigator extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final String? username;

  /// Constructor
  const UserNavigator({
    super.key,
    this.isLoggedIn = true,
    this.username,
  });

  @override
  Widget build(BuildContext context) {
    /// Get screen dimensions
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    /// Calculate responsive sizes
    final buttonPadding = screenWidth * 0.01; // 1% of screen width
    final fontSize = screenWidth * 0.012; // 1.2% of screen width
    final buttonSpacing = screenWidth * 0.005; // 0.5% of screen width
    /// AppBar
    return AppBar(
      backgroundColor: const Color(0xFFE5E5E5),
      automaticallyImplyLeading: false, // Removes back button
      toolbarHeight: screenHeight * 0.08, // 8% of screen height
      title: LayoutBuilder(
        builder: (context, constraints) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// Left side - Logo with fixed state
              /// Left side - Clickable Logo
              Padding(
                padding: const EdgeInsets.only(left: 0),
                child: Tooltip(
                  message: 'Click to go back to Dashboard',
                  child: Container(
                    constraints: const BoxConstraints(
                      minWidth: 250,
                      maxWidth: 250,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/users', (route) => false); // Clears stack
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        // Changes cursor to hand pointer on hover
                        child: Image.asset(
                          'assets/logo/Psystem_logo_no_icon-removebg.png',
                          height: 100,
                          fit: BoxFit.contain,

                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// Right side - Buttons
              Flexible(
                flex: 5,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // _buildButton(
                      //   // go to results screen
                      //   'View Results',
                      //       () => Navigator.pushNamed(context, Routes.results),
                      //   buttonPadding,
                      //   fontSize,
                      // ),
                      SizedBox(width: buttonSpacing),
                      _buildButton(
                        // go to results screen
                        'Logout',
                            () => Navigator.pushNamed(context, Routes.initial),
                        buttonPadding,
                        fontSize,
                      ),

                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Helper method to build buttons
  Widget _buildButton(
      String text,
      VoidCallback onPressed,
      double padding,
      double fontSize,
      ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCCA43B),
        foregroundColor: const Color(0xFFFFFFFF),
        padding: EdgeInsets.symmetric(
          horizontal: padding.clamp(8, 16),
          vertical: padding.clamp(4, 8),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize.clamp(12, 16), // Min 12, max 16
        ),
      ),
    );
  }

  // Required to implement PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
