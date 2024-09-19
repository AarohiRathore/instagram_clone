import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class PaginationState extends Equatable {
  @override
  List<Object> get props => [];
}

class PaginationInitial extends PaginationState {}

class PaginationLoading extends PaginationState {}

class PaginationLoaded extends PaginationState {
  final List<QueryDocumentSnapshot> users;
  final bool hasMore;

  PaginationLoaded(this.users, this.hasMore);

  @override
  List<Object> get props => [users, hasMore];
}

class PaginationError extends PaginationState {
  final String message;

  PaginationError(this.message);

  @override
  List<Object> get props => [message];
}

class PaginationCubit extends Cubit<PaginationState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentSnapshot? lastDocument;
  bool isFetching = false;
  bool hasMore = true;

  PaginationCubit() : super(PaginationInitial());

  void fetchUsers({int limit = 10}) async {
    if (isFetching || !hasMore) return;
    isFetching = true;

    try {
      emit(PaginationLoading());

      QuerySnapshot snapshot;
      if (lastDocument == null) {
        snapshot = await _firestore
            .collection('users')
            .orderBy('name') // Change order field if needed
            .limit(limit)
            .get();
      } else {
        snapshot = await _firestore
            .collection('users')
            .orderBy('name')
            .startAfterDocument(lastDocument!)
            .limit(limit)
            .get();
      }

      if (snapshot.docs.isNotEmpty) {
        lastDocument = snapshot.docs.last;
        hasMore = snapshot.docs.length == limit;
        final allUsers = state is PaginationLoaded
            ? (state as PaginationLoaded).users + snapshot.docs
            : snapshot.docs;
        emit(PaginationLoaded(allUsers, hasMore));
      } else {
        hasMore = false;
        if (state is PaginationLoaded) {
          emit(PaginationLoaded((state as PaginationLoaded).users, hasMore));
        }
      }
    } catch (e) {
      emit(PaginationError(e.toString()));
    } finally {
      isFetching = false;
    }
  }
}
