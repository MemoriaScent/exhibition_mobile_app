import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_app_01/components/vertical_slider_with_text.dart';
import 'package:test_app_01/controller/cartridge_controller.dart';
import 'package:test_app_01/controller/configuration_controller.dart';

class ControlScreen extends StatefulWidget {
  const ControlScreen({super.key});

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

class _ControlScreenState extends State<ControlScreen> {
  final conf = Get.find<ConfigurationController>();
  final management = Get.find<CartridgeController>();
  double opacity = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                management.length() == 0 ? "카트리지가 없습니다!" : "원하는 향을 조향해 보세요",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int index = 0; index < management.length(); index++)
                      Container(
                        margin: const EdgeInsets.all(20),
                        child: VerticalWithText(
                          label: management.index(index).drops.toString(),
                          child: SliderTheme(
                            data: SliderThemeData(
                              thumbColor: management.index(index).isBase ? colorScheme.primary : colorScheme.secondary,
                              activeTrackColor: management.index(index).isBase ? colorScheme.primary : colorScheme.secondary,
                              inactiveTrackColor: management.index(index).isBase ? colorScheme.surfaceVariant : colorScheme.surfaceVariant,
                            ),
                            child: Slider(
                              min: 0,
                              max: conf.configuration().maxDrops.toDouble(),
                              divisions: 20,
                              label: management.index(index).drops.toString(),
                              value: management.index(index).drops.toDouble(),
                              onChanged: (newValue) => setState(() {
                                final newData = management.index(index);
                                newData.drops = newValue.toInt();
                                management.updateCartridge(index, newData);
                          
                                final total = management.sumOfDrops();
                                final maxDrops = conf.configuration().maxDrops;
                          
                                if (total > maxDrops) {
                                  newData.drops = (newValue - (total - maxDrops)).toInt();
                                  management.updateCartridge(index, newData);
                                }
                              }),
                            ),
                          ),
                        ),
                      ),
                  ],
                )
              ),
              if (management.length() > 0)
              (management.sumOfDrops() == conf.configuration().maxDrops) ? 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.air),
                    label: const Text("발향 시작"),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("조향 시작"),
                  ),
                ],
              )
              :
              ElevatedButton(
                onPressed: () => setState(() {
                  for (int index = 0; index < management.length(); index++) {
                    final newData = management.index(index);
                    newData.drops = 0;
                    management.updateCartridge(index, newData);
                  }
                }),
                child: Text("${management.sumOfDrops()} / ${conf.configuration().maxDrops}"),
              ),
            ],
          ),
        ),
        if (conf.configuration().isLocked)
        Positioned(
          left: 0,
          top: 0,
          right: 0,
          bottom: 0,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: opacity,
            curve: Curves.easeOut,
            child: GestureDetector(
              onTapDown: (detail) {
                setState(() {
                  if (opacity > 0) {
                    opacity = 0;
                  } else {
                    opacity = 0.8;
                  }
                });
              },
              child: Container(
                color: Colors.black,
                child: const Center(
                  child: Text(
                    "LOCKED",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 50,
                    ),
                  ),
                ),
              ),
            )
          ),
        ),
      ],
    );
  }
}
