import 'package:check_artisan/profile/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Quote {
  final int id;
  final String budget;
  final String location;

  Quote({
    required this.id,
    required this.budget,
    required this.location,
  });

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      id: json['id'],
      budget: json['budget_amount'],
      location: json['location'] ?? 'Unknown location',
    );
  }
}

abstract class QuoteEvent extends Equatable {
  const QuoteEvent();

  @override
  List<Object> get props => [];
}

class FetchQuotes extends QuoteEvent {}

abstract class QuoteState extends Equatable {
  const QuoteState();

  @override
  List<Object> get props => [];
}

class QuoteInitial extends QuoteState {}

class QuoteLoading extends QuoteState {}

class QuoteLoaded extends QuoteState {
  final List<Quote> quotes;

  const QuoteLoaded(this.quotes);

  @override
  List<Object> get props => [quotes];
}

class QuoteError extends QuoteState {
  final String error;

  const QuoteError(this.error);

  @override
  List<Object> get props => [error];
}

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final bool useApi;

  QuoteBloc({this.useApi = true}) : super(QuoteInitial()) {
    on<FetchQuotes>(_onFetchQuotes);
  }

  Future<void> _onFetchQuotes(
      FetchQuotes event, Emitter<QuoteState> emit) async {
    emit(QuoteLoading());

    try {
      if (useApi) {
        final response = await http
            .get(Uri.parse('https://checkartisan.com/api/get-budgets'));

        if (response.statusCode == 200) {
          final List<dynamic> quoteJson = jsonDecode(response.body);

          final quotes = quoteJson.map((json) => Quote.fromJson(json)).toList();
          emit(QuoteLoaded(quotes));
        } else {
          emit(const QuoteError('Failed to fetch budgets from API'));
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        final quotes = List<Quote>.generate(
          6,
          (index) => Quote(
            id: index,
            budget: 'Under NGN50,000',
            location: 'Umuahia, Abia',
          ),
        );
        emit(QuoteLoaded(quotes));
      }
    } catch (e) {
      emit(QuoteError(e.toString()));
    }
  }
}

class QuoteRequestsScreen extends StatelessWidget {
  const QuoteRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QuoteBloc(useApi: true)..add(FetchQuotes()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Budget Requests',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF004D40)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications, color: Color(0xFF004D40)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ArtisanScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30), // Added padding
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF000000).withOpacity(0.25),
                      blurRadius: 4.0,
                      offset: const Offset(0, 4), // changes position of shadow
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFD6D6D6), width: 1),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onChanged: (value) {
                    // Handle search logic here
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: BlocBuilder<QuoteBloc, QuoteState>(
                builder: (context, state) {
                  if (state is QuoteLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is QuoteLoaded) {
                    return ListView.separated(
                      itemCount: state.quotes.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final quote = state.quotes[index];
                        return ListTile(
                          title: Text(
                            'Budget: ${quote.budget}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Location: ${quote.location}'),
                          trailing: const Icon(
                            Icons.info_outline,
                            color: Color(0xFF004D40),
                          ),
                        );
                      },
                    );
                  } else if (state is QuoteError) {
                    return const Center(child: Text('Failed to fetch budgets'));
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
