import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'activity_complete_screen.dart';

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

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.breakItem.durationMinutes * 60;
    _startTimer();
  }

  // LOGIC 1: Automatic Navigation when timer hits 0
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0 && !_isPaused) {
        setState(() => _secondsRemaining--);
      } else if (_secondsRemaining == 0) {
        _timer?.cancel();
        _navigateToComplete(); // Trigger navigation automatically
      }
    });
  }

  // Helper method for navigation
  void _navigateToComplete() {
    // We use pushReplacement so the user can't "Go Back" to a finished timer
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
      backgroundColor: const Color(0xFFF5F1E9),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.breakItem.title,
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1B4332))),
              const SizedBox(height: 8),
              const Text("Follow along and take your time", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              Text(_formatTime(_secondsRemaining),
                  style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w300, color: Color(0xFFC9A227))),
              const Text("Time remaining", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),

              // LOGIC 2: Manual Navigation when "Finish Now" is clicked
              ElevatedButton(
                onPressed: _navigateToComplete, // Go to completion UI immediately
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC9A227),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(
                    _secondsRemaining == 0 ? "Activity Complete — Finish" : "Finish Now",
                    style: const TextStyle(color: Color(0xFF1B4332), fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => setState(() => _isPaused = !_isPaused),
                    child: Text(_isPaused ? "Resume" : "Pause", style: const TextStyle(color: Colors.black)),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () => setState(() => _secondsRemaining = widget.breakItem.durationMinutes * 60),
                    child: const Text("Reset", style: TextStyle(color: Colors.black)),
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