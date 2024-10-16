import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';

import 'package:http/http.dart' as http;
import 'package:lets_go_with_me/data/dataproviders/create_event_service.dart';
import 'package:lets_go_with_me/data/dataproviders/delete_account_service.dart';
import 'package:lets_go_with_me/data/dataproviders/fetch_trip_joiners_service.dart';
import 'package:lets_go_with_me/data/dataproviders/profile_service.dart';
import 'package:lets_go_with_me/data/dataproviders/events_service.dart';
import 'package:lets_go_with_me/data/dataproviders/auth_service.dart';
import 'package:lets_go_with_me/data/dataproviders/post_trip_comment_service.dart';
import 'package:lets_go_with_me/data/dataproviders/fetch_trip_comments_service.dart';
import 'package:lets_go_with_me/data/dataproviders/trip_engagement_service.dart';
import 'package:lets_go_with_me/data/dataproviders/user_details_service.dart';
import 'package:lets_go_with_me/data/repositories/create_event_repo.dart';
import 'package:lets_go_with_me/data/repositories/create_profile_repo.dart';
import 'package:lets_go_with_me/data/repositories/delete_account_repo.dart';
import 'package:lets_go_with_me/data/repositories/events_repo.dart';
import 'package:lets_go_with_me/data/repositories/auth_repo.dart';
import 'package:lets_go_with_me/data/repositories/post_comments_repo.dart';
import 'package:lets_go_with_me/data/repositories/trip_engagement_repo.dart';
import 'package:lets_go_with_me/data/repositories/trip_joiners_repo.dart';
import 'package:lets_go_with_me/data/repositories/user_comments_repo.dart';
import 'package:lets_go_with_me/data/repositories/user_details_repo.dart';
import 'package:lets_go_with_me/data/repositories/user_likes_repo.dart';

import '../../data/dataproviders/fetch_trip_likes_service.dart';
import 'network_Info.dart';

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerFactory<AuthRepo>(() => AuthRepoImpl(authService: locator()));
  locator.registerFactory<AuthService>(() => OtpServiceImpl(httpClient: locator()));

  locator.registerFactory<ProfileRepo>(() => ProfileRepoImpl(profileService: locator()));
  locator.registerFactory<ProfileService>(() => ProfileServiceImpl(httpClient: locator()));

  locator.registerFactory<UserDetailsRepo>(() => UserDetailsRepoImpl(userDetailsService: locator()));
  locator.registerFactory<UserDetailsService>(() => UserDetailServiceImpl(httpClient: locator()));

  locator.registerFactory<EventsRepo>(() => EventRepoImpl(eventsService: locator()));
  locator.registerFactory<EventsService>(() => EventsServiceImpl(httpClient: locator()));

  locator.registerFactory<UserCommentsRepo>(() => UserCommentsRepoImpl(userCommentsService: locator()));
  locator.registerFactory<FetchTripCommentsService>(() => FetchTripCommentsServiceImpl(httpClient: locator()));

  locator.registerFactory<PostCommentsRepo>(() => PostCommentsRepoImpl(postCommentService: locator()));
  locator.registerFactory<PostTripCommentService>(() => PostTripCommentServiceImpl(httpClient: locator()));

  locator.registerFactory<CreateEventRepo>(() => CreateEventRepoImpl(createEventService: locator()));
  locator.registerFactory<CreateEventService>(() => CreateEventServiceImpl(httpClient: locator()));

  locator.registerFactory<UserLikesRepo>(() => UserLikesRepoImpl(userLikesService: locator()));
  locator.registerFactory<FetchTripLikesService>(() => FetchTripLikesServiceImpl(httpClient: locator()));

  locator.registerFactory<TripJoinersRepo>(() => TripJoinersRepoImpl(fetchTripJoinersService: locator()));
  locator.registerFactory<FetchTripJoinersService>(() => FetchTripJoinersServiceImpl(httpClient: locator()));

  locator.registerFactory<TripEngagementRepo>(() => TripEngagementRepoImpl(tripEngagementService: locator()));
  locator.registerFactory<TripEngagementService>(() => TripEngagementServiceImpl(httpClient: locator()));

  locator.registerFactory<DeleteAccountRepo>(() => DeleteAccountRepoImpl(deleteAccountService: locator()));
  locator.registerFactory<DeleteAccountService>(() => DeleteAccountServiceImpl(httpClient: locator()));

  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));
  locator.registerFactory(() => Connectivity());

  locator.registerLazySingleton(() => http.Client());
}
