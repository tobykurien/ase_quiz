package za.org.ase.quiz.models

import org.javalite.activejdbc.Model
import org.javalite.activejdbc.annotations.BelongsTo

@BelongsTo(foreignKeyName='question_id',parent=Question)
class Answer extends Model {
   
   // Check if a submitted student answer is the correct answer. Must be run 
   // against a correct Answer model
   def boolean isCorrect(int questionType, long answerId, String answerText) {

      if (getBoolean("correct") == false) {
         // this answer is not correct, so we can't check for correctness here
         return false
      }
      
      if (answerId > 0) {
         // simple check for correct answer
         return answerId == (id as Long)
      }
      
      var text = getString("answer_text")
      if (text != null && text.trim.length > 0 && 
            answerText != null && answerText.trim.length > 0) {
         // TODO compare the two according to the question type
         if (text.trim.equalsIgnoreCase(answerText.trim)) {
            return true
         }
      }
      
      false
   }
   
}