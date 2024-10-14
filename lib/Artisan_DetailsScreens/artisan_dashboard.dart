import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:check_artisan/jobs/job_list_screen.dart';
import 'package:check_artisan/profile/profile.dart';
import 'package:check_artisan/jobs/quote_request_screen.dart';
import 'package:check_artisan/jobs/reviews_screen.dart';
import 'package:check_artisan/page_navigation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';

// API Service to fetch user information
class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Map<String, dynamic>> fetchUserInfo() async {
    final response = await http.get(Uri.parse('$baseUrl/user'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }
}

// BLoC Events
abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class LoadUserEvent extends UserEvent {
  final bool useApi;

  const LoadUserEvent(this.useApi);

  @override
  List<Object> get props => [useApi];
}

// BLoC States
abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final Map<String, dynamic> userInfo;

  const UserLoaded(this.userInfo);

  @override
  List<Object> get props => [userInfo];
}

class UserError extends UserState {
  final String errorMessage;

  const UserError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

// BLoC Implementation
class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiService apiService;

  UserBloc({required this.apiService}) : super(UserLoading()) {
    on<LoadUserEvent>(_onLoadUser);
  }

  Future<void> _onLoadUser(LoadUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());

    try {
      if (event.useApi) {
        // Fetch data from the API
        final userInfo = await apiService.fetchUserInfo();
        emit(UserLoaded(userInfo));
      } else {
        // Use dummy data
        final dummyData = {
          'name': 'Cheemdee',
          'profession': 'Event Planners & Caterers',
          'rating': 4,
        };
        emit(UserLoaded(dummyData));
      }
    } catch (error) {
      emit(UserError(error.toString()));
    }
  }
}

// Artisan Dashboard UI
class ArtisanDashboard extends StatefulWidget {
  const ArtisanDashboard({Key? key}) : super(key: key);

  @override
  _ArtisanDashboardState createState() => _ArtisanDashboardState();
}

class _ArtisanDashboardState extends State<ArtisanDashboard>
    with SingleTickerProviderStateMixin {
  int currentPage = 0;
  late TabController tabController;

  final List<Widget> pages = [
    const ArtisanDashboardPage(), // New Dashboard Page using BLoC
    const JobListScreen(), // Placeholder for another page
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: pages.length, vsync: this);
    tabController.addListener(() {
      setState(() {
        currentPage = tabController.index;
      });
    });
  }

  void onTabTapped(int index) {
    setState(() {
      currentPage = index;
      tabController.animateTo(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    var colors = [
      const Color(0xFF2C6B58),
      const Color(0xFF2C6B58),
      const Color(0xFF2C6B58),
      const Color(0xFF2C6B58),
    ];
    var selectedColor = const Color(0xFF2C6B58);
    var unselectedColor = Colors.grey;

    return Scaffold(
      body: SafeArea(
        child: pages[currentPage], // Display the current page content here
      ),
      bottomNavigationBar: BottomBar(
        fit: StackFit.expand,
        borderRadius: BorderRadius.circular(500),
        duration: const Duration(seconds: 1),
        curve: Curves.decelerate,
        showIcon: true,
        width: MediaQuery.of(context).size.width * 0.8,
        barColor: colors[currentPage].computeLuminance() > 0.5
            ? Colors.black
            : Colors.white,
        start: 2,
        end: 0,
        offset: 10,
        barAlignment: Alignment.bottomCenter,
        iconHeight: 35,
        iconWidth: 35,
        reverse: false,
        barDecoration: BoxDecoration(
          color: colors[currentPage],
          borderRadius: BorderRadius.circular(500),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        iconDecoration: BoxDecoration(
          color: colors[currentPage],
          borderRadius: BorderRadius.circular(500),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        hideOnScroll: true,
        scrollOpposite: false,
        onBottomBarHidden: () {},
        onBottomBarShown: () {},
        body: (context, controller) => TabBarView(
          controller: tabController,
          dragStartBehavior: DragStartBehavior.down,
          physics: const BouncingScrollPhysics(),
          children: pages, // Tab pages
        ),
        child: TabBar(
          controller: tabController,
          tabs: [
            Tab(
              icon: ImageIcon(
                const AssetImage("assets/icons/home.png"),
                color: currentPage == 0 ? selectedColor : unselectedColor,
              ),
            ),
            Tab(
              icon: ImageIcon(
                const AssetImage("assets/icons/job_list.png"),
                color: currentPage == 1 ? selectedColor : unselectedColor,
              ),
            ),
            Tab(
              icon: ImageIcon(
                const AssetImage('assets/icons/profile.png'),
                color: currentPage == 2 ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// New Artisan Dashboard Page with BLoC for API and Dummy Data
class ArtisanDashboardPage extends StatelessWidget {
  const ArtisanDashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(
          apiService: ApiService('https://example.com'))
        ..add(const LoadUserEvent(false)), // Change to true when API is ready
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return ArtisanDashboardContent(userInfo: state.userInfo);
          } else if (state is UserError) {
            return Center(child: Text('Error: ${state.errorMessage}'));
          } else {
            return const Center(child: Text('Unknown state'));
          }
        },
      ),
    );
  }
}

// The original Artisan Dashboard UI content with new layout for profile
class ArtisanDashboardContent extends StatelessWidget {
  final Map<String, dynamic> userInfo;

  const ArtisanDashboardContent({Key? key, required this.userInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    const SizedBox(height: 30);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Welcome Back Artisan,',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage('assets/icons/dashboard.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  width: double.infinity,
                  height: screenSize.height * 0.2,
                ),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage(
                            'assets/images/profile_placeholder.png'), // Replace with actual image from profile
                        radius: 40,
                      ),
                      const SizedBox(width: 16.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name below profile image
                          Text(
                            userInfo['name'], // From API or dummy data
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(
                              height: 8.0), // Space between name and rating
                          // Row with star rating and profession below it
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: buildStarRating(userInfo['rating']),
                              ),
                              const SizedBox(
                                  height:
                                      4.0), // Space between stars and profession
                              Text(
                                userInfo[
                                    'profession'], // From API or dummy data
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Calculate the number of columns and aspect ratio based on screen width
                int crossAxisCount = constraints.maxWidth > 600
                    ? 3
                    : 2; // 3 columns on larger screens, 2 on smaller
                double childAspectRatio =
                    constraints.maxWidth > 600 ? 1.2 : 0.9;

                return GridView.count(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 15, // Increased for better spacing
                  mainAxisSpacing: 15, // Increased for better spacing
                  childAspectRatio: childAspectRatio *
                      1.5, // Adjusted for different screen sizes
                  children: [
                    buildCard(
                        context,
                        '0 New Job(s)',
                        'assets/icons/new_jobs.png',
                        'NewJobsScreen',
                        constraints),
                    buildCard(
                        context,
                        '0 Job Lists',
                        'assets/icons/job_list.png',
                        'JobListsScreen',
                        constraints),
                    buildCard(
                        context,
                        '0 Review(s)',
                        'assets/icons/reviews.png',
                        'ReviewsScreen',
                        constraints),
                    buildCard(context, '0 Quote(s)', 'assets/icons/quote.png',
                        'QuotesScreen', constraints),
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  List<Widget> buildStarRating(int rating) {
    return List<Widget>.generate(5, (index) {
      return Icon(
        index < rating ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 20,
      );
    });
  }

  Widget buildCard(BuildContext context, String title, String imagePath,
      String routeName, BoxConstraints constraints) {
    // Define a smaller size factor for more compact cards
    double sizeFactor =
        constraints.maxWidth > 600 ? 0.08 : 0.1; // Smaller icons

    return GestureDetector(
      onTap: () {
        switch (routeName) {
          case 'NewJobsScreen':
            CheckartisanNavigator.pushReplacement(
                context, const ArtisanDashboard());
            break;
          case 'JobListsScreen':
            CheckartisanNavigator.pushReplacement(
                context, const JobListScreen());
            break;
          case 'ReviewsScreen':
            CheckartisanNavigator.pushReplacement(
                context, const ReviewsScreen());
            break;
          case 'QuotesScreen':
            CheckartisanNavigator.pushReplacement(
                context, const QuoteRequestsScreen());
            break;
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Smaller corner radius
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6, // Slightly reduced blur for a softer shadow
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: constraints.maxWidth * sizeFactor, // Smaller icon size
              height: constraints.maxWidth * sizeFactor,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 8), // Reduced spacing for tighter layout
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: constraints.maxWidth * 0.03, // Smaller text size
              ),
            ),
          ],
        ),
      ),
    );
  }
}
