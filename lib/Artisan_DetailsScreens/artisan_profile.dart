import 'package:check_artisan/Home_Client/homeclient.dart';
import 'package:check_artisan/circular_loading.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:check_artisan/profile/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:equatable/equatable.dart';

abstract class ArtisanProfileState extends Equatable {
  const ArtisanProfileState();

  @override
  List<Object> get props => [];
}

class ArtisanProfileInitial extends ArtisanProfileState {}

class ArtisanProfileLoading extends ArtisanProfileState {}

class ArtisanProfileLoaded extends ArtisanProfileState {
  final bool isAboutSelected;
  final String description;
  final List<String> skills;
  final int totalJobs;
  final double customerRating;

  const ArtisanProfileLoaded({
    required this.isAboutSelected,
    required this.description,
    required this.skills,
    required this.totalJobs,
    required this.customerRating,
  });

  @override
  List<Object> get props =>
      [isAboutSelected, description, skills, totalJobs, customerRating];
}

class ArtisanProfileError extends ArtisanProfileState {
  final String message;

  const ArtisanProfileError(this.message);

  @override
  List<Object> get props => [message];
}

abstract class ArtisanProfileEvent extends Equatable {
  const ArtisanProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadArtisanProfile extends ArtisanProfileEvent {
  final String artisanId;

  const LoadArtisanProfile(this.artisanId);

  @override
  List<Object> get props => [artisanId];
}

class ToggleTab extends ArtisanProfileEvent {
  final bool isAboutSelected;

  const ToggleTab(this.isAboutSelected);

  @override
  List<Object> get props => [isAboutSelected];
}

class ArtisanProfileBloc
    extends Bloc<ArtisanProfileEvent, ArtisanProfileState> {
  ArtisanProfileBloc() : super(ArtisanProfileInitial()) {
    on<LoadArtisanProfile>(_onLoadArtisanProfile);
    on<ToggleTab>(_onToggleTab);
  }

  Future<void> _onLoadArtisanProfile(
      LoadArtisanProfile event, Emitter<ArtisanProfileState> emit) async {
    emit(ArtisanProfileLoading());
    try {
      final response = await http.get(Uri.parse(
          'https://checkartisan.com/api/artisan-profile/${event.artisanId}'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        emit(ArtisanProfileLoaded(
          isAboutSelected: true,
          description: data['description'],
          skills: List<String>.from(data['skills']),
          totalJobs: data['totalJobs'],
          customerRating: data['customerRating'],
        ));
      } else {
        emit(const ArtisanProfileError('Failed to load profile data'));
      }
    } catch (e) {
      emit(ArtisanProfileError(e.toString()));
    }
  }

  void _onToggleTab(ToggleTab event, Emitter<ArtisanProfileState> emit) {
    if (state is ArtisanProfileLoaded) {
      final loadedState = state as ArtisanProfileLoaded;
      emit(ArtisanProfileLoaded(
        isAboutSelected: event.isAboutSelected,
        description: loadedState.description,
        skills: loadedState.skills,
        totalJobs: loadedState.totalJobs,
        customerRating: loadedState.customerRating,
      ));
    }
  }
}

// Full Screen Implementation

class ArtisanProfileScreen extends StatefulWidget {
  const ArtisanProfileScreen({Key? key}) : super(key: key);

  @override
  ArtisanProfileScreenState createState() => ArtisanProfileScreenState();
}

class ArtisanProfileScreenState extends State<ArtisanProfileScreen> {
  late ArtisanProfileBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ArtisanProfileBloc()
      ..add(const LoadArtisanProfile(
          'your_artisan_id')); // replace with actual artisan ID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF004D40)),
          onPressed: () {
            CheckartisanNavigator.push(context, const ArtisanScreen());
          },
        ),
        title: const Text(
          'About Artisan',
          style: TextStyle(
              fontWeight: FontWeight.w500,
              fontFamily: 'Montserrat-SemiBold.ttf'),
          textAlign: TextAlign.center,
        ),
      ),
      body: BlocBuilder<ArtisanProfileBloc, ArtisanProfileState>(
        bloc: _bloc,
        builder: (context, state) {
          if (state is ArtisanProfileLoading) {
            return const Center(child: CircularLoadingWidget());
          } else if (state is ArtisanProfileLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      CircleAvatar(
                        radius: 30.0,
                        backgroundImage:
                            NetworkImage('https://via.placeholder.com/150'),
                      ),
                      SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cheemdee',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            'Events Planner & Caterer',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            'Umuahia, Abia State',
                            style:
                                TextStyle(fontSize: 14.0, color: Colors.grey),
                          ),
                          SizedBox(height: 2.0),
                          Text(
                            'Registered Member since 2024-04-10',
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _bloc.add(const ToggleTab(true));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: state.isAboutSelected
                                ? const Color(0xFF004D40)
                                : Colors.white,
                            foregroundColor: state.isAboutSelected
                                ? Colors.white
                                : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text('About'),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            _bloc.add(const ToggleTab(false));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !state.isAboutSelected
                                ? const Color(0xFF004D40)
                                : Colors.white,
                            foregroundColor: !state.isAboutSelected
                                ? Colors.white
                                : Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: const Text('Reviews'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: state.isAboutSelected
                        ? buildAboutSection(state)
                        : buildReviewsSection(),
                  ),
                  const SizedBox(height: 16.0),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        CheckartisanNavigator.push(context, const HomeClient());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004D40),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'INVITE TO QUOTE',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is ArtisanProfileError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }

  Widget buildAboutSection(ArtisanProfileLoaded state) {
    return ListView(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Description:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              Text(
                state.description,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Artisan Skills:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4.0),
              ...state.skills.map((skill) => Text(skill)).toList(),
            ],
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Total Jobs',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${state.totalJobs}',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Customer Rating',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      '${state.customerRating}/5',
                      style: const TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildReviewsSection() {
    return const Center(
      child: Text('Reviews Tab Content'),
    );
  }
}
