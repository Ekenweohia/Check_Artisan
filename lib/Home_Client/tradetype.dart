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
      name: json['tradetype_name'],
      tradeSrc: json['trade_src'],
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
  final List<TradeType> defaultTradeTypes = [
    TradeType(
        id: '1', name: 'AC & Refrigerator Repairer', tradeSrc: 'ac_repair.jpg'),
    TradeType(
        id: '2', name: 'Aluminium Maker', tradeSrc: 'aluminium_maker.jpg'),
    TradeType(id: '3', name: 'Auto Mechanic', tradeSrc: 'auto_mechanic.jpg'),
    TradeType(id: '4', name: 'Builder', tradeSrc: 'builder.jpg'),
    TradeType(id: '5', name: 'Carpenter', tradeSrc: 'carpenter.jpg'),
    TradeType(
        id: '6', name: 'Computer Repairer', tradeSrc: 'computer_repair.jpg'),
    TradeType(
        id: '7',
        name: 'Drainage Specialist',
        tradeSrc: 'drainage_specialist.jpg'),
    TradeType(id: '8', name: 'Draughtsman', tradeSrc: 'draughtsman.jpg'),
    TradeType(id: '9', name: 'Driver', tradeSrc: 'driver.jpg'),
    TradeType(id: '10', name: 'Electrician', tradeSrc: 'electrician.jpg'),
    TradeType(
        id: '11',
        name: 'Event Planner & Caterers',
        tradeSrc: 'event_planner.jpg'),
    TradeType(
        id: '12', name: 'Fashion Designer', tradeSrc: 'fashion_designer.jpg'),
    TradeType(id: '13', name: 'Gardener', tradeSrc: 'gardener.jpg'),
    TradeType(
        id: '14',
        name: 'Gas Cooker Repairer',
        tradeSrc: 'gas_cooker_repair.jpg'),
    TradeType(
        id: '15', name: 'Generator Repairer', tradeSrc: 'generator_repair.jpg'),
    TradeType(id: '16', name: 'Hair Stylist', tradeSrc: 'hair_stylist.jpg'),
    TradeType(
        id: '17',
        name: 'Home Maintenance/ Repair',
        tradeSrc: 'home_maintenance.jpg'),
  ];

  TradeTypeBloc() : super(TradeTypeInitial()) {
    on<LoadTradeTypes>(_onLoadTradeTypes);
  }

  Future<void> _onLoadTradeTypes(
      LoadTradeTypes event, Emitter<TradeTypeState> emit) async {
    emit(TradeTypeLoading());
    try {
      final response =
          await http.get(Uri.parse('https://checkartisan.com/api/tradetypes'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final tradeTypes =
            data.map((json) => TradeType.fromJson(json)).toList();
        emit(TradeTypeLoaded(tradeTypes));
      } else {
        emit(const TradeTypeError('Failed to load trade types from server.'));
      }
    } catch (e) {
      emit(TradeTypeError('An error occurred: ${e.toString()}'));
    }
  }
}

class TradeTypeScreen extends StatelessWidget {
  const TradeTypeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TradeTypeBloc()..add(LoadTradeTypes()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF004D40)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Trade Type'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for Artisans',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<TradeTypeBloc, TradeTypeState>(
                builder: (context, state) {
                  if (state is TradeTypeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is TradeTypeError) {
                    return _buildTradeTypeList(context,
                        context.read<TradeTypeBloc>().defaultTradeTypes);
                  } else if (state is TradeTypeLoaded) {
                    return _buildTradeTypeList(context, state.tradeTypes);
                  } else {
                    return const Center(child: Text('Unexpected State'));
                  }
                },
              ),
            ),
          ],
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(70),
                side: const BorderSide(color: Colors.grey),
              ),
            ),
            onPressed: () {
              CheckartisanNavigator.push(
                context,
                ArtisanListScreen(
                  title: tradeType.name,
                  artisanType: tradeType.name,
                ),
              );
            },
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl:
                      'https://checkartisan.com/images/${tradeType.tradeSrc}',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 40),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                    child: Text(tradeType.name,
                        style: const TextStyle(fontSize: 16))),
              ],
            ),
          ),
        );
      },
    );
  }
}
