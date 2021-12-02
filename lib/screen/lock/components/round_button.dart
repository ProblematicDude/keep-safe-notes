//30-11-2021 01:11 PM
import 'package:notes/_internal_packages.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    required this.title,
    required this.onTap,
    final Key? key,
    this.pad = true,
  }) : super(key: key);
  final Widget title;
  final bool pad;

  final VoidCallback? onTap;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          constraints: BoxConstraints.tight(const Size(80, 80)),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            // color: Colors.redAccent,
            color: Theme.of(context).canvasColor,
          ),
          alignment: Alignment.center,
          child: title,
        ),
      ),
    );
  }
}
