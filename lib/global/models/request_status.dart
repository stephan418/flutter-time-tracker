enum RequestStatus { initial, loading, success, failure }

extension RequestStatusX on RequestStatus {
  bool get isLoadingOrSuccess =>
      this == RequestStatus.loading || this == RequestStatus.success;
}
