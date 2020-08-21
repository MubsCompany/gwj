
import 'package:flutter/material.dart';
import 'package:template/pages/auth/forgot_code_page.dart';
import 'package:template/pages/auth/forgot_password_page.dart';
import 'package:template/pages/auth/login_page.dart';
import 'package:template/pages/auth/new_password_page.dart';
import 'package:template/pages/auth/profile_page.dart';
import 'package:template/pages/auth/register_page.dart';
import 'package:template/pages/auth/welcome_page.dart';
import 'package:template/pages/contact/add_contact_page.dart';
import 'package:template/pages/contact/contact_page.dart';
import 'package:template/pages/home/home_page.dart';
import 'package:template/pages/intro/intro_page.dart';
// import 'package:template/pages/mail/mail_page.dart';
import 'package:template/pages/news/add_news_page.dart';
import 'package:template/pages/news/news_page.dart';
import 'package:template/pages/note/add_note_page.dart';
import 'package:template/pages/note/note_page.dart';
import 'package:template/pages/reminder/reminder_page.dart';
import 'package:template/pages/schedule/add_schedule_page.dart';
import 'package:template/pages/schedule/schedule_page.dart';
import 'package:template/pages/splash/splash_page.dart';

final routes = <String, WidgetBuilder>{
  '/': (BuildContext context) => new SplashPage(),
  '/intro': (BuildContext context) => new IntroPage(),
  '/welcome': (BuildContext context) => new WelcomePage(),
  '/login': (BuildContext context) => new LoginPage(),
  '/forgot_password': (BuildContext context) => new ForgotPasswordPage(),
  '/forgot_code': (BuildContext context) => new ForgotCodePage(),
  '/new_password': (BuildContext context) => new NewPasswordPage(),
  '/register': (BuildContext context) => new RegisterPage(),
  '/home': (BuildContext context) => new HomePage(),
  '/profile': (BuildContext context) => new ProfilePage(),
  '/contact': (BuildContext context) => new ContactPage(),
  '/add_contact': (BuildContext context) => new AddContactPage(),
  '/reminder': (BuildContext context) => new ReminderPage(),
  '/news': (BuildContext context) => new NewsPage(),
  '/add_news': (BuildContext context) => new AddNewsPage(),
  '/note': (BuildContext context) => new NotePage(),
  '/add_note': (BuildContext context) => new AddNotePage(),
  '/schedule': (BuildContext context) => new SchedulePage(),
  '/add_schedule': (BuildContext context) => new AddSchedulePage(),
  // '/mail': (BuildContext context) => new MailPage(),
};
