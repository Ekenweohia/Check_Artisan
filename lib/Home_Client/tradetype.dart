import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:check_artisan/Artisan_DetailsScreens/artisanlistscreen.dart';
import 'package:check_artisan/page_navigation.dart';

class TradeType {
  final String id;
  final String name;
  final String tradeSrc;

  TradeType({
    required this.id,
    required this.name,
    required this.tradeSrc,
  });

  factory TradeType.fromJson(Map<String, dynamic> json) {
    return TradeType(
      id: json['id'].toString(),
      name: json['tradetype_name'] ?? 'Unknown',
      tradeSrc: json['trade_src'] ?? '',
    );
  }
}

abstract class TradeTypeEvent extends Equatable {
  const TradeTypeEvent();

  @override
  List<Object> get props => [];
}

class LoadTradeTypes extends TradeTypeEvent {}

abstract class TradeTypeState extends Equatable {
  const TradeTypeState();

  @override
  List<Object> get props => [];
}

class TradeTypeInitial extends TradeTypeState {}

class TradeTypeLoading extends TradeTypeState {}

class TradeTypeLoaded extends TradeTypeState {
  final List<TradeType> tradeTypes;

  const TradeTypeLoaded(this.tradeTypes);

  @override
  List<Object> get props => [tradeTypes];
}

class TradeTypeError extends TradeTypeState {
  final String message;

  const TradeTypeError(this.message);

  @override
  List<Object> get props => [message];
}

class TradeTypeBloc extends Bloc<TradeTypeEvent, TradeTypeState> {
  TradeTypeBloc() : super(TradeTypeInitial()) {
    on<LoadTradeTypes>(_onLoadTradeTypes);
  }

  Future<void> _onLoadTradeTypes(LoadTradeTypes event, Emitter<TradeTypeState> emit) async {
    emit(TradeTypeLoading());
    try {
      final response = await http.get(Uri.parse('https://checkartisan.com/api/tradetypes'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final tradeTypes = data.map((json) => TradeType.fromJson(json)).toList();
        emit(TradeTypeLoaded(tradeTypes));
      } else {
        emit(const TradeTypeError('Failed to load trade types from server.'));
      }
    } catch (e) {
      emit(TradeTypeError('An error occurred: ${e.toString()}'));
    }
  }
}

class TradeTypeScreen extends StatefulWidget {
  const TradeTypeScreen({Key? key}) : super(key: key);

  @override
  _TradeTypeScreenState createState() => _TradeTypeScreenState();
}

class _TradeTypeScreenState extends State<TradeTypeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<TradeType> _filteredTradeTypes = [];
  List<TradeType> _allTradeTypes = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterTradeTypes);
  }

  void _filterTradeTypes() {
    setState(() {
      _filteredTradeTypes = _allTradeTypes
          .where((tradeType) =>
              tradeType.name.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TradeTypeBloc()..add(LoadTradeTypes()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text('Trade Type', style: TextStyle(fontWeight: FontWeight.w600)),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
                // Handle notification button press
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0), // Increased padding for the main layout
          child: Column(
            children: [
              const SizedBox(height: 16.0), // Space between the app bar and search bar
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25), // Shadow color
                      offset: const Offset(0, 4), // Shadow position
                      blurRadius: 4, // Blur radius
                    ),
                  ],
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for Artisans',
                    hintStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    suffixIcon: const Icon(Icons.search, color: Color(0xFFADADAD)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
              const SizedBox(height: 16.0), // Space between the search bar and list
              Expanded(
                child: BlocBuilder<TradeTypeBloc, TradeTypeState>(
                  builder: (context, state) {
                    if (state is TradeTypeLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TradeTypeError) {
                      return Center(child: Text(state.message));
                    } else if (state is TradeTypeLoaded) {
                      _allTradeTypes = state.tradeTypes;
                      _filteredTradeTypes = _filteredTradeTypes.isEmpty
                          ? _allTradeTypes
                          : _filteredTradeTypes;
                      return _buildTradeTypeList(context, _filteredTradeTypes);
                    } else {
                      return const Center(child: Text('Unexpected State'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTradeTypeList(BuildContext context, List<TradeType> tradeTypes) {
    return ListView.builder(
      itemCount: tradeTypes.length,
      itemBuilder: (context, index) {
        final tradeType = tradeTypes[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0), // Added padding to each list item
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.grey),
              ),
            ),
            onPressed: () {
              CheckartisanNavigator.push(
                context,
                ArtisanListScreen(
                  title: tradeType.name,
                  artisanType: tradeType.name, // Pass the selected trade type
                ),
              );
            },
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: 'https://checkartisan.com/images/${tradeType.tradeSrc}',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error, size: 40),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Text(
                    tradeType.name,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
