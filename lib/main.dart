import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:tescopay/screens/shopping_bag.dart';
import './screens/home.dart';
import 'scoped_model/main_model.dart';
import './utils.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  final MainScopedModel _model = MainScopedModel();

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainScopedModel>(
      model: _model,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Utils.buildMaterialColor(const Color(0xffEE1C2E)),
            primaryColor: const Color(0xff00539F)),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => const Home(),
          '/shopping-bag': (BuildContext context) => ShoppingBag(model: _model,),
        },
      ),
    );
  }
}
