import React, { useState, useRef } from 'react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Loader2, Camera, Upload, FileText } from 'lucide-react';
import { base44 } from '@/api/base44Client';
import { motion, AnimatePresence } from 'framer-motion';

export default function SignToText({ onTranslationComplete }) {
  const [selectedImage, setSelectedImage] = useState(null);
  const [imagePreview, setImagePreview] = useState(null);
  const [isProcessing, setIsProcessing] = useState(false);
  const [translatedText, setTranslatedText] = useState(null);
  const fileInputRef = useRef(null);

  const handleImageSelect = (e) => {
    const file = e.target.files[0];
    if (file) {
      setSelectedImage(file);
      const reader = new FileReader();
      reader.onloadend = () => {
        setImagePreview(reader.result);
      };
      reader.readAsDataURL(file);
      setTranslatedText(null);
    }
  };

  const handleTranslate = async () => {
    if (!selectedImage) return;

    setIsProcessing(true);
    try {
      // Upload the image first
      const uploadResult = await base44.integrations.Core.UploadFile({
        file: selectedImage
      });

      // Process with AI
      const result = await base44.integrations.Core.InvokeLLM({
        prompt: `אתה מומחה לשפת הסימנים הישראלית (ISL - Israeli Sign Language).

נתת תמונה של אדם מבצע שפת סימנים. נתח את התמונה ותרגם את שפת הסימנים לטקסט בעברית.

שים לב ל:
- מיקום הידיים
- צורת הידיים
- תנועות
- הבעות פנים
- הקשר הכללי

אם אתה לא יכול לזהות בבירור את הסימן, ציין זאת והסבר מה אתה רואה.

השב בפורמט JSON:
{
  "detected_signs": ["רשימה של סימנים שזוהו"],
  "hebrew_text": "התרגום המלא לעברית",
  "confidence": "רמת ביטחון (גבוהה/בינונית/נמוכה)",
  "notes": "הערות נוספות על מה שנראה בתמונה"
}`,
        file_urls: [uploadResult.file_url],
        response_json_schema: {
          type: "object",
          properties: {
            detected_signs: {
              type: "array",
              items: { type: "string" }
            },
            hebrew_text: { type: "string" },
            confidence: { type: "string" },
            notes: { type: "string" }
          }
        }
      });

      setTranslatedText(result);

      // Save to history
      await base44.entities.Translation.create({
        source_text: result.detected_signs?.join(', ') || 'תמונת שפת סימנים',
        target_description: result.hebrew_text,
        translation_type: 'sign_to_text',
        image_url: uploadResult.file_url
      });

      if (onTranslationComplete) {
        onTranslationComplete();
      }
    } catch (error) {
      console.error('Processing error:', error);
    } finally {
      setIsProcessing(false);
    }
  };

  return (
    <div className="space-y-6">
      <Card className="shadow-lg">
        <CardHeader className="bg-gradient-to-r from-orange-50 to-pink-50">
          <CardTitle className="flex items-center gap-2">
            <Camera className="w-5 h-5 text-orange-600" />
            תרגום שפת סימנים לטקסט
          </CardTitle>
        </CardHeader>
        <CardContent className="p-6">
          <div className="space-y-4">
            <div className="text-center">
              {imagePreview ? (
                <div className="relative">
                  <img
                    src={imagePreview}
                    alt="Sign language"
                    className="max-h-96 mx-auto rounded-lg shadow-md"
                  />
                  <Button
                    variant="outline"
                    size="sm"
                    className="mt-3"
                    onClick={() => {
                      setSelectedImage(null);
                      setImagePreview(null);
                      setTranslatedText(null);
                      if (fileInputRef.current) fileInputRef.current.value = '';
                    }}
                  >
                    בחר תמונה אחרת
                  </Button>
                </div>
              ) : (
                <div className="border-2 border-dashed border-slate-300 rounded-lg p-12 hover:border-orange-400 transition-colors">
                  <Upload className="w-16 h-16 mx-auto text-slate-400 mb-4" />
                  <p className="text-slate-600 mb-4">העלה תמונה של שפת סימנים</p>
                  <Input
                    ref={fileInputRef}
                    type="file"
                    accept="image/*"
                    capture="environment"
                    onChange={handleImageSelect}
                    className="max-w-xs mx-auto"
                  />
                </div>
              )}
            </div>

            {selectedImage && !translatedText && (
              <Button
                onClick={handleTranslate}
                disabled={isProcessing}
                className="w-full bg-gradient-to-r from-orange-500 to-pink-600 hover:from-orange-600 hover:to-pink-700"
                size="lg"
              >
                {isProcessing ? (
                  <>
                    <Loader2 className="w-5 h-5 ml-2 animate-spin" />
                    מעבד תמונה...
                  </>
                ) : (
                  <>
                    <FileText className="w-5 h-5 ml-2" />
                    תרגם לעברית
                  </>
                )}
              </Button>
            )}
          </div>
        </CardContent>
      </Card>

      <AnimatePresence>
        {translatedText && (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
          >
            <Card className="shadow-lg border-2 border-orange-200">
              <CardHeader className="bg-gradient-to-r from-orange-50 to-pink-50">
                <CardTitle className="text-orange-700">התרגום לעברית</CardTitle>
              </CardHeader>
              <CardContent className="p-6">
                <div className="space-y-4">
                  <div className="p-6 bg-white border-2 border-orange-300 rounded-lg">
                    <p className="text-2xl font-bold text-slate-800 text-center" dir="rtl">
                      {translatedText.hebrew_text}
                    </p>
                  </div>

                  {translatedText.detected_signs?.length > 0 && (
                    <div className="p-4 bg-blue-50 rounded-lg">
                      <h4 className="font-semibold text-blue-800 mb-2">סימנים שזוהו:</h4>
                      <div className="flex flex-wrap gap-2">
                        {translatedText.detected_signs.map((sign, index) => (
                          <span
                            key={index}
                            className="px-3 py-1 bg-blue-200 text-blue-800 rounded-full text-sm"
                          >
                            {sign}
                          </span>
                        ))}
                      </div>
                    </div>
                  )}

                  <div className="flex items-center gap-2 p-3 bg-slate-100 rounded-lg text-sm">
                    <strong className="text-slate-700">רמת ביטחון:</strong>
                    <span className={`font-semibold ${
                      translatedText.confidence === 'גבוהה' ? 'text-green-600' :
                      translatedText.confidence === 'בינונית' ? 'text-yellow-600' :
                      'text-red-600'
                    }`}>
                      {translatedText.confidence}
                    </span>
                  </div>

                  {translatedText.notes && (
                    <div className="p-4 bg-amber-50 border border-amber-200 rounded-lg">
                      <p className="text-sm text-amber-800">
                        <strong>הערות:</strong> {translatedText.notes}
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