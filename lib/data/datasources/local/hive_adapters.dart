class HiveAdapters {
  static bool _registered = false;

  static void register() {
    if (_registered) {
      return;
    }
    // We store JSON maps directly for now. Register adapters here when needed.
    _registered = true;
  }
}
