 // ),
    // ),
    // child: Column(
    // crossAxisAlignment: CrossAxisAlignment.start,
    // children: <Widget>[
    // TextFormField(
    // keyboardType: TextInputType.text,
    // decoration: const InputDecoration(
    // labelText: 'Nom',
    // ),
    // validator: (String? value) {
    // if (value == null || value.isEmpty) {
    // return 'Veuillez saisir votre nom';
    // }
    // return null;
    // },
    // onSaved: (String? value) {
    // controler = value!;
    // },
    // ),
    // TextFormField(
    // keyboardType: TextInputType.text,
    // decoration: const InputDecoration(
    // labelText: 'Prénom',
    // ),
    // validator: (String? value) {
    // if (value == null || value.isEmpty) {
    // return 'Veuillez saisir votre prénom';
    // }
    // return null;
    // },
    // onSaved: (String? value) {
    // _prenom = value!;
    // },
    // ),

    // TextFormField(
    // keyboardType: TextInputType.text,
    // decoration: const InputDecoration(
    // labelText: 'Adrresse',
    // ),
    // validator: (String? value) {
    // if (value == null || value.isEmpty) {
    // return 'Veuillez saisir votre adresse';
    // }
    // return null;
    // },
    // onSaved: (String? value) {
    // _adressePostal = value!;
    // },
    // ),
    // TextFormField(
    // keyboardType: TextInputType.emailAddress,
    // decoration: const InputDecoration(
    // labelText: 'Adresse email',
    // ),
    // validator: (String? value) {
    // if (value == null || value.isEmpty) {
    // return 'Veuillez saisir une adresse e-mail valide';
    // }
    // if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
    //     .hasMatch(value)) {
    // return 'Veuillez saisir une adresse e-mail valide';
    // }
    // return null;
    // },
    // onSaved: (String? value) {
    // _email = value!;
    // },
    // ),
    // TextFormField(
    // obscureText: true,
    // decoration: const InputDecoration(
    // labelText: 'Mot de passe',
    // ),
    // validator: (String? value) {
    // if (value == null || value.isEmpty) {
    // return 'Veuillez saisir un mot de passe valide';
    // }
    // // if (!RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$&*~]).{8,}$')
    // //     .hasMatch(value)) {
    // //   return 'Veuillez saisir un mot de passe valide';
    // // }
    // return null;
    // },
    // onSaved: (String? value) {
    // _password = value!;
    // },
    // ),
    // TextFormField(
    // obscureText: true,
    // decoration: const InputDecoration(
    // labelText: 'Confirmer le mot de passe',
    // ),
    // validator: (String? value) {
    // if (value == null || value.isEmpty) {
    // return 'Veuillez confirmer votre mot de passe';
    // }

    // // if (value != _password) {
    // //   return 'Les mots de passe ne correspondent pas';
    // // }
    // // return null;
    // },
    // onSaved: (String? value) {
    // _confirmPassword = value!;
    // },
    // ),