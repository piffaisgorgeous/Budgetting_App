import 'package:app_budget/item.dart';
import 'package:app_budget/repository.dart';
import 'package:app_budget/category.dart';

class categoryService {
  Repository _repository;

  categoryService() {
    _repository = Repository();
  }

  saveCategory(Category category) async {
    return await _repository.insertData('categories', category.categoryMap());
  }

  saveItem(Item item) async {
    return await _repository.insertData('items', item.itemMap());
  }

  readCategory() async {
    return await _repository.readData('categories');
  }

  readItem() async {
    return await _repository.readData('items');
  }

  readCategoryById(catId) async {
    return await _repository.readDataById('categories', catId);
  }

  readItemById(itemId) async {
    return await _repository.readItemById('items', itemId);
  }

  updateCategory(Category category) async {
    return await _repository.updateData('categories', category.categoryMap());
  }

  updateItem(Item item) async {
    return await _repository.updateData('items', item.itemMap());
  }

  deleteCategory(catId) async {
    return await _repository.deleteData('categories', catId);
  }

  deleteItem(itemId) async {
    return await _repository.deleteData('items', itemId);
  }

  readItemWithId(itemId) async {
    return await _repository.readDataWithId('items', itemId);
  }

  updateAmountCategory(Category category) async {
    return await _repository.updateAmountInCategory(
        'categories', category.categoryMap());
  }

  readItemWithDate() async {
    return await _repository.readDataWithDate('items');
  }

  deleteItemHome(catId) async {
    return await _repository.deleteData('items', catId);
  }
}
