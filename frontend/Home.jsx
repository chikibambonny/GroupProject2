import React, { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { base44 } from '@/api/base44Client';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { HandMetal } from 'lucide-react';
import ModeSelector from '../components/translation/ModeSelector';
import TextToSign from '../components/translation/TextToSign';
import SignToText from '../components/translation/SignToText';
import HistoryList from '../components/translation/HistoryList';

export default function Home() {
  const [selectedMode, setSelectedMode] = useState('text_to_sign');
  const [activeTab, setActiveTab] = useState('translate');

  const { data: translations, refetch } = useQuery({
    queryKey: ['translations'],
    queryFn: () => base44.entities.Translation.list('-created_date', 20),
    initialData: []
  });

  const handleTranslationComplete = () => {
    refetch();
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-cyan-50" dir="rtl">
      <div className="container mx-auto px-4 py-8 max-w-4xl">
        {/* Header */}
        <div className="text-center mb-8">
          <div className="flex items-center justify-center gap-3 mb-3">
            <HandMetal className="w-12 h-12 text-cyan-600" />
            <h1 className="text-4xl font-bold bg-gradient-to-l from-cyan-600 to-blue-600 bg-clip-text text-transparent">
              מתרגם שפת סימנים ישראלית
            </h1>
          </div>
          <p className="text-slate-600 text-lg">
            תרגום דו-כיווני בין עברית לשפת סימנים ישראלית (ISL)
          </p>
        </div>

        {/* Main Content */}
        <Tabs value={activeTab} onValueChange={setActiveTab} className="space-y-6">
          <TabsList className="grid w-full grid-cols-2 bg-white shadow-md">
            <TabsTrigger value="translate" className="text-base">
              תרגום
            </TabsTrigger>
            <TabsTrigger value="history" className="text-base">
              היסטוריה
            </TabsTrigger>
          </TabsList>

          <TabsContent value="translate" className="space-y-6">
            <ModeSelector 
              selectedMode={selectedMode} 
              onModeChange={setSelectedMode}
            />

            {selectedMode === 'text_to_sign' ? (
              <TextToSign onTranslationComplete={handleTranslationComplete} />
            ) : (
              <SignToText onTranslationComplete={handleTranslationComplete} />
            )}
          </TabsContent>

          <TabsContent value="history">
            <HistoryList translations={translations} />
          </TabsContent>
        </Tabs>

        {/* Footer Note */}
        <div className="mt-12 p-4 bg-white/80 backdrop-blur-sm rounded-lg border border-slate-200 text-center">
          <p className="text-sm text-slate-600">
            🚀 <strong>פרוטוטייפ</strong> - אפליקציה זו משתמשת בבינה מלאכותית לתרגום בסיסי.
            <br />
            לתוצאות מדויקות יותר, יש לשלב עם מילון ומסד נתונים של שפת סימנים ישראלית.
          </p>
        </div>
      </div>
    </div>
  );
}