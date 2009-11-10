function(doc) {
  if (doc.class == 'gem') {
    emit(doc.name, doc);
  }
}