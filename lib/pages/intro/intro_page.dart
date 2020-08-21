import 'package:flutter/material.dart';
import 'package:template/blocs/intro/intro_bloc.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';
class IntroPage extends StatelessWidget {
  IntroBloc introBloc = IntroBloc();
  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: [
        generateSlide(context,"Login", "guide_1.png"),
        generateSlide(context,"Sign Up", "guide_2.png"),
        generateSlide(context,"Sign In", "guide_3.png"),
        generateSlide(context,"Tampilan Utama", "guide_4.png"),
        generateSlide(context,"Kontak", "guide_5.png"),
        generateSlide(context,"Reminder", "guide_6.png"),
        generateSlide(context,"Reminder", "guide_7.png"),
        generateSlide(context,"Schedule", "guide_8.png"),
        generateSlide(context,"News", "guide_9.png"),
        generateSlide(context,"Note", "guide_10.png"),
        generateSlide(context,"Mail", "guide_11.png"),
      ],
      onDonePress: () => introBloc.doDone(context),
      sizeDot: 5.0,
      colorSkipBtn: Colors.black,
      colorDoneBtn: Colors.black,
    );
  }

  Slide generateSlide(BuildContext ctx,String title,String image){
    return Slide(
        title: title,
        styleTitle: TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold),
        pathImage: "assets/$image",
        widthImage: MediaQuery.of(ctx).size.width - 300,
        heightImage: MediaQuery.of(ctx).size.height - 300,
        backgroundColor: Colors.white,
      );
  }
}