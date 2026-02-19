import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../services/api_service.dart';
import '../../theme.dart';
import '../../widgets/common/nurture_button.dart';

// ── Step metadata ────────────────────────────────────────────

const _steps = [
  _StepMeta(
    icon: Icons.person_outline_rounded,
    title: 'Basic Information',
    subtitle: 'Tell us a little about yourself',
    color: NurtureColors.primaryPink,
  ),
  _StepMeta(
    icon: Icons.monitor_weight_outlined,
    title: 'Clinical Baseline',
    subtitle: 'Optional — helps NurtureAI personalise your plan',
    color: NurtureColors.secondaryBlue,
  ),
  _StepMeta(
    icon: Icons.health_and_safety_outlined,
    title: 'Health Conditions',
    subtitle: 'Select any pre-existing conditions',
    color: NurtureColors.successGreen,
  ),
];

class _StepMeta {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _StepMeta({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}

// ── Screen ───────────────────────────────────────────────────

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentStep = 0;
  bool _isSubmitting = false;

  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  DateTime? _lmpDate;
  final List<String> _selectedConditions = [];

  final _conditions = [
    'Hypertension',
    'Diabetes (Type 1)',
    'Diabetes (Type 2)',
    'Gestational Diabetes',
    'Thyroid Disorder',
    'Anemia',
    'None',
  ];

  void _nextPage() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _prevPage() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  Future<void> _submit() async {
    final age = int.tryParse(_ageController.text);
    if (age == null || age < 10 || age > 60) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid age (10–60)'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final api = ref.read(apiServiceProvider);

      await api.submitOnboarding(
        age: age,
        prePregnancyWeight:
            double.tryParse(_weightController.text),
        lmpDate: _lmpDate,
        conditions: _selectedConditions.isNotEmpty
            ? _selectedConditions.join(',')
            : null,
      );

      ref.read(authServiceProvider.notifier).markOnboarded();

      if (mounted) context.go('/');
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          DateTime.now().subtract(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => _lmpDate = picked);
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authServiceProvider);

    return Scaffold(
      backgroundColor: NurtureColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${authState.fullName ?? 'there'} 👋',
                    style: GoogleFonts.nunito(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color:
                          NurtureColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Let’s build your personalised health profile.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color:
                          NurtureColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children:
                        List.generate(3, (i) {
                      final active =
                          i <= _currentStep;
                      return Expanded(
                        child: Container(
                          height: 6,
                          margin:
                              const EdgeInsets.symmetric(
                                  horizontal: 3),
                          decoration: BoxDecoration(
                            color: active
                                ? NurtureColors
                                    .pinkAccent
                                : const Color(
                                    0xFFEEE0EC),
                            borderRadius:
                                BorderRadius
                                    .circular(3),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics:
                    const NeverScrollableScrollPhysics(),
                children: [
                  _buildDemographicsStep(),
                  _buildClinicalStep(),
                  _buildConditionsStep(),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                      24, 0, 24, 24),
              child: Row(
                children: [
                  if (_currentStep > 0) ...[
                    Expanded(
                      child: NurtureButton(
                        label: 'Back',
                        outlined: true,
                        onPressed: _prevPage,
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: NurtureButton(
                      label: _currentStep < 2
                          ? 'Continue'
                          : 'Get Started',
                      isLoading: _isSubmitting,
                      onPressed: _isSubmitting
                          ? null
                          : (_currentStep < 2
                              ? _nextPage
                              : _submit),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDemographicsStep() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 24),
      child: TextField(
        controller: _ageController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Age',
          prefixIcon:
              Icon(Icons.cake_outlined),
        ),
      ),
    );
  }

  Widget _buildClinicalStep() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          TextField(
            controller: _weightController,
            keyboardType:
                TextInputType.number,
            decoration:
                const InputDecoration(
              labelText:
                  'Pre-pregnancy weight (kg)',
              prefixIcon: Icon(
                  Icons.monitor_weight_outlined),
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding:
                  const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                    color:
                        NurtureColors.border),
                borderRadius:
                    BorderRadius.circular(
                        12),
              ),
              child: Row(
                children: [
                  const Icon(Icons
                      .calendar_today_outlined),
                  const SizedBox(width: 12),
                  Text(
                    _lmpDate != null
                        ? '${_lmpDate!.day}/${_lmpDate!.month}/${_lmpDate!.year}'
                        : 'Tap to select date',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionsStep() {
    return ListView(
      padding:
          const EdgeInsets.symmetric(
              horizontal: 24),
      children: _conditions.map((c) {
        final selected =
            _selectedConditions.contains(c);
        return CheckboxListTile(
          value: selected,
          onChanged: (val) {
            setState(() {
              if (c == 'None') {
                _selectedConditions
                    .clear();
                if (val == true) {
                  _selectedConditions
                      .add('None');
                }
              } else {
                _selectedConditions
                    .remove('None');
                if (val == true) {
                  _selectedConditions
                      .add(c);
                } else {
                  _selectedConditions
                      .remove(c);
                }
              }
            });
          },
          title: Text(c),
        );
      }).toList(),
    );
  }
}
