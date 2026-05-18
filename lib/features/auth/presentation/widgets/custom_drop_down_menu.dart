import 'package:flutter/material.dart';
import 'package:wasla/core/extensions/config_extension.dart';
import 'package:wasla/core/utils/app_colors.dart';
import 'package:wasla/features/auth/data/models/drop_down_menu_item.dart';

class CustomDropDownMenu extends StatefulWidget {
  const CustomDropDownMenu({
    super.key,
    required this.items,
    this.hint,
    this.onSelecte,
    this.initialSelection,
  });

  final List<DropDownItem> items;
  final String? hint;
  final String? initialSelection;
  final void Function(String?)? onSelecte;

  @override
  State<CustomDropDownMenu> createState() => _CustomDropDownMenuState();
}

class _CustomDropDownMenuState extends State<CustomDropDownMenu> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: _getLabelByValue(widget.initialSelection),
    );
  }

  @override
  void didUpdateWidget(CustomDropDownMenu oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSelection != widget.initialSelection ||
        oldWidget.items != widget.items) {
      _controller.text = _getLabelByValue(widget.initialSelection);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getLabelByValue(String? value) {
    return widget.items
            .where((item) => item.value == value)
            .firstOrNull
            ?.label ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      width: double.infinity,
      controller: _controller,
      onSelected: widget.onSelecte,
      hintText: widget.hint,
      initialSelection: widget.initialSelection,
      textStyle: Theme.of(context).textTheme.headlineMedium,
      inputDecorationTheme: _buildInputDecoration(context),
      menuStyle: _buildMenuStyle(context),
      dropdownMenuEntries: widget.items.map((item) {
        return _buildItems(item, context);
      }).toList(),
    );
  }

  DropdownMenuEntry<String> _buildItems(
    DropDownItem item,
    BuildContext context,
  ) {
    return DropdownMenuEntry<String>(
      value: item.value,
      label: item.label,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        foregroundColor: WidgetStateProperty.all(
          context.isDarkMode ? Colors.grey.shade400 : Colors.black,
        ),
        textStyle: WidgetStateProperty.all(
          Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }

  InputDecorationTheme _buildInputDecoration(BuildContext context) {
    return InputDecorationTheme(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      filled: true,
      fillColor: AppColors.gray.withOpacity(0.1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
    );
  }

  MenuStyle _buildMenuStyle(BuildContext context) {
    return MenuStyle(
      maximumSize: WidgetStateProperty.all(
        const Size(double.infinity, double.maxFinite),
      ),
      backgroundColor: WidgetStateProperty.all(
        context.isDarkMode ? Colors.grey.shade800 : Colors.white,
      ),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
