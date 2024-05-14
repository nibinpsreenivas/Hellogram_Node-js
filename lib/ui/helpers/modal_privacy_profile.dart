import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hellogram/domain/blocs/user/user_bloc.dart';
import 'package:hellogram/ui/themes/hellotheme.dart';
import 'package:hellogram/ui/widgets/widgets.dart';

modalPrivacyProfile(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final userBloc = BlocProvider.of<UserBloc>(context);

  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadiusDirectional.vertical(top: Radius.circular(20.0))),
    backgroundColor: hellotheme.primary,
    barrierColor: Colors.black26,
    builder: (context) => Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
          color: hellotheme.primary,
          borderRadius:
              BorderRadiusDirectional.vertical(top: Radius.circular(20.0))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 5,
                  width: 38,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(50.0)),
                ),
              ),
              const SizedBox(height: 15.0),
              Center(
                  child: BlocBuilder<UserBloc, UserState>(
                      buildWhen: (previous, current) => previous != current,
                      builder: (_, state) => TextCustom(
                          text:
                              (state.user != null && state.user!.isPrivate == 0)
                                  ? 'Change account to Private'
                                  : 'Change account to Public',
                          fontWeight: FontWeight.w500))),
              const SizedBox(height: 5.0),
              const Divider(),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Icon(Icons.photo_outlined, size: 30, color: Colors.black),
                  SizedBox(width: 10.0),
                  Container(
                    width: MediaQuery.of(context).size.width - 71,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: TextCustom(
                          text:
                              'Everyone will be able to see your photos and videos',
                          fontSize: 15,
                          color: Colors.grey),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: const [
                  Icon(Icons.chat_bubble_outline_rounded,
                      size: 30, color: Colors.black),
                  SizedBox(width: 10.0),
                  TextCustom(
                    text: 'This won\'t change who can tag you \nmention',
                    fontSize: 15,
                    color: Colors.grey,
                    maxLines: 2,
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: const [
                  Icon(Icons.person_add_alt, size: 30, color: Colors.black),
                  SizedBox(width: 10.0),
                  TextCustom(
                    text:
                        'All pending requests must \nbe approved \n unless you delete them',
                    fontSize: 15,
                    color: Colors.grey,
                    maxLines: 2,
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              const Divider(),
              const SizedBox(height: 10.0),
              BlocBuilder<UserBloc, UserState>(
                buildWhen: (previous, current) => previous != current,
                builder: (_, state) => BtnFrave(
                  text: (state.user != null && state.user!.isPrivate == 0)
                      ? 'Switch to Private'
                      : 'Switch to Public',
                  width: size.width,
                  fontSize: 17,
                  backgroundColor: hellotheme.background,
                  onPressed: () {
                    Navigator.pop(context);
                    userBloc.add(OnChangeAccountToPrivacy());
                  },
                ),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
