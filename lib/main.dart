import 'package:flutter/material.dart';
import 'package:sqlite_app/module/db_handler.dart';
import 'package:sqlite_app/module/employee_module.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController idCtrl, nameCtrl;
  late int? selectedId;

  @override
  void initState() {
    super.initState();
    idCtrl = TextEditingController();
    nameCtrl = TextEditingController();
    selectedId=null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQLite Scenario"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: buildScreenArea(),
        ),
      ),
    );
  }

  buildScreenArea() {
    return Column(
      children: [
        TextFormField(
          controller: idCtrl,
          decoration: decorateMyField("ID"),
        ),
        const SizedBox(
          height: 20,
        ),
        TextFormField(
          controller: nameCtrl,
          decoration: decorateMyField("Name"),
        ),
        MaterialButton(
          minWidth: double.infinity,
          height: 30,
          onPressed: saveUpdteData,
          color: Colors.amber,
          child: const Text("Save/Update"),
        ),
        const Divider(
          thickness: 5,
          color: Colors.blueGrey,
        ),
        Container(
          alignment: Alignment.center,
          child: FutureBuilder<List<Employee>>(
            future: DBHandler.instance.getEmployee(),
            builder: buildSQLiteData,
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    idCtrl.dispose();
    nameCtrl.dispose();
  }

  decorateMyField(String label) {
    return InputDecoration(
      label: Text(label),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
    );
  }

  void saveUpdteData() async {
    selectedId == null ? await DBHandler.instance.insertEmployee(
      Employee(id: int.parse(idCtrl.text), name: nameCtrl.text),
    ):await DBHandler.instance.updateEmp(Employee(id: selectedId!, name: nameCtrl.text));
    setState(() {
      idCtrl.clear();
      nameCtrl.clear();
      selectedId=null;
    });
  }

  Widget buildSQLiteData(
      BuildContext context, AsyncSnapshot<List<Employee>> snapshot) {
    if (!snapshot.hasData) {
      return const Text("Loading...");
    }
    return snapshot.data!.isEmpty
        ? const Text("No data")
        : Column(
            children: snapshot.data!.map((emp) {
              return Card(
                elevation: 18,
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blueAccent, size: 40,),
                  title: Text(emp.id.toString()),
                  subtitle: Text(emp.name),
                  onTap: (){
                    setState(() {
                      idCtrl.text=emp.id.toString();
                      nameCtrl.text=emp.name.toString();
                      selectedId=emp.id;
                    });
                  },
                  onLongPress:(){
                    setState(() {
                      DBHandler.instance.deleteEmp(emp.id);
                    });
                  } ,
                ),
              );
            }).toList(),
          );
  }
}
