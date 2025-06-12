import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:arabic_mmorpg/core/rtl/rtl_text_widget.dart';

class GameHUD extends ConsumerWidget {
  const GameHUD({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        // شريط الصحة والطاقة
        Positioned(
          top: 16,
          left: 16,
          child: _buildHealthAndManaBar(),
        ),
        
        // معلومات المستوى والخبرة
        Positioned(
          top: 16,
          right: 16,
          child: _buildLevelInfo(),
        ),
        
        // الخريطة المصغرة
        Positioned(
          bottom: 16,
          right: 16,
          child: _buildMinimap(),
        ),
        
        // أزرار المهارات
        Positioned(
          bottom: 16,
          left: 16,
          right: 200,
          child: _buildSkillBar(),
        ),
        
        // زر القائمة
        Positioned(
          top: 16,
          left: 200,
          child: _buildMenuButton(),
        ),
      ],
    );
  }

  Widget _buildHealthAndManaBar() {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // شريط الصحة
          const RTLText(
            'الصحة: 100/100',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: 1.0,
            backgroundColor: Colors.red[900],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            minHeight: 10,
          ),
          const SizedBox(height: 8),
          
          // شريط الطاقة السحرية
          const RTLText(
            'الطاقة السحرية: 50/50',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: 1.0,
            backgroundColor: Colors.blue[900],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            minHeight: 10,
          ),
          const SizedBox(height: 8),
          
          // شريط القدرة
          const RTLText(
            'القدرة: 100/100',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: 1.0,
            backgroundColor: Colors.green[900],
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            minHeight: 10,
          ),
        ],
      ),
    );
  }

  Widget _buildLevelInfo() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const RTLText(
            'المستوى: 10',
            style: TextStyle(
              color: Colors.amber,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          const RTLText(
            'الخبرة: 1500/2000',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 150,
            child: LinearProgressIndicator(
              value: 0.75,
              backgroundColor: Colors.purple[900],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMinimap() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.amber,
          width: 2,
        ),
      ),
      child: const Center(
        child: Text(
          'الخريطة',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSkillBar() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          8,
          (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: _buildSkillButton(index),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillButton(int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.amber,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '${index + 1}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.menu,
          color: Colors.white,
          size: 28,
        ),
        onPressed: () {
          // فتح قائمة اللعبة
        },
      ),
    );
  }
}