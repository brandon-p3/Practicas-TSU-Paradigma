import 'package:flutter/material.dart';
import 'package:crud_mongo/model/personModel.dart';
import 'package:crud_mongo/service/api.dart';
import 'package:crud_mongo/shemas/personForm.dart';
import 'package:crud_mongo/widgets/dialog.dart';

class FetchData extends StatefulWidget {
  const FetchData({super.key});

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  List<Person> allData = [];
  List<Person> filteredData = [];
  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await Api.checkBackEnd({});
      if (response['status'] == false) {
        viewSnackBar(
          context,
          "Error",
          response['message'] ?? "Sin mensaje",
          false,
        );
      }

      final data = await Api.getPerson();
      setState(() {
        allData = data;
        filteredData = data;
      });
    });
  }

  void filtrarResultados(String query) async {
    if (query.isEmpty) {
      setState(() {
        filteredData = allData;
      });
    } else {
      final data = {"name": query};
      final resultados = await Api.getPersonByName(data);
      setState(() {
        filteredData = resultados;
      });
    }
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: filtrarResultados,
            ),
          ),
        ),
      ),
      body:
          filteredData.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: filteredData.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final person = filteredData[index];

                  return SizedBox(
                    width: 10,
                    height: 20,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  person.name ?? "Sin nombre",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(person.lastname ?? "Sin apellido"),
                                const SizedBox(height: 5),
                                Text(person.phone ?? "Sin teléfono"),
                                Text(person.mail ?? "Sin correo"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => PersonFormScreen(
                                              person: person,
                                            ),
                                      ),
                                    );
                                    final data = await Api.getPerson();
                                    setState(() {
                                      allData = data;
                                      filteredData = data;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () async {
                                    final result = await Api.deletePersona(
                                      person.id,
                                    );
                                    viewAlert(
                                      context,
                                      result['status'] ? "Éxito" : "Error",
                                      result['message'],
                                      () async {
                                        final data = await Api.getPerson();
                                        setState(() {
                                          allData = data;
                                          filteredData = data;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PersonFormScreen()),
          );
        },
      ),
    );
  }
}
