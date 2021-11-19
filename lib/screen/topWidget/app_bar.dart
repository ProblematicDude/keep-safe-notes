import 'package:notes/_external_packages.dart';
import 'package:notes/_internal_packages.dart';
import 'package:notes/util/_util.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  const MyAppBar({
    required this.title,
    this.appBarWidget = const AppBarAvatar(),
    final Key? key,
  }) : super(key: key);

  final Widget title;
  final Widget appBarWidget;

  @override
  _MyAppBarState createState() => _MyAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _MyAppBarState extends State<MyAppBar> {
  @override
  AppBar build(final BuildContext context) => AppBar(
        elevation: 0.6,
        title: widget.title,
        actions: [
          widget.appBarWidget,
        ],
      );
}

class AppBarAvatar extends StatefulWidget {
  const AppBarAvatar({this.onWidgetTap, final Key? key}) : super(key: key);

  final Function()? onWidgetTap;

  @override
  _AppBarAvatarState createState() => _AppBarAvatarState();
}

class _AppBarAvatarState extends State<AppBarAvatar> {
  late Widget _animatedChild;

  @override
  void initState() {
    _animatedChild =
        child(Key(Provider.of<LockChecker>(context, listen: false).gender));
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => GestureDetector(
        onDoubleTap: widget.onWidgetTap ?? defaultDoubleTap,
        child: Padding(
          padding: const EdgeInsets.only(right: 6, top: 4),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 22,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _animatedChild,
            ),
          ),
        ),
      );

  void defaultDoubleTap() {
    setState(() {
      if (Provider.of<LockChecker>(context, listen: false).gender == 'men') {
        Provider.of<LockChecker>(context, listen: false).gender = 'women';
      } else {
        Provider.of<LockChecker>(context, listen: false).gender = 'men';
      }
      _animatedChild =
          child(Key(Provider.of<LockChecker>(context, listen: false).gender));
    });
    Provider.of<LockChecker>(context, listen: false).addGenderToSf();
  }

  Widget child(final Key key) {
    return CircleAvatar(
      key: key,
      radius: 20,
      backgroundColor: Colors.white,
      backgroundImage: AssetImage(
        'assets/images/${Provider.of<LockChecker>(context, listen: false).gender}.png',
      ),
    );
  }
}
