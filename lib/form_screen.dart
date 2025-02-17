import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'device_info_screen.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _commentaireController = TextEditingController();
  String? _selectedGender;
  String? _selectedWilaya;
  final _formKey = GlobalKey<FormState>();

  // Liste de  Wilayas
  final List<String> wilayas = [
    "Adrar", "Chlef", "Laghouat", "Oum El Bouaghi", "Batna", "Béjaïa", "Biskra", "Béchar", "Blida", "Bouira",
    "Tamanrasset", "Tébessa", "Tlemcen", "Tiaret", "Tizi Ouzou", "Alger", "Djelfa", "Jijel", "Sétif", "Saïda",
    "Skikda", "Sidi Bel Abbès", "Annaba", "Guelma", "Constantine", "Médéa", "Mostaganem", "Msila", "Mascara", "Ouargla",
    "Oran", "El Bayadh", "Illizi", "Bordj Bou Arréridj", "Boumerdès", "El Tarf", "Tindouf", "Tissemsilt", "El Oued",
    "Khenchela", "Souk Ahras", "Tipaza", "Mila", "Aïn Defla", "Naâma", "Aïn Témouchent", "Ghardaïa", "Relizane",
    "Timimoun", "Bordj Badji Mokhtar", "Ouled Djellal", "Béni Abbès", "In Salah", "In Guezzam", "Touggourt", "Djanet",
    "El M’Ghair", "El Menia"
  ];

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedGender != null && _selectedWilaya != null) {
      Map<String, String> userData = {
        "nom": _nomController.text,
        "email": _emailController.text,
        "numero": _numeroController.text,
        "date_naissance": _dateController.text,
        "sexe": _selectedGender!,
        "wilaya": _selectedWilaya!,
        "commentaire": _commentaireController.text,
      };

      try {
        var response = await http.post(
          Uri.parse("http://172.20.10.2:8081/user_data/save.php"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(userData),
        );

        if (response.statusCode == 200) {
          var responseData = jsonDecode(response.body);
          if (responseData["status"] == "success") {
            // afficher msg success
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Inscription réussie")),
            );

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeviceInfoScreen()),
            );

            _formKey.currentState!.reset();
            setState(() {
              _selectedGender = null;
              _selectedWilaya = null;
              _commentaireController.clear();
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Erreur d'inscription: ${responseData["message"]}")),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Erreur serveur (${response.statusCode})")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Erreur de connexion: $e")),
        );
      }
    }
  }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.greenAccent,
            title: Center(
              child: Text(
                'Formulaire',
                style: TextStyle(color: Colors.white, fontSize: 25.0),
              ),
            ),
          ),
          body: Center(
           child: SingleChildScrollView(
            child: Padding(
             padding: const EdgeInsets.all(16.0), 
              child: Form(
              key: _formKey,
                child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start, 
                   mainAxisAlignment: MainAxisAlignment.center,
          children: [
          // champ text
          Padding(
            padding: const EdgeInsets.all(8.0),
              child: TextFormField(
               keyboardType: TextInputType.text,
               controller: _nomController,
               validator: (value) {
               if (value == null || value.isEmpty) {
               return 'Format nom valide';
          }
               return null;
          },
          decoration: InputDecoration(
            labelText: 'Nom et prénom', border: OutlineInputBorder()),
          ),
          ),

          SizedBox(height: 15.0),

          // champ Email
          Padding(
            padding: const EdgeInsets.all(8.0),
             child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              validator: (value) {
          if (value == null || value.isEmpty) {
             return 'Format email valide';
          }
             return null;
          },
          decoration: InputDecoration(
            labelText: 'Email', border: OutlineInputBorder()),
          ),
          ),

          SizedBox(height: 15.0),

          // champ tlp
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              keyboardType: TextInputType.phone,
              controller: _numeroController,
              validator: (value) {
              if (value == null || value.isEmpty) {
              return 'Format numéro valide';
              }
              return null;
          },
                decoration: InputDecoration(
                labelText: 'Numéro de téléphone', border: OutlineInputBorder()),
          ),
          ),

          SizedBox(height: 15.0),

          // selection de Date
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
            controller: _dateController,
            readOnly: true,
            validator: (value) {
            if (value == null || value.isEmpty) {
            return 'Veuillez sélectionner une date';
            }
            return null;
          },
              decoration: InputDecoration(
               labelText: 'Date de naissance',
               border: OutlineInputBorder(),
               suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () => _selectDate(context),
          ),
          ),

          SizedBox(height: 15.0),

          // case a coucher pour Sexe
          Padding(
            padding: const EdgeInsets.all(8.0),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                'Sexe',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
          Row(
          children: [
          Expanded(
              child: RadioListTile<String>(
              title: Text('Féminin', style: TextStyle(fontSize: 11),),
              value: 'Féminin',
              groupValue: _selectedGender,
                onChanged: (value) {
                setState(() {
                _selectedGender = value;
              });
            },
           ),
         ),
          Expanded(
          child: RadioListTile<String>(
          title: Text('Masculin',  style: TextStyle(fontSize: 10),),
          value: 'Masculin',
          groupValue: _selectedGender,
          onChanged: (value) {
          setState(() {
          _selectedGender = value;
                });
               },
              ),
             ),
            ],
           ),
          ],
          ),
          ),

      SizedBox(height: 15.0),

      //  selecteur deroulant pour Wilayas
      Padding(
          padding: const EdgeInsets.all(8.0),
             child: DropdownButtonFormField<String>(
             value: _selectedWilaya,
             hint: Text('Sélectionner une Wilaya'),
             decoration: InputDecoration(
             labelText: 'Wilaya',
             border: OutlineInputBorder(),
          ),
          items: wilayas.map((wilaya) {
          return DropdownMenuItem(
            value: wilaya,
            child: Text(wilaya),
            );
            }).toList(),
          onChanged: (value) {
          setState(() {
          _selectedWilaya = value;
          });
          },
          validator: (value) {
            if (value == null) {
            return 'Veuillez sélectionner une Wilaya';
          }
          return null;
         },
        ),
      ),

      SizedBox(height: 15.0),

      // champs d'commentaire (zone de texte)
      Padding(
         padding: const EdgeInsets.all(8.0),
         child: TextFormField(
          controller: _commentaireController,
          maxLines: 2, 
          validator: (value) {
          if (value == null || value.isEmpty) {
          return 'Veuillez entrer un commentaire';
            }
          return null;
            },
          decoration: InputDecoration(
          labelText: 'Commentaire',
          border: OutlineInputBorder(),
          ),
        ),
      ),

    SizedBox(height: 30.0),

    // Button "Suivant"
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.greenAccent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    onPressed: _submitForm ,
                    child: Text('Suivant', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),),
        )
    );
  }
}
