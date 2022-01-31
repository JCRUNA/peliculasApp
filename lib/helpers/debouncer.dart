import 'dart:async';

// Creditos
// https://stackoverflow.com/a/52922130/7834829
///Es una clase generica. Es una clase que esta escuchando las teclas y espera hasta que la persona
///deje de escribir para asi poder disparar el valor de debouncer.
///Recordemos que si el debouncer cada vez que escribimos sobre el buscador se disparan peticiones http
///provocando un consumo innecesario de recursos.
///Al ser generico T puede emitir cualquier cosa (string, int, etc).
///Recibe como parametro el Duration que es el tiempo que quiero esperar antes de emitir un valor.
///El onValue es un metodo que disparo cuando tengo un valor
class Debouncer<T> {
  Debouncer({required this.duration, this.onValue});

  final Duration duration;

  void Function(T value)? onValue;

  T? _value;
  Timer? _timer;

  ///es una funcion de control de dart

  T get value => _value!;

  set value(T val) {
    _value = val;
    _timer?.cancel();

    ///si recibimos un valor entonces cancelamos el timer
    _timer = Timer(duration, () => onValue!(_value!));

    ///si el Timer cumple la duracion que especique entonces llamada al metodo onValue
  }
}
