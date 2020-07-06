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
    return Dismissible(
      key: UniqueKey(),
      background: Container(
        color:Colors.red
      ),
      onDismissed: ( direccion ){
        //TODO: Borrar producto
        productosStream.deleteProducto(producto.id);
      },
      child: ListTile(
        title: Text( '${ producto.titulo } - ${ producto.valor }' ),
        subtitle: Text( '${ producto.id }'),
        onTap: () => Navigator.pushNamed(context, 'producto', arguments: producto),
      ),
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