
//Our Category Data Object
class Category {
  const Category({this.name});
  final String name;
}

// List of Category Data objects.
const List<Category> categories = <Category>[
  Category(
    name: 'My Links',
  ),
  Category(
      name: 'My Media'),
  Category(
      name: 'My Reactions'),
];
