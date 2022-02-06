import 'dart:convert';

import 'package:lista_de_tarefas2/models/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TodoRespository {

  late SharedPreferences sharedPreferences;

  Future<List<Todo>> getTodoList() async {
    sharedPreferences = await SharedPreferences.getInstance();
    final String jsonString = sharedPreferences.getString('list_todo') ?? '[]';
    final List jsonDecoded = json.decode(jsonString) as List;
    return jsonDecoded.map((e) => Todo.fromJson(e)).toList();
  }

  void saveTodoList(List<Todo> todos) {
    final jsonString = json.encode(todos);
    sharedPreferences.setString('list_todo', jsonString);
  }
}
