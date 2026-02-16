import 'package:flutter/material.dart';

class Doctorpatientspage extends StatelessWidget{
  final List<Map<String,dynamic>> patients;
  const Doctorpatientspage({super.key,required this.patients});
  @override
  Widget build(BuildContext context) {
   return Scaffold(appBar:
    AppBar(title: Text("My Patients")),
    body:patients.isEmpty
    ?Center(child: Text("No patients found"))
    : ListView.builder(itemCount: patients.length,
    itemBuilder: (context,index){
      final Patient = patients[index];
      return ListTile(
        title: Text(Patient['name']?? "No name"),
        subtitle: Text(Patient['email']?? "No Email"),
      );
    }
    
    ),
    
    );
  }


  
}