import 'package:check_artisan/profile/notification.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Job {
  final String title;
  final String location;
  final String status;
  final DateTime postedDate;

  Job({
    required this.title,
    required this.location,
    required this.status,
    required this.postedDate,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      title: json['title'],
      location: json['location'],
      status: json['status'],
      postedDate: DateTime.parse(json['postedDate']),
    );
  }
}

abstract class JobEvent extends Equatable {
  const JobEvent();

  @override
  List<Object> get props => [];
}

class FetchJobs extends JobEvent {}

abstract class JobState extends Equatable {
  const JobState();

  @override
  List<Object> get props => [];
}

class JobInitial extends JobState {}

class JobLoading extends JobState {}

class JobLoaded extends JobState {
  final List<Job> jobs;

  const JobLoaded(this.jobs);

  @override
  List<Object> get props => [jobs];
}

class JobError extends JobState {
  final String error;

  const JobError(this.error);

  @override
  List<Object> get props => [error];
}

class JobBloc extends Bloc<JobEvent, JobState> {
  final bool useApi;

  JobBloc({this.useApi = true}) : super(JobInitial()) {
    on<FetchJobs>(_onFetchJobs);
  }

  Future<void> _onFetchJobs(FetchJobs event, Emitter<JobState> emit) async {
    emit(JobLoading());

    try {
      if (useApi) {
        final response = await http.get(Uri.parse(''));

        if (response.statusCode == 200) {
          final List<dynamic> jobJson = jsonDecode(response.body);
          final jobs = jobJson.map((json) => Job.fromJson(json)).toList();
          emit(JobLoaded(jobs));
        } else {
          emit(const JobError('Failed to fetch jobs from API'));
        }
      } else {
        await Future.delayed(const Duration(seconds: 1));
        final jobs = List<Job>.generate(
          6,
          (index) => Job(
            title: 'Wedding Planner',
            location: index % 2 == 0
                ? 'Abuja'
                : index % 3 == 0
                    ? 'Umuahia'
                    : 'Owerri',
            status: index % 2 == 0 ? 'Job Completed' : 'Awaiting Quotes',
            postedDate: DateTime.now(),
          ),
        );
        emit(JobLoaded(jobs));
      }
    } catch (e) {
      emit(JobError(e.toString()));
    }
  }
}

class JobListScreen extends StatelessWidget {
  const JobListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JobBloc(useApi: false)..add(FetchJobs()),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF004D40)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.notifications,
                color: Color(0xFF004D40),
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ArtisanScreen()));
              },
            ),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'Job List',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat-SemiBold.ttf'),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon:
                      const Icon(Icons.search, color: Color(0xFF004D40)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
            Expanded(
              child: BlocBuilder<JobBloc, JobState>(
                builder: (context, state) {
                  if (state is JobLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is JobLoaded) {
                    return ListView.separated(
                      itemCount: state.jobs.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final job = state.jobs[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Job Title: ${job.title}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text('Location: ${job.location}'),
                              const SizedBox(height: 4),
                              Text(
                                'Status: ${job.status}',
                                style: TextStyle(
                                  color: job.status == 'Job Completed'
                                      ? const Color(0xFF004D40)
                                      : Colors.red,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                  'Posted Date: ${job.postedDate.toIso8601String()}'),
                            ],
                          ),
                        );
                      },
                    );
                  } else if (state is JobError) {
                    return const Center(child: Text('Failed to fetch jobs'));
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
