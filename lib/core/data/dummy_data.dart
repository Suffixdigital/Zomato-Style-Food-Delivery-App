import '../../model/category.dart';
import '../../model/food_item.dart';

final categories = [
  Category(name: "Burger", icon: "🍔"),
  Category(name: "Taco", icon: "🌮"),
  Category(name: "Drink", icon: "🥤"),
  Category(name: "Pizza", icon: "🍕"),
  Category(name: "Burger", icon: "🍔"),
  Category(name: "Taco", icon: "🌮"),
  Category(name: "Drink", icon: "🥤"),
  Category(name: "Pizza", icon: "🍕"),
];

final foodItems = [
  FoodItem(
    id: "Ordinary Burgers",
    title: "Ordinary Burgers",
    imageUrl: 'assets/images/burger1.png',
    rating: 4.9,
    distance: 190,
    price: 17230,
  ),
  FoodItem(
    id: "Burger With Meat",
    title: "Burger With Meat",
    imageUrl: 'assets/images/burger2.png',
    rating: 4.9,
    distance: 190,
    price: 17230,
  ),
  FoodItem(
    id: "Cheesy Burger",
    title: "Cheesy Burger",
    imageUrl: 'assets/images/burger3.png',
    rating: 4.8,
    distance: 120,
    price: 15800,
  ),
  FoodItem(
    id: "Double Patty",
    title: "Double Patty",
    imageUrl: 'assets/images/burger4.png',
    rating: 4.7,
    distance: 210,
    price: 18250,
  ),
];
