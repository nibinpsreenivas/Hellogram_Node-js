import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellogram/domain/blocs/user/user_bloc.dart';
import 'package:hellogram/web_page/ui/widgets/widgets.dart';

class AnimatedToggle extends StatefulWidget {
  final List<String> values;
  final ValueChanged<bool> onToggleCalbBack;

  const AnimatedToggle(
      {Key? key, required this.values, required this.onToggleCalbBack})
      : super(key: key);

  @override
  _AnimatedToggleState createState() => _AnimatedToggleState();
}

class _AnimatedToggleState extends State<AnimatedToggle> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      height: width * .14,
      child: Stack(
        children: [
          GestureDetector(
            onTap: () => widget.onToggleCalbBack(true),
            child: Container(
              width: width,
              height: width * .14,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 128, 0, 126),
                  
                      borderRadius: BorderRadius.circular(width * .3),
                      ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(
                      widget.values.length,
                      (i) => Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: width * .1),
                            child: TextCustom(
                              text: widget.values[i],
                              fontSize: width * .05,
                              color: Colors.white,
                            ),
                          ))),
            ),
          ),
          BlocBuilder<UserBloc, UserState>(
            buildWhen: (previous, current) => previous != current,
            builder: (_, state) => AnimatedAlign(
              alignment:
                  state.isPhotos ? Alignment.centerLeft : Alignment.centerRight,
              duration: const Duration(milliseconds: 350),
              curve: Curves.ease,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Container(
                  alignment: Alignment.center,
                  width: width * .45,
                  height: width * .12,
                  decoration: ShapeDecoration(
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(width * .1)),
                  ),
                  child: TextCustom(
                    text: state.isPhotos ? widget.values[0] : widget.values[1],
                    fontSize: width * .05,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

