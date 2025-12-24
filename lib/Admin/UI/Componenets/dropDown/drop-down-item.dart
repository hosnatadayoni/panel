class DropdownItem {
  String text;
  bool isInteractive;
  String? value;
  bool isActive;
  bool isDisabled;
  bool? isHeader;
  bool? isActiveFirst;



  DropdownItem({
    required this.text,
    this.isInteractive = true,
    this.value,
    this.isActive = false,
    this.isDisabled = false,
    this.isHeader = false,
    this.isActiveFirst = false,
  });
}
