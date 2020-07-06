import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:formvalidation/src/bloc/provider.dart';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/bloc/productos_bloc.dart';

class HomePage extends StatelessWidget {
   final productosStream = ProductosBloc();

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of(context); 
    productosStream.cargarProductos();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: _crearListado(),
      floatingActionButton: _crearBoton(context),
    );
  }

  Widget _crearListado(){
    

    return StreamBuilder(
      stream: productosStream.productosStream,
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        if(!snapshot.hasData) return Center( child: CircularProgressIndicator() );

        final productos = snapshot.data;
        return ListView.builder(
          itemCount: productos.length,
          itemBuilder: (context, i) => _crearItem(context, productos[i])
        );
      },
    );
  }

  Widget _crearItem(BuildContext context, ProductoModel producto){

    final card  = Card(
      child: Column(
        children: <Widget>[
          (producto.fotoUrl == null) ? Image( image: AssetImage('assets/no-image.png') )
                : FadeInImage( 
                    placeholder: AssetImage('assets/jar-loading.gif'),  
                    image: NetworkImage(producto.fotoUrl),
                    height: 300.0,
                    width: double.infinity,
                    fit:BoxFit.cover
                  )
          ,
          ListTile(
            title: Text( '${ producto.titulo } - ${ producto.valor }' ),
            subtitle: Text( '${ producto.id }'),
            onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
          )
        ],
      ),
    );


    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color:Colors.red
      ),
      onDismissed: ( direccion ){
        //TODO: Borrar producto
        productosStream.deleteProducto(producto.id);
      },
      child: card,
    );

    
  }

  Widget _crearBoton(BuildContext context){
    return FloatingActionButton(
      child: Icon( Icons.add ),
      backgroundColor: Colors.deepPurple,
      onPressed: () => Navigator.pushNamed(context, 'producto')
      
    );
  }
}