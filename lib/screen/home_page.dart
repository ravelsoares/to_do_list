import 'package:flutter/material.dart';
import 'package:lista_de_tarefas2/models/todo_model.dart';
import 'package:lista_de_tarefas2/widgets/todo_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _todoControler = TextEditingController();
  List<Todo> todos = [];
  Todo? deletedTodo;
  int? deletedTodoPos;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _todoControler,
                        decoration: const InputDecoration(
                          hintText: 'Adicione uma tarefa',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                        onPressed: () {
                          String text = _todoControler.text.trim();
                          setState(() {
                            Todo todo =
                                Todo(title: text, dateTime: DateTime.now());
                            todos.add(todo);
                            _todoControler.clear();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(15),
                            primary: Colors.teal),
                        child: const Icon(Icons.add)),
                  ],
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(todo: todo, deleteTodo: deleteTodo)
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                        child: Text(
                            'Você possui ${todos.length} tarefas pendentes')),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: todos.isEmpty ? null : deleteAllTodos,
                      style: ElevatedButton.styleFrom(
                        primary: Colors.teal,
                        padding: const EdgeInsets.all(14),
                      ),
                      child: const Text('Limpar tudo'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void deleteTodo(Todo todo) {
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);
    setState(() {
      todos.remove(todo);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tarefa "${todo.title}" foi removida!'),
        action: SnackBarAction(
          label: 'Desfazer',
          textColor: Colors.teal,
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, todo);
            });
          },
        ),
      ),
    );
  }

  void deleteAllTodos() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir todas as tarefas?'),
        content: const Text('Você não poderá recuperar as tarefas'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                todos.clear();
              });
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
