import 'package:flutter/material.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:formvalidation/src/utils/utils.dart' as utils;

class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  final formKey = GlobalKey<FormState>();
  final productoProvider = new ProductosProvider();

  ProductoModel producto = new ProductoModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Producto"),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.photo_size_select_actual ), 
            onPressed: (){}
          ),
          IconButton(
            icon: Icon( Icons.camera_alt ), 
            onPressed: (){}
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
      onPressed: _submit
    );
  }

  void _submit(){    
    if(!formKey.currentState.validate()) return;

    formKey.currentState.save(); //dispara los save de los textfrom field


    print('todo ok');

    

    productoProvider.crearProducto(producto);

  }
}