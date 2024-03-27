import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class TableCardShimmer extends StatelessWidget {
  const TableCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
