//
//  TranslationManager.swift
//  Chatter Chinese
//
//  Created by Nelson Aquino Jr  on 3/15/22.
//

import Foundation
import MLKit
import NaturalLanguage
import FGReverser

struct TranslationManager {
    
    let recognizer = NLLanguageRecognizer()
    
    //MARK: - Translation
    func translateToChinese (text: String, completion: @escaping (String) -> ()) {
        var translation : String = String()
        
        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .chinese)
        let englishChineseTranslator = Translator.translator(options: options)
        let conditions = ModelDownloadConditions(
            allowsCellularAccess: false,
            allowsBackgroundDownloading: true
        )
        englishChineseTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }

            englishChineseTranslator.translate(text) { translatedText, error in
                if let translated = translatedText {
                    translation = translated
                    completion(translation)
                }
                
            }
        }
        
    }
    
    func translateToEnglish (text: String, completion: @escaping (String) -> ()) {
        var translation : String = String()
        let options = TranslatorOptions(sourceLanguage: .chinese, targetLanguage: .english)
        let englishChineseTranslator = Translator.translator(options: options)
        
        englishChineseTranslator.translate(text) { translatedText, error in
            if let translated = translatedText {
                translation = translated + "\n\n" + text.k3.pinyin
                completion(translation)
            }
            
        }
    }
    
    //MARK: - Language Recognizer
    func translateLanguage(text: String, completion: @escaping (String) -> ()) {
        recognizer.processString(text)
        
        if let language = recognizer.dominantLanguage {
            if language.rawValue == "zh-Hant" || language.rawValue == "zh" {
                translateToEnglish(text: text) {translatedText in
                   completion(translatedText)
                }
            } else if language.rawValue == "en" {
                translateToChinese(text: text) {translatedText in
                    completion(translatedText.fg_reversed())
                }
            }
            else {
                completion("Language not recognized")
            }
        }
        recognizer.reset()
    }
}
