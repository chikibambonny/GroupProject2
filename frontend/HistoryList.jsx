import React from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { History, MessageSquare, Camera } from 'lucide-react';
import { format } from 'date-fns';
import { motion } from 'framer-motion';

export default function HistoryList({ translations }) {
  if (!translations || translations.length === 0) {
    return (
      <Card className="shadow-md">
        <CardContent className="p-8 text-center">
          <History className="w-12 h-12 mx-auto text-slate-300 mb-3" />
          <p className="text-slate-500">אין היסטוריית תרגומים עדיין</p>
        </CardContent>
      </Card>
    );
  }

  return (
    <Card className="shadow-lg">
      <CardHeader className="bg-gradient-to-r from-slate-50 to-slate-100">
        <CardTitle className="flex items-center gap-2">
          <History className="w-5 h-5 text-slate-600" />
          היסטוריית תרגומים
        </CardTitle>
      </CardHeader>
      <CardContent className="p-4">
        <div className="space-y-3">
          {translations.map((translation, index) => (
            <motion.div
              key={translation.id}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.05 }}
              className="p-4 bg-white border border-slate-200 rounded-lg hover:shadow-md transition-shadow"
            >
              <div className="flex items-start justify-between gap-3 mb-2">
                <div className="flex items-center gap-2">
                  {translation.translation_type === 'text_to_sign' ? (
                    <MessageSquare className="w-4 h-4 text-cyan-600" />
                  ) : (
                    <Camera className="w-4 h-4 text-orange-600" />
                  )}
                  <Badge
                    variant="secondary"
                    className={translation.translation_type === 'text_to_sign' 
                      ? 'bg-cyan-100 text-cyan-700' 
                      : 'bg-orange-100 text-orange-700'}
                  >
                    {translation.translation_type === 'text_to_sign' ? 'טקסט→סימנים' : 'סימנים→טקסט'}
                  </Badge>
                </div>
                <span className="text-xs text-slate-500">
                  {format(new Date(translation.created_date), 'dd/MM/yyyy HH:mm')}
                </span>
              </div>
              <p className="text-slate-700 font-medium line-clamp-2" dir="rtl">
                {translation.source_text}
              </p>
              {translation.image_url && (
                <img
                  src={translation.image_url}
                  alt="Sign"
                  className="mt-2 max-h-32 rounded border border-slate-200"
                />
              )}
            </motion.div>
          ))}
        </div>
      </CardContent>
    </Card>
  );
}