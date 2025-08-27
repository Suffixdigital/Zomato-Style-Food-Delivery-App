import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smart_flutter/model/CategoryItem.dart';
import 'package:smart_flutter/model/category.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final homeViewModelProvider = AsyncNotifierProvider<HomeViewModel, HomeState>(
  HomeViewModel.new,
);

final relatedItemsProvider = FutureProvider.family<List<CategoryItem>, String>((
  ref,
  categoryId,
) async {
  final data = await Supabase.instance.client
      .from('items')
      .select()
      .eq('category_id', categoryId);

  return (data as List).map((e) => CategoryItem.fromJson(e)).toList();
});

class HomeViewModel extends AsyncNotifier<HomeState> {
  @override
  Future<HomeState> build() async {
    final categories = await fetchCategories();
    if (categories.isEmpty) {
      return HomeState(categories: [], selectedIndex: 0, items: []);
    }

    final firstCategoryId = categories[0].id;
    final items = await fetchItemsByCategory(firstCategoryId);

    return HomeState(categories: categories, selectedIndex: 0, items: items);
  }

  Future<void> selectCategory(int index) async {
    final categoryId = state.value!.categories[index].id;

    // Set item loading state only
    state = AsyncValue.data(
      state.value!.copyWith(isLoadingItems: true, selectedIndex: index),
    );

    final items = await fetchItemsByCategory(categoryId);

    state = AsyncValue.data(
      state.value!.copyWith(isLoadingItems: false, items: items),
    );
  }

  Future<List<Category>> fetchCategories() async {
    final data = await Supabase.instance.client
        .from('category')
        .select()
        .order('display_order', ascending: true);

    return (data as List)
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CategoryItem>> fetchItemsByCategory(String categoryId) async {
    final data = await Supabase.instance.client
        .from('items')
        .select()
        .eq('category_id', categoryId);

    return (data as List).map((item) => CategoryItem.fromJson(item)).toList();
  }
}

class HomeState {
  final List<Category> categories;
  final int selectedIndex;
  final List<CategoryItem> items;
  final bool isLoadingItems;

  HomeState({
    required this.categories,
    required this.selectedIndex,
    required this.items,
    this.isLoadingItems = false,
  });

  HomeState copyWith({
    List<Category>? categories,
    int? selectedIndex,
    List<CategoryItem>? items,
    bool? isLoadingItems,
  }) {
    return HomeState(
      categories: categories ?? this.categories,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      items: items ?? this.items,
      isLoadingItems: isLoadingItems ?? this.isLoadingItems,
    );
  }
}
