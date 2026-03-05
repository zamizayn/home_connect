import 'dart:async';

import 'package:chat_app/Utils/utils.dart';
import 'package:chat_app/constants/app_assets.dart';
import 'package:chat_app/constants/app_colors.dart';
import 'package:chat_app/screens/auth/forgot_password_screen.dart';
import 'package:chat_app/screens/auth/otp_screen.dart';
import 'package:chat_app/screens/home/main_scaffold.dart';
import 'package:chat_app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  final bool? forceShowLogin;
  const SplashScreen({super.key, this.forceShowLogin});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool showLogin = false;
  bool moveImageUp = false;
  double imageScale = 1.0; // initial full scale
  bool rememberMe = false;

  @override
  void initState() {
    super.initState();

    if (widget.forceShowLogin == true) {
      showLogin = true;
      moveImageUp = true;
      imageScale = 0.9;
    } else {
      // Trigger animation after 2 seconds
      Timer(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          moveImageUp = true;
          imageScale = 0.9;
        });
        // Show login card slightly after image moves up
        Timer(const Duration(milliseconds: 600), () {
          if (!mounted) return;
          setState(() {
            showLogin = true;
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          // App Logo
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            top: moveImageUp ? 40.h : screenHeight / 1.5 - 260.h,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: showLogin ? 0 : 1,
              duration: const Duration(milliseconds: 400),
              child: Center(
                child: Image.asset(
                  'icons/app_logo.png',
                  height: 60.h,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          // Background image with animated scale and position
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            top: moveImageUp ? 90.h : screenHeight / 1.5 - 220,
            left: 0,
            right: 0,
            child: Center(
              child: Hero(
                tag: 'actor_splash',
                child: AnimatedScale(
                  scale: imageScale,
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeInOut,
                  child: Image.asset(
                    AppImages.actorSplash,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          // Animated login card from bottom
          AnimatedPositioned(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            bottom: showLogin ? 0 : -screenHeight * 0.7,
            left: 0,
            right: 0,
            child: Hero(
              tag: 'auth_card',
              child: Material(
                type: MaterialType.transparency,
                child: AnimatedOpacity(
                  opacity: showLogin ? 1 : 0,
                  duration: const Duration(milliseconds: 600),
                  child: Container(
                    constraints: BoxConstraints(minHeight: screenHeight * 0.55),
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 32.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.r),
                        topRight: Radius.circular(40.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, -10),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CustomTextField(
                            labelText: 'Email ID',
                            hintText: 'Enter your email ID',
                            prefixIcon: Icons.email_outlined,
                          ),
                          SizedBox(height: 20.h),
                          const CustomTextField(
                            labelText: 'Password',
                            hintText: 'Enter your password',
                            prefixIcon: Icons.lock_outline,
                            obscureText: true,
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    height: 24.h,
                                    width: 24.w,
                                    child: Checkbox(
                                      value: rememberMe,
                                      activeColor: const Color(0xFFEF3935),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      onChanged: (value) {
                                        setState(() => rememberMe = value!);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Text(
                                    'Remember me',
                                    style: GoogleFonts.poppins(
                                      color: Colors.grey[600],
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: Size.zero,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Forgot Password?',
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xFFEF3935),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          Utils().button(
                            text: "Login",
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const OtpVerificationScreen(),
                                ),
                                (route) => false,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
