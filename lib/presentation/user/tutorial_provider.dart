import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TutorialProvider extends ChangeNotifier{
  List<String> _ids = [];

  List<String> get ids => _ids;

  Future<List<String>> fetchVideoIds() async {
    var snapshot = await FirebaseFirestore.instance.collection('videos').get();
    _ids = snapshot.docs.map((doc) => doc.id).toList();
    return ids;
    // notifyListeners();
  }
  addVideo(String id) async {
    await FirebaseFirestore.instance.collection('videos').doc(id).set({'id':id});
    // fetchVideoIds();  // Actualizar los IDs después de agregar un video
    if(!_ids.contains(id)){
      _ids.add(id);
    }
    notifyListeners();
  }

  deleteVideo(String id) async {
    await FirebaseFirestore.instance.collection('videos').doc(id).delete();
    // fetchVideoIds();  // Actualizar los IDs después de eliminar un video
    _ids.remove(id);
    notifyListeners();
  }
}