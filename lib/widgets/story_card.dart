import 'dart:async';
import 'package:flutter/material.dart';
import '../models/story_card_data.dart';

class StoryCard extends StatefulWidget {
  final StoryCardData data;
  final VoidCallback? onTimerFinished;

  const StoryCard({ // initial data for story card
    Key? key,
    required this.data,
    this.onTimerFinished,
  }) : super(key: key);

  @override
  State<StoryCard> createState() => _StoryCardState(); // makes the stateful widget work allowing us to update the UI when the timer finishes and locks the choices
}

class _StoryCardState extends State<StoryCard> { // this state will manage the timer and choice locking for the current story card
  final PageController _controller = PageController();
  static const int _startSeconds = 60;
  int _currentPage = 0;
  late int _secondsLeft;
  Timer? _timer;
  Timer? _postZeroTimer;
  bool _hasNotifiedTimerFinished = false;
  bool _showResultIcon = false;

  int get _totalPages => 1 + widget.data.textPages.length; // total pages is 1 for the image page + number of text pages

  @override
  void initState() { // initState is called when the widget is first created, we use it to start the timer for the card
    super.initState();
    _secondsLeft = _startSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_secondsLeft <= 0) {
        _handleTimerFinished();
        t.cancel();
        return;
      }
      setState(() => _secondsLeft--);
      if (_secondsLeft == 0) {
        _handleTimerFinished();
        t.cancel();
      }
    });
  }

  void _handleTimerFinished() {
    if (!_hasNotifiedTimerFinished) {
      _hasNotifiedTimerFinished = true;
      widget.onTimerFinished?.call(); // notify the parent widget that the timer has finished, so it can lock the choices
    }

    // Keep showing "0" for 5 seconds, then swap to the result icon.
    _postZeroTimer ??= Timer(const Duration(seconds: 5), () {
      if (!mounted) {
        return;
      }
      setState(() => _showResultIcon = true);
    });
  }

  @override
  void dispose() { // dispose is called when the widget is removed from the widget tree, we use it to cancel the timer to prevent memory leaks
    _timer?.cancel();
    _postZeroTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _navigate(int delta) {
    final next = _currentPage + delta; // delta will be -1 for previous and +1 for next, we calculate the next page index by adding delta to the current page index
    if (next >= 0 && next < _totalPages) {
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
            PageView(
              controller: _controller,
              onPageChanged: (i) => setState(() => _currentPage = i),
              children: [
                _buildImagePage(),
                for (final text in widget.data.textPages) _buildTextPage(text),
              ],
            ),
            // Navigation bar overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildNavBar(),
            ),
            // Timer badge
            Positioned(
              top: 10,
              right: 10,
              child: _buildTimerBadge(),
            ),
          ],
      ),
    );
  }

  // page 1: image
  Widget _buildImagePage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          widget.data.imageAsset,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        // Dark gradient
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0x00000000), Color(0xCC000000)],
              stops: [0.35, 1.0],
            ),
          ),
        ),
      ],
    );
  }

  // page 2+: text content
  Widget _buildTextPage(String text) {
    return Container(
      color: const Color(0xFFEAEAEA),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 44),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.data.textTitle,
            style: const TextStyle(
              color: Color(0xFFD4006B),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                text,
                style: const TextStyle(
                  color: Color(0xFF333333),
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // navigation dots + arrows
  Widget _buildNavBar() {
    final onImage = _currentPage == 0;
    final bg = onImage ? Colors.transparent : const Color(0xFFEAEAEA);
    final dotActive = onImage ? Colors.white : const Color(0xFF555555);
    final dotInactive = onImage ? Colors.white38 : const Color(0xFFAAAAAA);
    final arrowColor = onImage ? Colors.white70 : const Color(0xFF777777);

    return Container(
      color: bg,
      height: 38,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () => _navigate(-1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.chevron_left,
                size: 22,
                color: _currentPage > 0 ? arrowColor : Colors.transparent,
              ),
            ),
          ),
          ...List.generate(_totalPages, (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == _currentPage ? dotActive : dotInactive,
            ),
          )),
          GestureDetector(
            onTap: () => _navigate(1),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Icon(
                Icons.chevron_right,
                size: 22,
                color: _currentPage < _totalPages - 1 ? arrowColor : Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // timer badge
  Widget _buildTimerBadge() {
    final Color timerColor;
    if (_showResultIcon) {
      timerColor = const Color(0xFF1A50A0);
    } else if (_secondsLeft <= 0) {
      timerColor = Colors.red;
    } else if (_secondsLeft <= 10) {
      timerColor = const Color(0xFFFF9800);
    } else if (_secondsLeft <= 30) {
      timerColor = const Color(0xFFD4C15A);
    } else {
      timerColor = const Color(0xFF1A50A0);
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: timerColor,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: _showResultIcon
          ? const Icon(
              Icons.assignment,
              color: Colors.white,
              size: 22,
            )
          : Text(
              '$_secondsLeft',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
    );
  }
}