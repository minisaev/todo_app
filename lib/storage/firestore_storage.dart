import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class FirestoreStorage {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _taskCollection = 'tasks';
  static const String _trashCollection = 'trash';

  static Future<List<Task>> loadTasks() async {
    final snapshot = await _firestore.collection(_taskCollection).get();
    return snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
  }

  static Stream<List<Task>> streamTasks() {
    return _firestore.collection(_taskCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
    });
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final batch = _firestore.batch();
    final collection = _firestore.collection(_taskCollection);

    final snapshot = await collection.get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    for (var task in tasks) {
      batch.set(collection.doc(task.id), task.toMap());
    }

    await batch.commit();
  }

  static Future<void> addTask(Task task) async {
    await _firestore.collection(_taskCollection).doc(task.id).set(task.toMap());
  }

  static Future<void> updateTask(Task task) async {
    await _firestore.collection(_taskCollection).doc(task.id).update(task.toMap());
  }

  static Future<void> deleteTask(String taskId) async {
    await _firestore.collection(_taskCollection).doc(taskId).delete();
  }

  static Future<List<Task>> loadTrash() async {
    final snapshot = await _firestore.collection(_trashCollection).get();
    return snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
  }

  static Stream<List<Task>> streamTrash() {
    return _firestore.collection(_trashCollection).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Task.fromMap(doc.data())).toList();
    });
  }

  static Future<void> saveTrash(List<Task> trash) async {
    final batch = _firestore.batch();
    final collection = _firestore.collection(_trashCollection);

    final snapshot = await collection.get();
    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    for (var task in trash) {
      batch.set(collection.doc(task.id), task.toMap());
    }

    await batch.commit();
  }

  static Future<void> addToTrash(Task task) async {
    await _firestore.collection(_trashCollection).doc(task.id).set(task.toMap());
  }

  static Future<void> deleteFromTrash(String taskId) async {
    await _firestore.collection(_trashCollection).doc(taskId).delete();
  }
}