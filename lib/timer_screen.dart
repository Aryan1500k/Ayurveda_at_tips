import 'dart:async';
import 'package:flutter/material.dart';
import 'activity_complete_screen.dart';

// 1. Definition of the data model
class WellnessBreak {
  final String title;
  final int durationMinutes;

  WellnessBreak({required this.title, required this.durationMinutes});
}

// 2. Definition of the Screen
class TimerScreen extends StatefulWidget {
  final WellnessBreak breakItem;
  const TimerScreen({super.key, required this.breakItem});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late int _secondsRemaining;
  Timer? _timer;
  bool _isPaused = false;
  final Color themeBrown = const Color(0xFF8B6B23); // Consistent brown theme

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.breakItem.durationMinutes * 60;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0 && !_isPaused) {
        setState(() => _secondsRemaining--);
      } else if (_secondsRemaining == 0) {
        _timer?.cancel();
        _navigateToComplete();
      }
    });
  }

  void _navigateToComplete() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ActivityCompleteScreen(
          title: widget.breakItem.title,
          minutes: widget.breakItem.durationMinutes,
        ),
      ),
    );
  }

  String _formatTime(int seconds) {
    int mins = seconds ~/ 60;
    int secs = seconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9F4),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.breakItem.title,
                  style: TextStyle(
                      fontFamily: 'Trajan Pro',
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: themeBrown
                  )),
              const SizedBox(height: 8),
              const Text("Follow along and take your time", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              Text(_formatTime(_secondsRemaining),
                  style: TextStyle(fontSize: 70, fontWeight: FontWeight.w200, color: themeBrown)),
              const Text("Time remaining", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _navigateToComplete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeBrown,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: Text(
                    _secondsRemaining == 0 ? "Activity Complete — Finish" : "Finish Now",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => setState(() => _isPaused = !_isPaused),
                    child: Text(_isPaused ? "Resume" : "Pause",
                        style: TextStyle(color: themeBrown, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () => setState(() => _secondsRemaining = widget.breakItem.durationMinutes * 60),
                    child: const Text("Reset", style: TextStyle(color: Colors.grey)),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}