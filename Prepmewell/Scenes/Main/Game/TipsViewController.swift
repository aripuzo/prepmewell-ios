//
//  TipsViewController.swift
//  Prepmewell
//
//  Created by Ari Tamunomiebi on 05/04/2022.
//

import UIKit
import XLPagerTabStrip

class TipsViewController: ButtonBarPagerTabStripViewController {
    
    var isReload = false

    override func viewDidLoad() {
        super.viewDidLoad()

        settings.style.buttonBarBackgroundColor = .white

        settings.style.selectedBarBackgroundColor = UIColor(named: "Accent")!
        settings.style.selectedBarHeight = 2

        // each buttonBar item is a UICollectionView cell of type ButtonBarViewCell
        settings.style.buttonBarItemBackgroundColor = .white
        settings.style.buttonBarItemFont = UIFont(name:"Calibre-Regular", size:16)!
        settings.style.buttonBarItemTitleColor = UIColor(named: "Text2")
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let child_1 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ScreenID.TIP) as! TipViewController
        child_1.header = "Writing Tips"
        child_1.body = "• Do spend enough time planning and gathering your ideas before you start writing. It will enable you write more quickly and stop less frequently to think what to write about.\n\n• Avoid repetition of  the same words, phrases and ideas. Explore different ideas to provide a well-balanced response.\n\n• Word count is important. You lose marks if you write fewer words; if you write a lot more words, the examiner will not assess them all and this will be time wasted.\n\n• Allow time at the end to check your answer for careless mistakes in spelling, subject-verb agreement, singular/plural nouns, and tenses.\n\n• Do not copy words and phrases from the question paper. Use your own words by paraphrasing the question.\n\n• Stay on topic. Do not include irrelevant information as you’ll get much lower score if you do.\n\n• If you have difficulties with keeping to time, consider task two before task one.\n\n• Do not waste your time memorizing essays or model answers as examiners are trained to spot pre-prepared answers.\n\n• Your use of language should be appropriate to they type of letter or essay required of you.\n\n• You need an introduction, clearly divided paragraphs and a conclusion.\n\n• Do not make your introduction too long. You need to allow enough time for the main part of your essay.\n\n• Be sure to provide supporting evidence for any opinion you give.\n\n•    All ideas in your paragraphs need to be supported by examples.\n\n• End your essay with a conclusion. Usually, this is a summary of your key points and your final view point.\n\n• Do not use abbreviation, note form or bullet points.\n\n• Yours sincerely is written at the end of a letter before your signature, typically a formal one in which then recipient is addressed by name.\n\n• “Yours faithfully” is used for ending a formal or business letter before your signature in which the recipient is not addressed by name and begins with “Dear Sir” or “Dear Madam”"
        child_1.info = "Writing"
        
        
        let child_2 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ScreenID.TIP) as! TipViewController
        child_2.header = "Listening Tips"
        child_2.body = "• Word Types: Go through the questions and find out which type of word in each gap. Is it a noun, verb, adverb or adjective? Write 'N' for noun, 'V' for verb and so on. This will help you to focus on the specific word forms while listening.\n\n• Put yourself in the situation: Try to get an idea of the situation. Before each part you will be given a short introduction: 'Now, you will hear a dialogue between…' or 'you will hear a lecture on…' This information is not written on the question paper, so be attentive. Note: who are the speakers, why are they speaking and where are they. This will make understanding the rest of the recording much easier.\n\n• Be attentive: the audio plays just once. So if you didn't hear some words and passed over some questions, don't worry! Leave them blank and focus on the actual part. Review those questions at the end of the section, otherwise, you will only miss more questions and tangle in the recording. You will need to read, write and listen all at the same time.\n\n• Study the format: This is very important for questions made in tabular form. Study the format used in each column and row to have a clue of what the answer should be.\n\n• Be attentive: the audio plays just once. So if you didn't hear some words and passed over some questions, don't worry! Leave them blank and focus on the actual part. Review those questions at the end of the section, otherwise, you will only miss more questions and tangle in the recording. You will need to read, write and listen all at the same time.\n\n• Words-indicators: Pay attention to words-indicators, such as however, but,  firstly, most importantly, then, finally. They help you to anticipate what the speaker will say.\n\n• Don’t rush to write answers: A lot of people as soon as they hear the needed information, they take it for the correct answer. But sometimes this information is repeated or corrected further in the section. They are sometimes “distractors”.\n\n• Be aware of synonyms. For example, if one of the multiple choice answers is “on foot”, the answer could be “John walks to work.”\n\n• When you are given a diagram, map or process flow-chart, it is absolutely essential to locate your starting point first.\n\n• Do not write more than the maximum number of words or letters allowed for each answer.\n\n• Check for mistakes: After each section you have 30 seconds to check your answers. It is important to check spelling, plurals and word forms. Remember that only correctly written answers will gain points.\n\n• Don’t leave any blank answers: You won't lose marks for incorrect answers, so even if you don't know the answer it is better to write something in the answers box. Read the question again and make a guess!\n\n• Transfer answers accurately: At the end of the listening test you will have 10 minutes for transferring your answers into the answer sheet. And quite often students get confused in the numeration! As you write down your answers, check that they fit into the correct numbered space. In other words, make sure that answer for question 7 goes into space number 7."
        child_2.info = "Listening"
        
        let child_3 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ScreenID.TIP) as! TipViewController
        child_3.header = "Speaking Tips"
        child_3.body = "• Try to talk as much as you can\n\n• Talk as fluently as possible and be spontaneous\n\n• Relax, be confident and enjoy using your English\n\n• Develop your answers\n\n• Speak more than the examiner\n\n• Ask for clarification if necessary\n\n• Do not learn prepared answers; the examiner is trained to spot this and will change the question\n\n• Express your opinions; you will be assessed on your ability to communicate\n\n• The examiner’s questions tend to be fairly predictable; practise at home and record yourself"
        child_3.info = "Speaking"
        
        let child_4 = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ScreenID.TIP) as! TipViewController
        child_4.header = "Reading Tips"
        child_4.body = "• Look carefully at any text title, subtitles. It will give you a quick overview of what the text is about.\n\n• When gap filling, read the gapped text carefully and think about the meaning and grammar of suitable words to fill the gaps.\n\n• Read the instructions for each task carefully. Check the maximum number of words allowed.\n\n• If a text is organized into paragraphs, a good way to get the general meaning and to familiarize yourself with the overall content is to spend the first 2-3 minutes reading only the first and last sentence of each paragraph.\n\n• Skim over and watch for the answers: Skimming refers to looking only for the main ideas. You don't need to read attentively every word. Remember, you just need to answer the questions, nothing more. So skim over the text and then start looking for the answers.\n\n• Watch your time: Don’t forget you have only 60 minutes to read three texts and answer 40 questions. You won’t get additional time for filling your answer sheet, so make sure manage your time properly.\n\n• Is your spelling correct? Check your spelling before writing your answer on the answer blank. You will get zero points for the answer if it's spelled incorrectly.\n\n• Keep the order: Remember that the questions follow the order of the text in most cases. So the answer to question 5 will come after the answer to question 4 and so on.\n\n• Underline! When you skim over the text, underline the most important phrases. It will help you to save some time when you will search for answers.\n\n• Unfamiliar vocabulary? Do not worry if the text seems unfamiliar to you or you don’t know some words. Every answer can be found in the text, you don’t need any additional knowledge to succeed.\n\n• Pay attention to the details: Look thoroughly through the text. Any special features such as capital letters, underlining, italics, figures, graphs and tables are likely to matter.\n\n• No blank boxes: Answer all the questions, even if you’re not sure in your answer. You don't get penalty for wrong answers, so try your luck and write the most probable answer.\n\n• Cross out the wrong answers: If you saw answer that you're sure is wrong, cross it out. This way you won't get confused and save your time.\n\n• With multiple choice questions, try and use common sense to eliminate some of the answer options.\n\n• Choose your own technique: It may sound strange at first, but... There is no ultimate advice which technique fits you the best. You should choose yourself how to search for right answers and what to do first: read questions or text. A lot of successful candidates prefer to read the text first, and only then answer the questions. But some say it's better to do the other way.\n\n• Do not forget that answers must be written directly on the answer sheet as no extra time will be given at the end of the 60 minutes test.\n\n• Written answers need to be grammatically accurate and spelled correctly. You will lose marks for incorrect spelling.\n\n• Think about skipping difficult questions and coming back to them later."
        child_4.info = "Reading"

        guard isReload else {
            return [child_1, child_2, child_3, child_4]
        }

        var childViewControllers = [child_1, child_2, child_3, child_4]

        for index in childViewControllers.indices {
            let nElements = childViewControllers.count - index
            let n = (Int(arc4random()) % nElements) + index
            if n != index {
                childViewControllers.swapAt(index, n)
            }
        }
        let nItems = 1 + (arc4random() % 8)
        return Array(childViewControllers.prefix(Int(nItems)))
    }

    override func reloadPagerTabStripView() {
        isReload = true
        if arc4random() % 2 == 0 {
            pagerBehaviour = .progressive(skipIntermediateViewControllers: arc4random() % 2 == 0, elasticIndicatorLimit: arc4random() % 2 == 0 )
        } else {
            pagerBehaviour = .common(skipIntermediateViewControllers: arc4random() % 2 == 0)
        }
        super.reloadPagerTabStripView()
    }

}
