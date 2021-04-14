import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_database/firebase_database.dart';

import 'package:lv_shop_list/models/lv_product.dart';
import 'package:lv_shop_list/utils/lv_logger.dart';

/// `initialize` should be called before once per application and before calling methods on database references. It sets offline persitence, storing changes on disk and commiting those modifications once connected to the server. If the app is closed during a offline session data changes are not lost.
/// By default the Firebase Database client uses 10MB of disk space to cache.
class LvFirebaseProvider {
  final FirebaseDatabase database;
  LvFirebaseProvider(FirebaseApp app)
      : this.database = FirebaseDatabase(app: app);

  /// Returns `false` is database references were already acted upon or `true` if operation was successful.
  Future<bool> initialize({bool enablePersistence = true}) async {
    // set persistence mode.
    final cond = await this.database.setPersistenceEnabled(enablePersistence);
    if (!cond) {
      logger.w('Database Persistence mode disabled.');
    } else {
      logger.w('Database Persistence mode enabled.');
    }
    // await this.database.setPersistenceCacheSizeBytes();
    // this.root.onChildRemoved.listen((data) => logger.wtf(data.snapshot.key));
    // this.root.onChildAdded.listen((data) => logger.v(data.snapshot.key));
    return cond;
  }

  /// Root node.
  DatabaseReference get root => this.database.reference().root();

  /// Adds new Product.
  /// `push()` creates a child on a new location with a unique key (created by firebase) and returns a reference to it, used to set its value.
  Future<void> create(LvProduct product) =>
      this.root.push().set(product.toJson());

  /// Remove [product] by firebase [key].
  Future<void> remove(String key) => this.root.child(key).remove();

  /// Update Product quantity.
  Future<void> update(String key, int quantity) =>
      this.root.child(key).child('quantity').set(quantity);

  /// Remove all.
  /// equivalent to calling `set(null)` on this location.
  Future<void> removeAll() => this.root.remove();
}
