import 'package:check_artisan/Artisan_DetailsScreens/artisan_profile.dart';
import 'package:check_artisan/jobs/quote_request_screen.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ArtisanListEvent extends Equatable {
  const ArtisanListEvent();

  @override
  List<Object> get props => [];
}

class LoadArtisanList extends ArtisanListEvent {
  final String? tradeType;
  final int page;
  final int limit;

  const LoadArtisanList({this.tradeType, this.page = 1, this.limit = 10});

  @override
  List<Object> get props => [tradeType ?? '', page, limit];
}

abstract class ArtisanListState extends Equatable {
  const ArtisanListState();

  @override
  List<Object> get props => [];
}

class ArtisanListInitial extends ArtisanListState {}

class ArtisanListLoading extends ArtisanListState {
  final List<Artisan> artisans;

  const ArtisanListLoading({this.artisans = const []});

  @override
  List<Object> get props => [artisans];
}

class ArtisanListLoaded extends ArtisanListState {
  final List<Artisan> artisans;
  final bool hasReachedMax;

  const ArtisanListLoaded(this.artisans, {this.hasReachedMax = false});

  @override
  List<Object> get props => [artisans, hasReachedMax];
}

class ArtisanListError extends ArtisanListState {
  final String message;

  const ArtisanListError(this.message);

  @override
  List<Object> get props => [message];
}

class ArtisanListBloc extends Bloc<ArtisanListEvent, ArtisanListState> {
  ArtisanListBloc() : super(ArtisanListInitial()) {
    on<LoadArtisanList>(_onLoadArtisanList);
  }

  Future<void> _onLoadArtisanList(
      LoadArtisanList event, Emitter<ArtisanListState> emit) async {
    final currentState = state;

    if (currentState is ArtisanListLoaded && currentState.hasReachedMax) return;

    emit(ArtisanListLoading(
        artisans: currentState is ArtisanListLoaded ? currentState.artisans : []));

    try {
      // Cache logic (optional)
      final prefs = await SharedPreferences.getInstance();
      final cachedData =
          prefs.getString('artisan_list_${event.tradeType}_${event.page}');

      if (cachedData != null) {
        final List<dynamic> cachedJson = jsonDecode(cachedData);
        final List<Artisan> cachedArtisans = cachedJson
            .map((json) => Artisan.fromJson(json as Map<String, dynamic>))
            .toList();
        emit(ArtisanListLoaded(cachedArtisans));
        return;
      }

      String url;
      if (event.tradeType != null && event.tradeType!.isNotEmpty) {
        url =
            'https://checkartisan.com/api/artisans/category/${event.tradeType}?page=${event.page}&limit=${event.limit}';
      } else {
        url =
            'https://checkartisan.com/api/all/artisans?page=${event.page}&limit=${event.limit}';
      }

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<Artisan> artisans = data
            .map<Artisan>(
                (json) => Artisan.fromJson(json as Map<String, dynamic>))
            .toList();

        // Cache the result for future reference
        await prefs.setString(
            'artisan_list_${event.tradeType}_${event.page}', jsonEncode(data));

        final hasReachedMax = artisans.isEmpty;

        final currentArtisans =
            currentState is ArtisanListLoaded ? currentState.artisans : [];

        emit(ArtisanListLoaded(
          List<Artisan>.from(currentArtisans)..addAll(artisans),
          hasReachedMax: hasReachedMax,
        ));
      } else {
        emit(const ArtisanListError('Failed to load artisan list'));
      }
    } catch (e) {
      emit(ArtisanListError(e.toString()));
    }
  }
}

class Artisan {
  final int id;
  final String artisanId;
  final String companyName;
  final String description;
  final String avatar;
  final String rating;
  final String cityName;
  final String stateName;
  final String countryName;
  final String firstName;
  final String lastName;
  final List<Skill> skills;

  Artisan({
    required this.id,
    required this.artisanId,
    required this.companyName,
    required this.description,
    required this.avatar,
    required this.rating,
    required this.cityName,
    required this.stateName,
    required this.countryName,
    required this.firstName,
    required this.lastName,
    required this.skills,
  });

  factory Artisan.fromJson(Map<String, dynamic> json) {
    return Artisan(
      id: json['id'],
      artisanId: json['artisan_id'].toString(),
      companyName: json['companyname'] ?? '',
      description: json['description'] ?? '',
      avatar: json['avatar'] ?? '',
      rating: json['rating'].toString(),
      cityName: json['cityName'] ?? '',
      stateName: json['stateName'] ?? '',
      countryName: json['countryName'] ?? '',
      firstName: json['user']['firstname'] ?? '',
      lastName: json['user']['lastname'] ?? '',
      skills: (json['skills'] as List)
          .map<Skill>((skillJson) => Skill.fromJson(skillJson['skill']))
          .toList(),
    );
  }
}

class Skill {
  final int id;
  final String skillName;

  Skill({
    required this.id,
    required this.skillName,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'],
      skillName: json['skill_name'],
    );
  }
}

class ArtisanListScreen extends StatefulWidget {
  final String title;
  final String? artisanType;

  const ArtisanListScreen({
    Key? key,
    required this.title,
    this.artisanType,
  }) : super(key: key);

  @override
  _ArtisanListScreenState createState() => _ArtisanListScreenState();
}

class _ArtisanListScreenState extends State<ArtisanListScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<ArtisanListBloc>().add(LoadArtisanList(
          tradeType: widget.artisanType,
          page: (context.read<ArtisanListBloc>().state as ArtisanListLoaded).artisans.length ~/ 10 + 1));
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ArtisanListBloc()..add(LoadArtisanList(tradeType: widget.artisanType)),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(widget.title),
          centerTitle: true,
        ),
        body: BlocBuilder<ArtisanListBloc, ArtisanListState>(
          builder: (context, state) {
            if (state is ArtisanListLoading && state.artisans.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ArtisanListLoaded) {
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                itemCount: state.hasReachedMax
                    ? state.artisans.length
                    : state.artisans.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.artisans.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final artisan = state.artisans[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.width * 0.04),
                    child: ArtisanCard(artisan: artisan),
                  );
                },
              );
            } else if (state is ArtisanListError) {
              return Center(child: Text(state.message));
            } else {
              return const Center(child: Text('Unknown state'));
            }
          },
        ),
      ),
    );
  }
}

class ArtisanCard extends StatelessWidget {
  final Artisan artisan;

  const ArtisanCard({
    Key? key,
    required this.artisan,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(screenSize.width * 0.04),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                    radius: screenSize.width * 0.08,
                    backgroundImage: NetworkImage(
                        'https://checkartisan.com/images/${artisan.avatar}')),
                SizedBox(width: screenSize.width * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artisan.companyName,
                        style: TextStyle(
                          fontSize: screenSize.width * 0.04,
                          fontWeight: FontWeight.bold,
                        ),
                       
                      ),
                      Text(
                        '${artisan.stateName}, ${artisan.cityName}',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.035,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
  mainAxisAlignment: MainAxisAlignment.center, // Center the buttons
  children: [
    ElevatedButton(
      onPressed: () {
        CheckartisanNavigator.push(context, const QuoteRequestsScreen());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF004D40),
        side: const BorderSide(color: Color(0xffC4C4C4)),
        shape: RoundedRectangleBorder( // Adding border radius
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        'GET QUOTE',
        style: TextStyle(fontSize: screenSize.width * 0.035),
      ),
    ),
    const SizedBox(width: 10), // Reduce space between the buttons
    ElevatedButton(
      onPressed: () {
        CheckartisanNavigator.push(context, const ArtisanProfileScreen());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF004D40),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder( // Adding border radius
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        'VIEW PROFILE',
        style: TextStyle(fontSize: screenSize.width * 0.035),
      ),
    ),
  ],
)

          ],
        ),
      ),
    );
  }
}
