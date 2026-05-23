import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:confetti/confetti.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_animations.dart';
import '../../../services/analytics_service.dart';
import '../../../shared/providers/app_providers.dart';
import '../../../shared/widgets/colony_button.dart';
import '../../../shared/widgets/colony_text_field.dart';
import '../../../shared/widgets/animated_blob.dart';
import '../providers/auth_provider.dart';

/// Profile Setup Screen — Multi-step onboarding for new users
class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() =>
      _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final PageController _pageController = PageController();
  late ConfettiController _confettiController;
  int _currentStep = 0;
  final int _totalSteps = 6;

  // Step 1: Name
  final _nameController = TextEditingController();

  // Step 2: Age
  int _selectedAge = 22;
  int _selectedYear = DateTime.now().year - 22;

  // Step 3: Gender & Bio
  String? _selectedGender;
  final _bioController = TextEditingController();

  // Step 4: Photo
  XFile? _selectedPhoto;

  // Step 5: Interests
  final Set<String> _selectedInterests = {};

  // Step 6: Location
  bool _locationGranted = false;

  static const _genderOptions = ['Man', 'Woman', 'Non-binary', 'Prefer not to say'];
  static const _bioPrompts = [
    'Coffee addict ☕',
    'Dog parent 🐕',
    'Startup founder 🚀',
    'Foodie at heart 🍕',
    'Gym rat 💪',
    'Bookworm 📚',
    'Night owl 🦉',
    'Plant parent 🌱',
  ];
  static const _interestOptions = {
    'Music': Icons.music_note,
    'Food': Icons.restaurant,
    'Sports': Icons.sports_soccer,
    'Tech': Icons.computer,
    'Art': Icons.palette,
    'Travel': Icons.flight,
    'Books': Icons.book,
    'Gaming': Icons.sports_esports,
    'Fitness': Icons.fitness_center,
    'Photography': Icons.camera_alt,
    'Movies': Icons.movie,
    'Cooking': Icons.restaurant_menu,
    'Nature': Icons.nature,
    'Fashion': Icons.checkroom,
    'Dance': Icons.directions_run,
    'Yoga': Icons.self_improvement,
    'Pets': Icons.pets,
    'Music Production': Icons.headphones,
    'Coding': Icons.code,
    'Design': Icons.design_services,
  };

  @override
  void initState() {
    super.initState();
    AnalyticsService.trackScreen('profile_setup');
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _pageController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: AppAnimations.normalDuration,
        curve: AppAnimations.smoothCurve,
      );
    } else {
      _completeSetup();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: AppAnimations.normalDuration,
        curve: AppAnimations.smoothCurve,
      );
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0: return _nameController.text.trim().length >= 2;
      case 1: return _selectedAge >= 18;
      case 2: return _selectedGender != null;
      case 3: return true; // Photo is optional
      case 4: return _selectedInterests.length >= 3;
      case 5: return true; // Location is optional
      default: return false;
    }
  }

  void _completeSetup() {
    _confettiController.play();
    HapticFeedback.heavyImpact();

    final dob = DateTime(_selectedYear, 6, 15); // Approximate
    ref.read(authProvider.notifier).setupProfile(
      displayName: _nameController.text.trim(),
      dateOfBirth: dob.toIso8601String().split('T')[0],
      gender: _selectedGender!,
      bio: _bioController.text.trim().isEmpty
          ? null
          : _bioController.text.trim(),
      interests: _selectedInterests.toList(),
    );

    AnalyticsService.trackEvent('profile_setup_complete', properties: {
      'interests_count': _selectedInterests.length,
      'has_photo': _selectedPhoto != null,
      'has_bio': _bioController.text.trim().isNotEmpty,
    });
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(remoteConfigProvider);
    final authState = ref.watch(authProvider);

    // Navigate on success
    ref.listen<AuthState>(authProvider, (prev, next) {
      if (next.status == AuthStatus.authenticated) {
        Future.delayed(const Duration(milliseconds: 2000), () {
          if (context.mounted) context.go('/home');
        });
      }
    });

    final maxBioLength = config.getValue<int>('profile_max_bio_length', fallback: 150);
    final minInterests = config.getValue<int>('interests_min_count', fallback: 3);
    final maxInterests = config.getValue<int>('interests_max_count', fallback: 15);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Stack(
        children: [
          ColonyMeshBackground(
            child: SafeArea(
              child: Column(
                children: [
                  // Progress bar + back
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        if (_currentStep > 0)
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios,
                                color: AppColors.textPrimary, size: 20),
                            onPressed: _prevStep,
                          )
                        else
                          const SizedBox(width: 48),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (_currentStep + 1) / _totalSteps,
                              backgroundColor: AppColors.surfaceMedium,
                              valueColor: const AlwaysStoppedAnimation(
                                  AppColors.colonyPurple),
                              minHeight: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${_currentStep + 1}/$_totalSteps',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),

                  // Page view
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (page) {
                        setState(() => _currentStep = page);
                      },
                      children: [
                        _buildNameStep(),
                        _buildAgeStep(),
                        _buildGenderBioStep(maxBioLength),
                        _buildPhotoStep(),
                        _buildInterestsStep(minInterests, maxInterests),
                        _buildLocationStep(),
                      ],
                    ),
                  ),

                  // Continue button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                    child: ColonyButton(
                      text: _currentStep == _totalSteps - 1
                          ? 'Complete Setup'
                          : 'Continue',
                      onPressed: _canProceed() ? _nextStep : null,
                      isLoading: authState.isLoading,
                    ),
                  ),

                  // Skip button (for optional steps)
                  if (_currentStep == 3 || _currentStep == 4)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: GestureDetector(
                        onTap: _nextStep,
                        child: Text(
                          'Skip for now',
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textMuted,
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                AppColors.colonyPurple,
                AppColors.colonyPink,
                AppColors.colonyBlue,
                AppColors.colonyTeal,
                AppColors.colonyAmber,
              ],
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 1: Name ─────────────────────────────────────────────
  Widget _buildNameStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            "What's your name?",
            style: AppTypography.headlineLarge,
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          Text(
            "This is how others will see you",
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
          const SizedBox(height: 32),
          ColonyTextField(
            controller: _nameController,
            labelText: 'Display Name',
            hintText: 'Your first name',
            autofocus: true,
            textInputAction: TextInputAction.done,
            maxLength: 50,
            onChanged: (_) => setState(() {}),
          ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
          const SizedBox(height: 16),
          Text(
            '${_nameController.text.length}/50 characters',
            style: AppTypography.bodySmall.copyWith(
              color: _nameController.text.length >= 2
                  ? AppColors.colonyTeal
                  : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 2: Age ──────────────────────────────────────────────
  Widget _buildAgeStep() {
    final currentYear = DateTime.now().year;
    final years = List.generate(63, (i) => currentYear - 18 - i);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'How old are you?',
            style: AppTypography.headlineLarge,
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          Text(
            'You must be at least 18',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
          const SizedBox(height: 40),
          Center(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ListWheelScrollView.useDelegate(
                itemExtent: 50,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: (index) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    _selectedYear = years[index];
                    _selectedAge = currentYear - _selectedYear;
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: years.length,
                  builder: (context, index) {
                    final age = currentYear - years[index];
                    final isSelected = years[index] == _selectedYear;
                    return Center(
                      child: Text(
                        '$age years old (${years[index]})',
                        style: AppTypography.titleMedium.copyWith(
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w400,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 200.ms),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Born $_selectedYear · Age $_selectedAge',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 3: Gender & Bio ─────────────────────────────────────
  Widget _buildGenderBioStep(int maxBioLength) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Tell us about you',
            style: AppTypography.headlineLarge,
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 24),

          // Gender selection
          Text(
            'Gender',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _genderOptions.map((gender) {
              final isSelected = _selectedGender == gender;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() => _selectedGender = gender);
                },
                child: AnimatedContainer(
                  duration: AppAnimations.fastDuration,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? AppGradients.primaryGradient
                        : null,
                    color: isSelected ? null : AppColors.surfaceMedium,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isSelected
                          ? Colors.transparent
                          : AppColors.borderDark,
                    ),
                  ),
                  child: Text(
                    gender,
                    style: AppTypography.labelLarge.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ).animate().fadeIn(duration: 500.ms, delay: 200.ms),

          const SizedBox(height: 24),

          // Bio field
          Text(
            'Bio (optional)',
            style: AppTypography.labelLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          ColonyTextField(
            controller: _bioController,
            hintText: 'Write something about yourself...',
            maxLines: 3,
            maxLength: maxBioLength,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),

          // Bio prompt chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _bioPrompts.map((prompt) {
              return GestureDetector(
                onTap: () {
                  final current = _bioController.text;
                  if (current.isEmpty) {
                    _bioController.text = prompt;
                  } else if (current.length + prompt.length + 2 <= maxBioLength) {
                    _bioController.text = '$current $prompt';
                  }
                  _bioController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _bioController.text.length),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Text(
                    prompt,
                    style: AppTypography.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // ─── Step 4: Photo ────────────────────────────────────────────
  Widget _buildPhotoStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          Text(
            'Add your photo',
            style: AppTypography.headlineLarge,
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          Text(
            'Let people recognize you',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
          const SizedBox(height: 48),
          GestureDetector(
            onTap: _showPhotoOptions,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: _selectedPhoto != null
                    ? null
                    : AppGradients.primaryGradient.scale(0.3),
                border: Border.all(
                  color: AppColors.colonyPurple.withValues(alpha: 0.5),
                  width: 3,
                ),
              ),
              child: _selectedPhoto != null
                  ? ClipOval(
                      child: Image.asset(
                        _selectedPhoto!.path,
                        fit: BoxFit.cover,
                        width: 160,
                        height: 160,
                      ),
                    )
                  : const Icon(
                      Icons.camera_alt_outlined,
                      size: 48,
                      color: AppColors.colonyPurple,
                    ),
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 200.ms)
              .scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut),
          const SizedBox(height: 24),
          Text(
            'Tap to add photo',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bgQuaternary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt,
                  color: AppColors.colonyPurple),
              title: Text('Take a selfie',
                  style: AppTypography.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library,
                  color: AppColors.colonyPink),
              title: Text('Choose from gallery',
                  style: AppTypography.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                _pickPhoto(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPhoto(ImageSource source) async {
    final picker = ImagePicker();
    try {
      final photo = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (photo != null) {
        setState(() => _selectedPhoto = photo);
      }
    } catch (e) {
      AnalyticsService.trackError('photo_pick_failed', properties: {'error': e.toString()});
    }
  }

  // ─── Step 5: Interests ────────────────────────────────────────
  Widget _buildInterestsStep(int minInterests, int maxInterests) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Pick your interests',
            style: AppTypography.headlineLarge,
          ).animate().fadeIn(duration: 400.ms),
          const SizedBox(height: 8),
          Text(
            'Choose at least $minInterests (up to $maxInterests)',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 100.ms),
          const SizedBox(height: 8),
          Text(
            '${_selectedInterests.length} selected',
            style: AppTypography.bodySmall.copyWith(
              color: _selectedInterests.length >= minInterests
                  ? AppColors.colonyTeal
                  : AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children:
                    _interestOptions.entries.toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final interest = entry.value;
                  final isSelected = _selectedInterests.contains(interest.key);

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        if (isSelected) {
                          _selectedInterests.remove(interest.key);
                        } else if (_selectedInterests.length < maxInterests) {
                          _selectedInterests.add(interest.key);
                        }
                      });
                    },
                    child: AnimatedContainer(
                      duration: AppAnimations.fastDuration,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient:
                            isSelected ? AppGradients.primaryGradient : null,
                        color:
                            isSelected ? null : AppColors.surfaceMedium,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.transparent
                              : AppColors.borderDark,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            interest.value,
                            size: 18,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textMuted,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            interest.key,
                            style: AppTypography.labelLarge.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate(delay: Duration(milliseconds: 30 * index))
                      .fadeIn(duration: 300.ms)
                      .scale(
                          begin: const Offset(0.9, 0.9),
                          curve: Curves.elasticOut);
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 6: Location ─────────────────────────────────────────
  Widget _buildLocationStep() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.colonyTeal.withValues(alpha: 0.2),
                  AppColors.colonyBlue.withValues(alpha: 0.2),
                ],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.colonyTeal.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.location_on,
              size: 64,
              color: AppColors.colonyTeal,
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .scale(begin: const Offset(0.8, 0.8), curve: Curves.elasticOut),
          const SizedBox(height: 32),
          Text(
            'Colony needs your location',
            style: AppTypography.headlineLarge,
            textAlign: TextAlign.center,
          ).animate().fadeIn(duration: 400.ms, delay: 200.ms),
          const SizedBox(height: 16),
          Text(
            'To show you people, places, and events\naround your neighborhood',
            textAlign: TextAlign.center,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ).animate().fadeIn(duration: 400.ms, delay: 300.ms),
          const SizedBox(height: 40),
          ColonyButton(
            text: _locationGranted ? 'Location Granted!' : 'Allow Location',
            icon: _locationGranted ? Icons.check_circle : Icons.my_location,
            onPressed: _locationGranted
                ? null
                : () async {
                    final status = await Permission.location.request();
                    if (status.isGranted) {
                      setState(() => _locationGranted = true);
                      HapticFeedback.lightImpact();
                    }
                  },
            type: _locationGranted
                ? ColonyButtonType.secondary
                : ColonyButtonType.primary,
          )
              .animate()
              .fadeIn(duration: 500.ms, delay: 400.ms),
          if (!_locationGranted) ...[
            const SizedBox(height: 16),
            Text(
              'You can always change this in Settings',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ],
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
