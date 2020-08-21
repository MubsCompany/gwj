import 'package:flutter/widgets.dart';
import 'package:template/utils/bloc_provider.dart';
import 'package:template/utils/session.dart';

class IntroBloc extends Object implements BlocBase {
  @override
  void dispose() {
    
  }
  doDone(BuildContext context) async{
    if(await Session.getHasBeenShownIntroViews()){
      Navigator.of(context).pop();
    }else{
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      await Session.setHasBeenShownIntroViews(true);
    }
  }
}