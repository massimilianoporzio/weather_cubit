import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>(); //id del form
  String? _city; //valore passato alla pagina
  //con DISABLED l'errore NON lo vedo finché non ho fatto SUBMIT
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  void _submit() {
    //quando submit validazione ad ogni carattere
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState; //recupero lo stato della form
    if (form != null && form.validate()) {
      form.save(); //salvo i dati validi
      Navigator.pop(
          context, _city!.trim()); //passo come risultato il valore di city
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: autovalidateMode,
        child: Column(
          children: [
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TextFormField(
                autofocus: true,
                style: const TextStyle(fontSize: 18.0),
                decoration: const InputDecoration(
                    labelText: 'City name',
                    hintText: 'more than 2 characters',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder()),
                validator: (String? input) {
                  if (input == null || input.trim().length < 2) {
                    return 'City name must be at least 2 characters long';
                  }
                  return null;
                },
                onSaved: (String? input) {
                  _city = input;
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: _submit,
              child: const Text(
                'How\'s weather?',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
