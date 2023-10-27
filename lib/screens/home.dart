import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app_01/controller/configuration_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final conf = Get.find<ConfigurationController>();

  double y = 0;
  double x = 0;
  double opacity = 0;

  Timer? anim1;
  Timer? anim2;

  @override
  void initState() {
    super.initState();

    anim1 = Timer(const Duration(milliseconds: 100), () {
      setState(() {
        y = -0.3;
        x = -0.8;
      });
    });

    anim2 = Timer(const Duration(milliseconds: 3100), () {
      setState(() {
        opacity = 0.45;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    anim1?.cancel();
    anim2?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          left: x * MediaQuery.of(context).size.width,
          top: y * MediaQuery.of(context).size.height,
          duration: const Duration(seconds: 3),
          curve: Curves.easeInOut,
          child: Image.asset(
            "assets/intro.jpg",
            scale: 2.0,
          ),
        ),
        AnimatedOpacity(
          opacity: opacity,
          duration: const Duration(milliseconds: 500),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "SAMDI FUSSION",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          "공방을 담은 스마트 디퓨저, 여러분들의 공간에 소중한 추억을 디자인합니다",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        conf.updateScreenIndex(1);
                      },
                      child: const Text("시작하기"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
