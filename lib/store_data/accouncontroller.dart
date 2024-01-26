import 'package:get/get.dart';
import 'account_model.dart';
import 'db_helper.dart';


class AccountController extends GetxController {
  final RxList<Account> accountList = <Account>[].obs;


  Future<int> addAccount({Account? account}) {
    return DBHelper.insert(account);
  }

  Future<void> getAccounts() async {
    final List<Map<String, dynamic>> accounts = await DBHelper.query();
    accountList.assignAll(accounts.map((data) => Account.fromJson(data)).toList());
  }

  void deleteAccounts(Account account) async {
    await DBHelper.delete(account);
    getAccounts();
  }
  void deleteAllAccounts() async {
    await DBHelper.deleteAll();
    getAccounts();
  }

  void markAccountCompleted(int id) async {
    await DBHelper.update(id);
    getAccounts();
  }
}