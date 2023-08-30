import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:weather_app_full/constants/api_const.dart';
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
        title: const Text('Home page'),
      ),
      body: weatherModel == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
              children: [
                Text(weatherModel!.id.toString()),
                Text(weatherModel!.main),
                Text(weatherModel!.description),
                Text(weatherModel!.icon),
                Text(weatherModel!.temp.toString()),
                Text(weatherModel!.country),
                Text(weatherModel!.city),
              ],
            )),
    );
  }
}
