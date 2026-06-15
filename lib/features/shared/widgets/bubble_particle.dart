import 'dart:math';
import 'package:flutter/material.dart';

class BubbleParticle {
  Offset position;
  Offset velocity;
  double radius;
  double opacity;

  BubbleParticle({
    required this.position,
    required this.velocity,
    required this.radius,
    required this.opacity,
  });
}

class BubbleField extends StatefulWidget {
  final int particleCount;

  const BubbleField({super.key, this.particleCount = 25});

  @override
  State<BubbleField> createState() => _BubbleFieldState();
}

class _BubbleFieldState extends State<BubbleField>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<BubbleParticle> _particles = [];
  final Random _random = Random();
  Size _size = Size.zero;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(days: 1),
    )..addListener(_tick);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _generateParticles() {
    _particles.clear();
    for (int i = 0; i < widget.particleCount; i++) {
      final radius = _random.nextDouble() * 50 + 15;
      final x = radius + _random.nextDouble() * (_size.width - radius * 2);
      final y = radius + _random.nextDouble() * (_size.height - radius * 2);

      _particles.add(
        BubbleParticle(
          position: Offset(x, y),
          velocity: Offset(
            (_random.nextDouble() - 0.5) * 1.5,
            (_random.nextDouble() - 0.5) * 1.5,
          ),
          radius: radius,
          opacity: _random.nextDouble() * 0.08 + 0.03,
        ),
      );
    }
  }

  void _tick() {
    if (_size == Size.zero) return;
    if (!mounted) return;

    for (final p in _particles) {
      p.position += p.velocity;

      if (p.position.dx - p.radius <= 0) {
        p.position = Offset(p.radius, p.position.dy);
        p.velocity = Offset(p.velocity.dx.abs(), p.velocity.dy);
      } else if (p.position.dx + p.radius >= _size.width) {
        p.position = Offset(_size.width - p.radius, p.position.dy);
        p.velocity = Offset(-p.velocity.dx.abs(), p.velocity.dy);
      }

      if (p.position.dy - p.radius <= 0) {
        p.position = Offset(p.position.dx, p.radius);
        p.velocity = Offset(p.velocity.dx, p.velocity.dy.abs());
      } else if (p.position.dy + p.radius >= _size.height) {
        p.position = Offset(p.position.dx, _size.height - p.radius);
        p.velocity = Offset(p.velocity.dx, -p.velocity.dy.abs());
      }
    }

    for (int i = 0; i < _particles.length; i++) {
      for (int j = i + 1; j < _particles.length; j++) {
        final p1 = _particles[i];
        final p2 = _particles[j];

        final delta = p1.position - p2.position;
        final dist = delta.distance;
        final minDist = p1.radius + p2.radius;

        if (dist < minDist) {
          final overlap = minDist - dist;
          final normal = dist > 0 ? (delta / dist) : const Offset(1, 0);
          final pushVector = normal * (overlap / 2.0);

          p1.position += pushVector;
          p2.position -= pushVector;

          final relVel = p1.velocity - p2.velocity;
          final speedAlongNormal =
              relVel.dx * normal.dx + relVel.dy * normal.dy;

          if (speedAlongNormal < 0) {
            final bounceVector = normal * speedAlongNormal;
            p1.velocity -= bounceVector;
            p2.velocity += bounceVector;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final newSize = Size(constraints.maxWidth, constraints.maxHeight);

        if (_size == Size.zero && newSize.width > 0) {
          _size = newSize;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _generateParticles();
              _controller.repeat();
            }
          });
        } else {
          _size = newSize;
        }

        final colorScheme = Theme.of(context).colorScheme;

        return RepaintBoundary(
          child: CustomPaint(
            size: _size,
            painter: BubblePainter(
              particles: _particles,
              color: colorScheme.primary,
              repaint: _controller,
            ),
          ),
        );
      },
    );
  }
}

class BubblePainter extends CustomPainter {
  final List<BubbleParticle> particles;
  final Color color;

  BubblePainter({
    required this.particles,
    required this.color,
    required Listenable repaint,
  }) : super(repaint: repaint);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final p in particles) {
      paint.color = color.withValues(alpha: p.opacity);
      canvas.drawCircle(p.position, p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant BubblePainter oldDelegate) => false;
}
