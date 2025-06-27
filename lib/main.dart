import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wether_app/bloc/whether_bloc_bloc.dart';
import 'package:wether_app/presentation/home/home.dart';
import 'package:wether_app/repository/repo.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather App',
      home: BlocProvider(
        create: (_) => WeatherBloc(WeatherRepository()),
        child: WeatherPage(),
      ),
    );
  }
}
