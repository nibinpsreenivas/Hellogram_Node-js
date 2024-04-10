part of 'widgets.dart';

class TextFieldFrave extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;

  const TextFieldFrave(
      {Key? key,
      required this.controller,
      this.hintText,
      this.isPassword = false,
      this.keyboardType = TextInputType.text,
      this.validator})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Color.fromARGB(150, 255, 255, 255),
      ),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.getFont('Roboto', fontSize: 18),
        cursorColor: Color.fromARGB(255, 128, 0, 126),
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 128, 0, 126))),
          hintText: hintText,
        ),
        validator: validator,
      ),
    );
  }
}
