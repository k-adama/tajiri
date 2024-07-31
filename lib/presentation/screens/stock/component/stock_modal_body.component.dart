import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajiri_pos_mobile/app/config/theme/style.theme.dart';
import 'package:tajiri_pos_mobile/domain/entities/food_data.entity.dart';
import 'package:tajiri_pos_mobile/presentation/controllers/stock/stock.controller.dart';
import 'package:tajiri_pos_mobile/presentation/ui/custom_network_image.ui.dart';
import 'package:tajiri_pos_mobile/presentation/ui/widgets/text_fields/outline_bordered.text_field.dart';
import 'package:tajiri_sdk/src/models/inventory.model.dart';

class StockModalBodyComponent extends StatefulWidget {
  Inventory food;
  StockModalBodyComponent({super.key, required this.food});

  @override
  State<StockModalBodyComponent> createState() =>
      _StockModalBodyComponentState();
}

class _StockModalBodyComponentState extends State<StockModalBodyComponent> {
  Widget build(BuildContext context) {
    int ajustementStock = 0;
    void increment() {
      setState(() {
        ajustementStock++;
      });
    }

    void decrement() {
      setState(() {
        ajustementStock--;
      });
    }

    final StockController stockController = Get.find();
    @override
    int quantity = widget.food.quantity ?? 0;
    int addValue = quantity + ajustementStock;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 120,
          child: Column(
            children: [
              CustomNetworkImageUi(
                url: widget.food.imageUrl,
                height: 70,
                width: 70,
                radius: 3,
              ),
              Text(
                widget.food.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          height: 130,
          child: Column(
            children: [
              const Text(
                "Faire un ajustement",
                style: TextStyle(fontSize: 20),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        decrement();
                      })
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Style.secondaryColor,
                              style: BorderStyle.solid,
                              width: 1)),
                      child: const Center(
                        child: Text(
                          "-",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Style.secondaryColor),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 130,
                    height: 90,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                            color: Style.secondaryColor,
                            style: BorderStyle.solid,
                            width: 1)),
                    child: OutlinedBorderTextField(
                      onTap: () {},
                      label: "",
                      obscure: true,
                      hint: addValue.toString(),
                      hintColor: Style.black,
                      onChanged: (change) {
                        debugPrint(change);
                        setState(() {
                          addValue = int.parse(change);
                          ajustementStock = 0;
                        });
                      },
                      haveBorder: false,
                      descriptionText: "",
                      isInterNormal: false,
                      isCenterText: true,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () => {
                      setState(() {
                        increment();
                      })
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Style.secondaryColor,
                            style: BorderStyle.solid,
                            width: 1,
                          )),
                      child: const Center(
                        child: Text(
                          "+",
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Style.secondaryColor),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Dernier point",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  "${stockController.lastMove(widget.food.histories)}",
                )
                // TODO : STOCK model
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: double.infinity,
            height: 80,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Style.black, style: BorderStyle.solid, width: 1)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Dernier Approvisionnement",
                  style: TextStyle(
                      color: Style.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                 Text(
                  "${stockController.lastSupply(widget.food.histories)}",
                  style: const TextStyle(
                      color: Style.secondaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
