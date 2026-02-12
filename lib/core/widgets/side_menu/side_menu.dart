import 'package:asrdb/core/config/app_config.dart';
import 'package:asrdb/routing/route_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:asrdb/features/auth/presentation/auth_cubit.dart';
import 'package:asrdb/localization/localization.dart';
import 'package:asrdb/localization/keys.dart';
import 'dart:ui';
import 'package:package_info_plus/package_info_plus.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _glowController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _glowAnimation;
  String _version = '';

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));

    _fadeController.forward();
    _slideController.forward();
    _glowController.repeat(reverse: true);
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blueGrey[900]!,
              Colors.blueGrey[800]!,
              Colors.blueGrey[700]!,
            ],
            stops: [0.0, 0.3, 1.0],
          ),
        ),
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Stack(
              children: [
                Positioned(
                  top: -100,
                  right: -100,
                  child: AnimatedBuilder(
                    animation: _glowController,
                    builder: (context, child) {
                      return Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.cyan.withValues(
                              alpha: 0.1 + 0.05 * _glowAnimation.value),
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  bottom: -150,
                  left: -150,
                  child: AnimatedBuilder(
                    animation: _glowController,
                    builder: (context, child) {
                      return Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Colors.blue.withValues(
                              alpha: 0.08 + 0.02 * _glowAnimation.value),
                          shape: BoxShape.circle,
                        ),
                      );
                    },
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      height: 160,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: _glowController,
                                builder: (context, child) {
                                  return Container(
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40),
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.cyan.withValues(alpha: 0.3),
                                          Colors.blue.withValues(alpha: 0.3),
                                        ],
                                      ),
                                      border: Border.all(
                                        color:
                                            Colors.cyan.withValues(alpha: 0.5),
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.cyan
                                              .withValues(alpha: 0.3),
                                          blurRadius:
                                              20 + 10 * _glowAnimation.value,
                                          spreadRadius:
                                              5 + 3 * _glowAnimation.value,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.map_rounded,
                                      size: 36,
                                      color: Colors.white,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 12),
                              Text(
                                AppConfig.appName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 2),
                                      blurRadius: 4,
                                      color:
                                          Colors.black.withValues(alpha: 0.3),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                AppLocalizations.of(context)
                                    .translate(Keys.mobileApp),
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              _buildMenuItem(
                                context,
                                icon: Icons.home,
                                title: AppLocalizations.of(context)
                                    .translate(Keys.homeTitle),
                                subtitle: AppLocalizations.of(context)
                                    .translate(Keys.homeSubtitle),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteManager.homeRoute);
                                },
                              ),
                              const SizedBox(height: 10),
                              _buildMenuItem(
                                context,
                                icon: Icons.map_outlined,
                                title: AppLocalizations.of(context)
                                    .translate(Keys.viewMaps),
                                subtitle: AppLocalizations.of(context)
                                    .translate(Keys.viewMapsSubtitle),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteManager.downloadedMapList);
                                },
                              ),
                              const SizedBox(height: 10),
                              _buildMenuItem(
                                context,
                                icon: Icons.settings_outlined,
                                title: AppLocalizations.of(context)
                                    .translate(Keys.settings),
                                subtitle: AppLocalizations.of(context)
                                    .translate(Keys.settingsSubtitle),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteManager.settingsRoute);
                                },
                              ),
                              const SizedBox(height: 10),
                              _buildMenuItem(
                                context,
                                icon: Icons.person_outline,
                                title: AppLocalizations.of(context)
                                    .translate(Keys.profile),
                                subtitle: AppLocalizations.of(context)
                                    .translate(Keys.profileSubtitle),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteManager.profileRoute);
                                },
                              ),
                              const SizedBox(height: 10),
                              _buildMenuItem(
                                context,
                                icon: Icons.person_outline,
                                title: AppLocalizations.of(context).translate(Keys
                                    .fieldWorkOverview), //"Fieldwork Overview",
                                subtitle: AppLocalizations.of(context)
                                    .translate(Keys.fieldWorkOverviewSubtitle),
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, RouteManager.testRoute);
                                },
                              ),
                              //const SizedBox(height: 10),
                              // _buildMenuItem(
                              //   context,
                              // icon: Icons.help_outline,
                              // title: AppLocalizations.of(context).translate(Keys.helpSupport),
                              // subtitle: AppLocalizations.of(context).translate(Keys.helpSupportSubtitle),
                              // onTap: () {
                              ////   // Handle help tap
                              //},
                              // ),
                              const SizedBox(height: 10),
                              _buildMenuItem(
                                context,
                                icon: Icons.logout,
                                title: AppLocalizations.of(context)
                                    .translate(Keys.logout),
                                subtitle: AppLocalizations.of(context)
                                    .translate(Keys.logoutSubtitle),
                                onTap: () {
                                  _showLogoutDialog(context);
                                },
                              ),
                              const SizedBox(
                                  height:
                                      16), // Extra space at bottom for scroll
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Container(
                            height: 1,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withValues(alpha: 0.3),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _version.isNotEmpty
                                ? AppLocalizations.of(context)
                                  .translate(Keys.versionLabel)
                                  .replaceAll('{version}', _version)
                                : AppLocalizations.of(context)
                                  .translate(Keys.versionLabel)
                                  .replaceAll(
                                    '{version}', AppConfig.version),
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.cyan.withValues(alpha: 0.3),
                            Colors.blue.withValues(alpha: 0.3),
                          ],
                        ),
                        border: Border.all(
                          color: Colors.cyan.withValues(alpha: 0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withValues(alpha: 0.2),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              AppLocalizations.of(context).translate(Keys.logoutConfirmation)),
          content: Text(AppLocalizations.of(context)
              .translate(Keys.logoutConfirmationMessage)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).translate(Keys.cancel)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _performLogout(context);
              },
              child: Text(AppLocalizations.of(context).translate(Keys.logout)),
            ),
          ],
        );
      },
    );
  }

  void _performLogout(BuildContext context) async {
    // Close the drawer first
    Navigator.of(context).pop();

    try {
      // Perform logout
      await context.read<AuthCubit>().logout();

      // Navigate to login screen and clear the navigation stack
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteManager.loginRoute,
          (route) => false,
        );
      }
    } catch (error) {
      // Show error message if logout fails
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                '${AppLocalizations.of(context).translate(Keys.logoutError)}: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
