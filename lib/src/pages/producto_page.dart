import 'dart:io';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/bloc/productos_bloc.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;
import 'package:image_picker/image_picker.dart';

class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final productosStream = ProductosBloc();

  ProductoModel producto = new ProductoModel();
  bool _guardando = false;
  File foto;

  @override
  Widget build(BuildContext context) {

    final ProductoModel prodData = ModalRoute.of(context).settings.arguments;
    if(prodData != null){
      producto = prodData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Producto"),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.photo_size_select_actual ), 
            onPressed: _seleccionarFoto
          ),
          IconButton(
            icon: Icon( Icons.camera_alt ), 
            onPressed: _tomarFoto
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: _crearFormulario()
        ),
      ),
    );
  }

  Widget _crearFormulario(){
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          _mostrarFoto(),
          _crearNombre(),
          _crearPrecio(),
          _crearDisponible(),
          _crearBoton()
        ],  
      ),
    );
  }

  Widget _crearNombre(){
    return TextFormField(
      initialValue: producto.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto',
      ),
      onSaved: ( value) => producto.titulo = value ,
      validator: ( value ){
        if( value.length < 3 ){
          return 'Ingrese el nombre del producto';
        }else
          return null;
      },
    );
  }

  Widget _crearPrecio(){
    return TextFormField(
      initialValue: producto.valor.toString(),
      keyboardType: TextInputType.numberWithOptions( decimal: true ),
      decoration: InputDecoration(
        labelText: 'Precio',
      ),
      onSaved: (value) => producto.valor = double.parse(value) ,
      validator: ( value ){
        if( utils.isNumeric( value ) ){
          return null;
        }else{
          return 'Sólo números';
        }
      },
    );
  }

  Widget _crearDisponible(){
    return SwitchListTile(
      value: producto.disponible, 
      title: Text('Disponible'),
      activeColor: Colors.deepPurple,
      onChanged: ( value ) => setState((){
        producto.disponible = value;
      })
    );
  }

  Widget _crearBoton(){
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color:Colors.deepPurple,
      textColor: Colors.white,
      label: Text('Guardar'),
      icon: Icon( Icons.save ) ,
      onPressed: (_guardando) ? null : _submit
    );
  }

  void _submit(){    
    if(!formKey.currentState.validate()) return;

    formKey.currentState.save(); //dispara los save de los textfrom field
    
    setState(() { _guardando = true; });
    
    if(producto.id == null){
      productosStream.crearProducto(producto);
    }else{
      productosStream.editarProducto(producto);
    }

    mostarSnackBar('Registro guardado');
    Navigator.pop( context );
  }

  void mostarSnackBar(String mensaje){
    final snackBar = SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500)
    );
    scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget _mostrarFoto(){
    if(producto.fotoUrl != null){
      //TODO: tengo que hacer esto
      return Container();
    }else{

      return Image(
        image: AssetImage(foto?.path ?? 'assets/no-image.png'),
        height: 300.0,
        fit: BoxFit.cover,
      );

    }
  }

  _seleccionarFoto(){
    _procesarImagen(ImageSource.gallery);
  }
  _tomarFoto(){
    _procesarImagen(ImageSource.camera);
  }

  _procesarImagen(ImageSource source) async{
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: source
    );

    if(pickedFile != null){
      foto = File( pickedFile.path );
      setState(() { });
    }
  }
  
}