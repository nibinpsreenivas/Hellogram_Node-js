part of 'widgets.dart';

class ShimmerFrave extends StatelessWidget {
  const ShimmerFrave({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.black,
      highlightColor: const Color.fromARGB(255, 128, 0, 126),
      child: Container(
        height: 280,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.grey[200]),
      ),
    );
  }
}
