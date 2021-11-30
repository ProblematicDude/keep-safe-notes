import 'package:notes/_aap_packages.dart';
import 'package:notes/_internal_packages.dart';

class ColorPicker extends StatefulWidget {
  const ColorPicker(
      {required this.pickerColor,
      required this.onColorChanged,
      required this.availableColors,
      this.layoutBuilder = defaultLayoutBuilder,
      this.itemBuilder = defaultItemBuilder,
      final Key? key})
      : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color> availableColors;
  final PickerLayoutBuilder layoutBuilder;
  final PickerItemBuilder itemBuilder;

  static Widget defaultLayoutBuilder(final BuildContext context,
      final List<Color> colors, final PickerItem child) {
    final orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      width: orientation == Orientation.portrait ? 300 : 300,
      height: orientation == Orientation.portrait ? 360 : 200,
      child: GridView.count(
        crossAxisCount: orientation == Orientation.portrait ? 4 : 6,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: colors.map((final color) => child(color)).toList(),
      ),
    );
  }

  static Widget defaultItemBuilder(
          final Color color, final void Function() changeColor,
          {required final bool isCurrentColor}) =>
      Container(
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: color,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.8),
              offset: const Offset(1, 2),
              blurRadius: 3,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: changeColor,
            borderRadius: BorderRadius.circular(50),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 210),
              opacity: isCurrentColor ? 1 : 0,
              child: Icon(
                Icons.done,
                color: useWhiteForeground(color) ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      );

  @override
  State<StatefulWidget> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late Color _currentColor;

  @override
  void initState() {
    _currentColor = widget.pickerColor;
    super.initState();
  }

  void changeColor(final Color color) {
    setState(() => _currentColor = color);
    widget.onColorChanged(color);
  }

  @override
  Widget build(final BuildContext context) => widget.layoutBuilder(
        context,
        widget.availableColors,
        (final color, [final _, final __]) => widget.itemBuilder(
          color,
          () => changeColor(color),
          isCurrentColor: _currentColor.value == color.value,
        ),
      );
}

bool useWhiteForeground(final Color color, {final double bias = 1}) {
  final v = sqrt(pow(color.red, 2) * 0.299 +
          pow(color.green, 2) * 0.587 +
          pow(color.blue, 2) * 0.114)
      .round();
  if (v < 130 * bias) {
    return true;
  } else {
    return false;
  }
}
