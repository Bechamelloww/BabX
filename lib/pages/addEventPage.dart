import 'package:date_field/date_field.dart';
import 'package:flutter/material.dart';

   class AddEventPage extends StatefulWidget {
     const AddEventPage({super.key});
   
     @override
     State<AddEventPage> createState() => _AddEventPageState();
   }
   
   class _AddEventPageState extends State<AddEventPage> {

     final _formKey = GlobalKey<FormState>();

     final confNameController = TextEditingController();
     final speakerNameController = TextEditingController();
     String selectedConfType = 'talk';
     DateTime selectedConfDate = DateTime.now();

     @override
  void dispose() {
    super.dispose();

    confNameController.dispose();
    speakerNameController.dispose();
  }

     @override
     Widget build(BuildContext context) {
       return Container(
         margin: EdgeInsets.all(20),
         child: Form(
           key: _formKey,
             child: Column(
               children: [
                 TextFormField(
                   decoration: const InputDecoration(
                     labelText: 'Conférence',
                     hintText: 'Entrer nom conf d\'Arouf',
                     border: OutlineInputBorder()
                   ),
                   validator: (value) {
                     if (value == null || value.isEmpty) {
                       return "Champ Incomplet";
                     }
                   },
                   controller: confNameController,
                 ),
                 const SizedBox(height: 20,),
                 DropdownButtonFormField(
                     items: [
                       DropdownMenuItem(value: 'talk',child: Text("Talk Show")),
                       DropdownMenuItem(value: 'demo',child: Text("Démonstration")),
                       DropdownMenuItem(value: 'partner',child: Text("Partenaire")),
                     ],
                     decoration: InputDecoration(
                       border: OutlineInputBorder()
                     ),
                     value: selectedConfType,
                     onChanged: (value) {
                       setState(() {
                         selectedConfType = value!;
                       });
                     }
                 ),
                 const SizedBox(height: 20,),
                 TextFormField(
                   decoration: const InputDecoration(
                       labelText: 'Speaker',
                       hintText: 'Entrer nom d\'Arouf',
                       border: OutlineInputBorder()
                   ),
                   validator: (value) {
                     if (value == null || value.isEmpty) {
                       return "Champ Incomplet";
                     }
                   },
                   controller: speakerNameController,
                 ),
                 const SizedBox(height: 20,),
                 DateTimeFormField(
                   decoration: const InputDecoration(
                     hintStyle: TextStyle(color: Colors.black45),
                     errorStyle: TextStyle(color: Colors.redAccent),
                     border: OutlineInputBorder(),
                     suffixIcon: Icon(Icons.event_note),
                     labelText: 'Choisir une date',
                   ),
                   mode: DateTimeFieldPickerMode.dateAndTime,
                   autovalidateMode: AutovalidateMode.always,
                   validator: (e) => (e?.day ?? 0) == 1 ? 'Please not the first day' : null,
                   onDateSelected: (DateTime value) {
                     setState(() {
                       selectedConfDate = value;
                     });
                   },
                 ),
                 const SizedBox(height: 20,),
                 SizedBox(
                   width: double.infinity,
                   height: 50,

                   child: ElevatedButton(
                       onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final confName = confNameController.text;
                            final speakerName = speakerNameController.text;
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Envoi en cours..."))
                            );
                            FocusScope.of(context).requestFocus(FocusNode());
                            
                            print("Ajout de la conf $confName par le speaker $speakerName");
                            print("Type de conférence : $selectedConfType");
                            print("Date de conférence : $selectedConfDate");
                          }
                         },
                       child: const Text("Envoyer")
                   ),
                 ),

               ],
             )
         ),
       );

     }
   }
   
