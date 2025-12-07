import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projek_flutter/pages/auth/login_page.dart';
import 'package:projek_flutter/pages/intro/onboarding_page.dart';

void main() {
  runApp(const MyApp());
}

const MaterialColor kPrimaryGreen = MaterialColor(0xFF1BAE76, <int, Color>{
  50: Color(0xFFE4F7EF),
  100: Color(0xFFBBEBDA),
  200: Color(0xFF8DE0C2),
  300: Color(0xFF5FD5AA),
  400: Color(0xFF3BCC97),
  500: Color(0xFF1BAE76),
  600: Color(0xFF18A66E),
  700: Color(0xFF149C63),
  800: Color(0xFF109259),
  900: Color(0xFF098047),
});

const Color kScaffoldBackground = Color(0xFFEFEFEF);
const Color kGreyColor = Color(0xFF808080);
const Color kBlackColor = Color(0xFF000000);
const Color kWhiteColor = Color(0xFFFFFFFF);

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Green Cafe',

      theme: ThemeData(
        primarySwatch: kPrimaryGreen,
        primaryColor: kPrimaryGreen,
        scaffoldBackgroundColor: kScaffoldBackground,
        cardColor: kWhiteColor,
        textTheme: TextTheme(
          headlineLarge: GoogleFonts.sora(
            fontWeight: FontWeight.bold,
            color: kBlackColor,
          ),
          headlineMedium: GoogleFonts.sora(
            fontWeight: FontWeight.w600,
            color: kBlackColor,
          ),
          titleLarge: GoogleFonts.sora(
            fontWeight: FontWeight.bold,
            color: kBlackColor,
          ),
          titleMedium: GoogleFonts.sora(
            fontWeight: FontWeight.w600,
            color: kBlackColor,
            fontSize: 16,
          ),
          titleSmall: GoogleFonts.sora(
            fontWeight: FontWeight.w600,
            color: kBlackColor,
            fontSize: 14,
          ),

          bodyLarge: GoogleFonts.poppins(color: kBlackColor, fontSize: 16),
          bodyMedium: GoogleFonts.poppins(color: kBlackColor, fontSize: 14),
          bodySmall: GoogleFonts.poppins(color: kGreyColor, fontSize: 12),
        ),

        appBarTheme: AppBarTheme(
          backgroundColor: kPrimaryGreen,
          elevation: 0,
          titleTextStyle: GoogleFonts.sora(
            color: kWhiteColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: const IconThemeData(color: kWhiteColor),
        ),

        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: kWhiteColor,
          selectedItemColor: kPrimaryGreen,
          unselectedItemColor: kGreyColor,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          elevation: 2,
        ),

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: kPrimaryGreen,
        ),

        cardTheme: CardThemeData(
          color: kWhiteColor,
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
      home: const OnboardingPage(),
    );
  }
}
