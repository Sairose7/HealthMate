import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:health_mate/core/services/sensor_service.dart';
import 'package:health_mate/data/repositories/steps_repository.dart';
import 'package:health_mate/data/repositories/hydration_repository.dart';
import 'package:health_mate/data/repositories/sleep_repository.dart';
import 'package:health_mate/data/repositories/user_repository.dart';
import 'package:health_mate/data/repositories/consent_repository.dart';
import 'package:health_mate/data/repositories/badges_repository.dart';
import 'package:health_mate/data/repositories/goals_repository.dart';
import 'package:health_mate/presentation/viewmodels/steps_viewmodel.dart';
import 'package:health_mate/presentation/viewmodels/hydration_viewmodel.dart';
import 'package:health_mate/presentation/viewmodels/sleep_viewmodel.dart';
import 'package:health_mate/presentation/viewmodels/badges_viewmodel.dart';
import 'package:health_mate/presentation/screens/home_screen.dart';
import 'package:health_mate/presentation/screens/welcome_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:health_mate/data/services/firestore_service.dart';
import 'package:health_mate/data/services/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const HealthMateApp());
}

class HealthMateApp extends StatelessWidget {
  const HealthMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SensorService>(create: (_) => SensorService()),
        Provider<StepsRepository>(create: (_) => StepsRepository()),
        Provider<HydrationRepository>(create: (_) => HydrationRepository()),
        Provider<SleepRepository>(create: (_) => SleepRepository()),
        Provider<UserRepository>(create: (_) => UserRepository()),
        Provider<GoalsRepository>(create: (_) => GoalsRepository()), // Add GoalsRepository
        ProxyProvider<UserRepository, ConsentRepository>(
          update: (context, userRepository, previous) => ConsentRepository(userRepository),
        ),
        Provider<BadgesRepository>(create: (_) => BadgesRepository()),
        Provider<FirestoreService>(create: (_) => FirestoreService()),

        ProxyProvider5<StepsRepository, HydrationRepository, SleepRepository, FirestoreService, UserRepository, SyncService>(
          update: (context, steps, hydration, sleep, firestore, userRepository, previous) =>
              SyncService(steps, hydration, sleep, firestore, userRepository),
        ),

        ChangeNotifierProvider<BadgesViewModel>(
          create: (context) => BadgesViewModel(repository: context.read<BadgesRepository>()),
        ),
        
        ChangeNotifierProxyProvider6<StepsRepository, SensorService, ConsentRepository, BadgesViewModel, UserRepository, GoalsRepository, StepsViewModel>(
          create: (context) => StepsViewModel(
            repository: context.read<StepsRepository>(),
            sensorService: context.read<SensorService>(),
            consentRepository: context.read<ConsentRepository>(),
            badgesViewModel: context.read<BadgesViewModel>(),
            userRepository: context.read<UserRepository>(),
            goalsRepository: context.read<GoalsRepository>(),
          ),
          update: (context, repository, sensorService, consentRepository, badgesViewModel, userRepository, goalsRepository, previous) =>
              previous ?? 
              StepsViewModel(
                repository: repository, 
                sensorService: sensorService,
                consentRepository: consentRepository,
                badgesViewModel: badgesViewModel,
                userRepository: userRepository,
                goalsRepository: goalsRepository,
              ),
        ),
        ChangeNotifierProxyProvider4<HydrationRepository, BadgesViewModel, UserRepository, GoalsRepository, HydrationViewModel>(
          create: (context) => HydrationViewModel(
            repository: context.read<HydrationRepository>(),
            badgesViewModel: context.read<BadgesViewModel>(),
            userRepository: context.read<UserRepository>(),
            goalsRepository: context.read<GoalsRepository>(),
          ),
          update: (context, repository, badgesViewModel, userRepository, goalsRepository, previous) =>
              previous ?? HydrationViewModel(
                repository: repository, 
                badgesViewModel: badgesViewModel,
                userRepository: userRepository,
                goalsRepository: goalsRepository,
              ),
        ),
        ChangeNotifierProxyProvider4<SleepRepository, BadgesViewModel, UserRepository, GoalsRepository, SleepViewModel>(
          create: (context) => SleepViewModel(
            repository: context.read<SleepRepository>(),
            badgesViewModel: context.read<BadgesViewModel>(),
            userRepository: context.read<UserRepository>(),
            goalsRepository: context.read<GoalsRepository>(),
          ),
          update: (context, repository, badgesViewModel, userRepository, goalsRepository, previous) =>
              previous ?? SleepViewModel(
                repository: repository, 
                badgesViewModel: badgesViewModel,
                userRepository: userRepository,
                goalsRepository: goalsRepository,
              ),
        ),
      ],
      child: MaterialApp(
        title: 'HealthMate',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6A1B9A)), // Nebula Purple
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool? _isOnboardingComplete;

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
    // Trigger sync on app start
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SyncService>().syncData();
    });
  }

  Future<void> _checkOnboarding() async {
    final consentRepo = context.read<ConsentRepository>();
    final completed = await consentRepo.hasCompletedOnboarding();
    setState(() {
      _isOnboardingComplete = completed;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isOnboardingComplete == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return _isOnboardingComplete! ? HomeScreen() : WelcomeScreen();
  }
}
