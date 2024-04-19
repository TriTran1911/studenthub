import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.6),
      child: SpinKitDoubleBounce(
        size: 60.0,
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index.isEven
                  ? Color.fromARGB(255, 5, 143, 255)
                  : const Color.fromARGB(255, 129, 198, 255),
            ),
          );
        },
      ),
    );
  }
}
