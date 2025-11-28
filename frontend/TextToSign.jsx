import React, { useState } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Textarea } from '@/components/ui/textarea';
import { Button } from '@/components/ui/button';
import { Loader2, Languages } from 'lucide-react';
import { base44 } from '@/api/base44Client';
import { motion, AnimatePresence } from 'framer-motion';

export default function TextToSign({ onTranslationComplete }) {
  const [hebrewText, setHebrewText] = useState('');
  const [isTranslating, setIsTranslating] = useState(false);
  const [signInstructions, setSignInstructions] = useState(null);

  const handleTranslate = async () => {
    if (!hebrewText.trim()) return;

    setIsTranslating(true);
    try {
      const result = await base44.integrations.Core.InvokeLLM({
        prompt: `אתה מומחה לשפת הסימנים הישראלית (ISL - Israeli Sign Language). 
        
תרגם את הטקסט הבא לשפת סימנים ישראלית והסבר בפירוט כיצד לבצע כל סימן:
"${hebrewText}"

חשוב:
- פרק את המשפט למילים בודדות או ביטויים
- לכל מילה/ביטוי, תן הוראות מפורטות כיצד לבצע את הסימן
- כלול את תנועות הידיים, מיקום הידיים, הבעות הפנים
- אם יש סימן ספציפי ידוע בשפת הסימנים הישראלית, ציין זאת

השב בפורמט JSON עם המבנה הבא:
{
  "original_text": "הטקסט המקורי",
  "signs": [
    {
      "word": "המילה",
      "instruction": "הוראות מפורטות לביצוע הסימן",
      "hand_shape": "צורת היד",
      "location": "מיקום ביחס לגוף",
      "movement": "תנועה",
      "facial_expression": "הבעת פנים (אם רלוונטי)"
    }
  ],
  "notes": "הערות נוספות כלליות"
}`,
        response_json_schema: {
          type: "object",
          properties: {
            original_text: { type: "string" },
            signs: {
              type: "array",
              items: {
                type: "object",
                properties: {
                  word: { type: "string" },
                  instruction: { type: "string" },
                  hand_shape: { type: "string" },
                  location: { type: "string" },
                  movement: { type: "string" },
                  facial_expression: { type: "string" }
                }
              }
            },
            notes: { type: "string" }
          }
        }
      });

      setSignInstructions(result);

      // Save to history
      await base44.entities.Translation.create({
        source_text: hebrewText,
        target_description: JSON.stringify(result),
        translation_type: 'text_to_sign'
      });

      if (onTranslationComplete) {
        onTranslationComplete();
      }
    } catch (error) {
      console.error('Translation error:', error);
    } finally {
      setIsTranslating(false);
    }
  };

  return (
    <div className="space-y-6">
      <Card className="shadow-lg">
        <CardHeader className="bg-gradient-to-r from-cyan-50 to-blue-50">
          <CardTitle className="flex items-center gap-2">
            <Languages className="w-5 h-5 text-cyan-600" />
            תרגום טקסט לשפת סימנים
          </CardTitle>
        </CardHeader>
        <CardContent className="p-6">
          <div className="space-y-4">
            <div>
              <label className="block text-sm font-medium mb-2 text-slate-700">
                הכנס טקסט בעברית:
              </label>
              <Textarea
                value={hebrewText}
                onChange={(e) => setHebrewText(e.target.value)}
                placeholder="לדוגמה: שלום, מה שלומך?"
                className="min-h-32 text-lg"
                dir="rtl"
              />
            </div>
            <Button
              onClick={handleTranslate}
              disabled={!hebrewText.trim() || isTranslating}
              className="w-full bg-gradient-to-r from-cyan-500 to-blue-600 hover:from-cyan-600 hover:to-blue-700"
              size="lg"
            >
              {isTranslating ? (
                <>
                  <Loader2 className="w-5 h-5 ml-2 animate-spin" />
                  מתרגם...
                </>
              ) : (
                <>
                  <Languages className="w-5 h-5 ml-2" />
                  תרגם לשפת סימנים
                </>
              )}
            </Button>
          </div>
        </CardContent>
      </Card>

      <AnimatePresence>
        {signInstructions && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
          >
            <Card className="shadow-lg border-2 border-cyan-200">
              <CardHeader className="bg-gradient-to-r from-cyan-50 to-blue-50">
                <CardTitle className="text-cyan-700">הוראות לביצוע הסימנים</CardTitle>
              </CardHeader>
              <CardContent className="p-6">
                <div className="space-y-6">
                  {signInstructions.signs?.map((sign, index) => (
                    <motion.div
                      key={index}
                      initial={{ opacity: 0, x: -20 }}
                      animate={{ opacity: 1, x: 0 }}
                      transition={{ delay: index * 0.1 }}
                      className="p-4 bg-white rounded-lg border border-slate-200 hover:shadow-md transition-shadow"
                    >
                      <h3 className="text-xl font-bold text-slate-800 mb-3 flex items-center gap-2">
                        <span className="bg-cyan-500 text-white w-8 h-8 rounded-full flex items-center justify-center text-sm">
                          {index + 1}
                        </span>
                        {sign.word}
                      </h3>
                      <div className="space-y-2 text-slate-700">
                        <p className="text-base leading-relaxed bg-slate-50 p-3 rounded">
                          <strong>הוראות:</strong> {sign.instruction}
                        </p>
                        <div className="grid grid-cols-2 gap-3 text-sm">
                          <div className="bg-blue-50 p-2 rounded">
                            <strong className="text-blue-700">צורת יד:</strong> {sign.hand_shape}
                          </div>
                          <div className="bg-cyan-50 p-2 rounded">
                            <strong className="text-cyan-700">מיקום:</strong> {sign.location}
                          </div>
                          <div className="bg-teal-50 p-2 rounded">
                            <strong className="text-teal-700">תנועה:</strong> {sign.movement}
                          </div>
                          {sign.facial_expression && (
                            <div className="bg-purple-50 p-2 rounded">
                              <strong className="text-purple-700">הבעת פנים:</strong> {sign.facial_expression}
                            </div>
                          )}
                        </div>
                      </div>
                    </motion.div>
                  ))}

                  {signInstructions.notes && (
                    <div className="p-4 bg-amber-50 border border-amber-200 rounded-lg">
                      <p className="text-sm text-amber-800">
                        <strong>הערות:</strong> {signInstructions.notes}
                      </p>
                    </div>
                  )}
                </div>
              </CardContent>
            </Card>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
}