enum ItemCategory{
  CHAIR,
  TABLE,
  CABINET,
  CURTAIN,
  BED,
  DRAWER,
  BABY_FURNITURE,
  OTHER
}

//match each enum with name
extension ItemCategoryExtension on ItemCategory{
  String get name{
    switch(this){
      case ItemCategory.CHAIR:
        return 'Chair';
      case ItemCategory.TABLE:
        return 'Table';
      case ItemCategory.CABINET:
        return 'Cabinet';
      case ItemCategory.CURTAIN:
        return 'Curtain';
      case ItemCategory.BED:
        return 'Bed';
      case ItemCategory.DRAWER:
        return 'Drawer';
      case ItemCategory.BABY_FURNITURE:
        return 'Baby Furniture';
      case ItemCategory.OTHER:
        return 'Other';
      default:
        return 'Unknown';
    }
  }
}