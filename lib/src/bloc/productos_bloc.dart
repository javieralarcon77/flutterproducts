import 'dart:async';
import 'package:formvalidation/src/models/producto_model.dart';
import 'package:formvalidation/src/providers/productos_provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ProductosBloc{
  static ProductosBloc _instancia;

  ProductosBloc._();

  factory ProductosBloc(){
    if(_instancia == null)
      _instancia = ProductosBloc._();
    return _instancia;
  }


  final productoProvider = new ProductosProvider();

  final _productosController = BehaviorSubject<List<ProductoModel>>();

  Stream <List<ProductoModel>> get productosStream => _productosController.stream;

  crearProducto(ProductoModel producto) async{
    await productoProvider.crearProducto(producto);
    cargarProductos();
  }

  editarProducto(ProductoModel producto) async{
    await productoProvider.editarProducto(producto);
    cargarProductos();
  }

  deleteProducto(String id) async{
    await productoProvider.borrarProducto(id);
    cargarProductos();
  }

  cargarProductos() async{
    final productos = await productoProvider.cargarProductos();
    _productosController.sink.add(productos);
  }

  dispose(){
    _productosController.close();
  }

}