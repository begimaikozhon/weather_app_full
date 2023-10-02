import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_full/components/custom_icon_buttom.dart';
import 'package:weather_app_full/constants/api_const.dart';
import 'package:weather_app_full/constants/app_colors.dart';
import 'package:weather_app_full/constants/app_text.dart';
import 'package:weather_app_full/constants/app_text_styles.dart';
import 'package:weather_app_full/models/weather_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  WeatherModel? weatherModel;
  Future<Position> weatherLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      var a = await Geolocator.requestPermission();
      log(a.latitude.toString());
      log(a.longitude.toString());
      log(permission.name);
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<WeatherModel?> weatherName() async {
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

      return weatherModel;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.white,
        title: const Text(AppText.appBar, style: AppTextStyle.appBar),
      ),
      body: FutureBuilder(
        //бул виджет биз апиден данныйларды алганда ui жазылган виджетти оройбуз
        future: weatherName(),
        //FutureBuilder дин пропортиси future озуно моделдин атыны алат
        builder: (context, snapshot)
            // FutureBuilder дагы бир пропортиси builder озуно context менен snapshot алат
            // биз моделде тартылып алынган апилерди snapshot деп жазуу менен ui да каалаган
            // жерге чакырып алабыз
            {
          //ал эми snapshot тун {}чарчы кашасына жазган ui коддорду кочуруп жайгаштырып алабыз
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return const Center(
              child: Text('Интернет байланышында койгой бар'),
            );
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/weather.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomIconButton(
                          onPressed: () async {
                            weatherLocation();
                          },
                          icon: Icons.near_me,
                        ),
                        const CustomIconButton(
                          icon: Icons.location_city,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            '${temp(snapshot.data!.temp)}',
                            //бул жерде апиден келген данныйды () алып аны ылдыйда
                            //тузулгон функцияны алдына беребиз
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 96,
                            ),
                          ),
                          Image.network(
                            ApiConst.getIcon(snapshot.data!.icon, 4),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            snapshot.data!.description.replaceAll(' ', '\n'),
                            // Бул жерде текст виджетиндеги каалаган жерден кесип кийинки строкага откоро алабыз,
                            // мисалы бул жерде пробелден болот
                            // а.э. биринчи тырмакчага каалаган тамга же символду жазсак ошол жерден болот
                            style: const TextStyle(
                              fontSize: 60,
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(
                            snapshot.data!.city,
                            style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 60,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          } else {
            return const Center(
              child: Text('Белгисиз ката бар'),
            );
          }
        },
      ),
    );
  }

  // бул жерде 2 башка шарт жаздык
  int temp(double temp) {
    return (temp - 273.15).toInt();
  }
}
