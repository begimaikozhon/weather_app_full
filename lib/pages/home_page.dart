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
        future: fetchData(),
        //FutureBuilder дин пропортиси future озуно моделдин атыны алат
        builder: (context, snapshot)
            // FutureBuilder дагы бир пропортиси builder озуно context менен snapshot алат
            // биз моделде тартылып алынган апилерди snapshot деп жазуу менен ui да каалаган
            // жерге чакырып алабыз
            {
          //ал эми snapshot тун {}чарчы кашасына жазган ui коддорду кочуруп жайгаштырып алабыз
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIconButton(icon: Icons.near_me),
                    CustomIconButton(icon: Icons.location_city),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 12,
                    ),
                    Text(
                      '${snapshot.data!.temp! - 273.15}',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 96,
                      ),
                    ),
                    const Icon(
                      Icons.snowing,
                      color: AppColors.white,
                      size: 96,
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "You'll need and".replaceAll(' ', '\n'),
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
                const Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      'Bishkek',
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 60,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
