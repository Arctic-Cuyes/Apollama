import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zona_hub/src/services/Auth/auth_service.dart';

class FilterProvider extends  ChangeNotifier {
  late String _userId;

  late SharedPreferences _prefs;
  
  List<String> _filters = [];
  List<String> get filters => _filters;

   checkFilterPrefs () async {
    _userId = AuthService().currentUser.uid;
    _prefs = await SharedPreferences.getInstance();
    _filters = _prefs.getStringList('filters_$_userId') ?? [];
    notifyListeners();
   }


  void toggleFilter(String filter) {
    if (_filters.contains(filter)) {
      _filters.remove(filter);
    } else {
      _filters.add(filter);
    }
    _prefs.setStringList('filters_$_userId', _filters);
    
    notifyListeners();
  }
}