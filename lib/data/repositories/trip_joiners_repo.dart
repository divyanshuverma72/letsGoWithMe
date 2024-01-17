import 'package:dartz/dartz.dart';
import 'package:lets_go_with_me/data/dataproviders/fetch_trip_joiners_service.dart';
import 'package:lets_go_with_me/data/models/trip_joiners_api_response_model.dart';

import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';

abstract class TripJoinersRepo {
  Future<Either<Failure, TripJoinersApiResponseModel>> fetchTripJoinersList(
      String tripId, int page);
}

class TripJoinersRepoImpl extends TripJoinersRepo {

  FetchTripJoinersService fetchTripJoinersService;
  TripJoinersRepoImpl({required this.fetchTripJoinersService});

  @override
  Future<Either<Failure, TripJoinersApiResponseModel>> fetchTripJoinersList(
      String tripId, int page) async {
    try {
      final tripJoinersResponse = await fetchTripJoinersService.fetchTripJoiners(tripId, page);
      return right(tripJoinersResponse);
    } on FetchTripJoinersException {
      return left(FetchTripJoinersFailure());
    }
  }
}
