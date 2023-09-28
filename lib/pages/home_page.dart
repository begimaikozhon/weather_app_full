import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_app_full/components/custom_icon_buttom.dart';
import 'package:weather_app_full/constants/api_const.dart';
import 'package:weather_app_full/constants/app_colors.dart';
import 'package:weather_app_full/constants/app_text.dart';
import 'package:weather_app_full/constants/app_text_styles.dart';
import 'package:weather_app_full/models/weather_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherModel? weatherModel;
  Future<WeatherModel?> fetchData() async {
    final dio = Dio();
    final response = await dio.get(ApiConst.api);
    if (response.statusCode == 200 || response.statusCode == 201) {
      weatherModel = WeatherModel(
        id: response.data['weather'][0]['id'],
        main: response.data['weather'][0]['main'],
        description: response.data['weather'][0]['description'],
        icon: response.data['weather'][0]['icon'],
        temp: response.data['main']['temp'],
        country: response.data['sys']['country'],
        city: response.data['name'],
      );
      setState(() {});
      return weatherModel;
    }
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: const Text(AppText.appBar, style: AppTextStyle.appBar),
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/beg.JPG'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomIconButton(icon: Icons.near_me),
                CustomIconButton(icon: Icons.location_city),
              ],
            )
          ],
        ),
      ),
    );
  }
}
