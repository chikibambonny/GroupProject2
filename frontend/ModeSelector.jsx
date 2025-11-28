import React from 'react';
import { Button } from '@/components/ui/button';
import { Card } from '@/components/ui/card';
import { MessageSquare, Camera } from 'lucide-react';
import { motion } from 'framer-motion';

export default function ModeSelector({ selectedMode, onModeChange }) {
  return (
    <div className="grid grid-cols-2 gap-4 mb-6">
      <motion.div
        whileHover={{ scale: 1.02 }}
        whileTap={{ scale: 0.98 }}
      >
        <Card
          className={`p-6 cursor-pointer transition-all ${
            selectedMode === 'text_to_sign'
              ? 'bg-gradient-to-br from-cyan-500 to-blue-600 text-white shadow-lg'
              : 'bg-white hover:shadow-md'
          }`}
          onClick={() => onModeChange('text_to_sign')}
        >
          <div className="flex flex-col items-center gap-3">
            <MessageSquare className="w-12 h-12" />
            <div className="text-center">
              <h3 className="font-bold text-lg">טקסט לסימנים</h3>
              <p className={`text-sm mt-1 ${selectedMode === 'text_to_sign' ? 'text-white/90' : 'text-slate-600'}`}>
                תרגם עברית לשפת סימנים
              </p>
            </div>
          </div>
        </Card>
      </motion.div>

      <motion.div
        whileHover={{ scale: 1.02 }}
        whileTap={{ scale: 0.98 }}
      >
        <Card
          className={`p-6 cursor-pointer transition-all ${
            selectedMode === 'sign_to_text'
              ? 'bg-gradient-to-br from-orange-500 to-pink-600 text-white shadow-lg'
              : 'bg-white hover:shadow-md'
          }`}
          onClick={() => onModeChange('sign_to_text')}
        >
          <div className="flex flex-col items-center gap-3">
            <Camera className="w-12 h-12" />
            <div className="text-center">
              <h3 className="font-bold text-lg">סימנים לטקסט</h3>
              <p className={`text-sm mt-1 ${selectedMode === 'sign_to_text' ? 'text-white/90' : 'text-slate-600'}`}>
                תרגם שפת סימנים לעברית
              </p>
            </div>
          </div>
        </Card>
      </motion.div>
    </div>
  );
}